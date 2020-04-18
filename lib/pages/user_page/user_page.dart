import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:draw/draw.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/pages/user_page/bloc/userpage_bloc.dart';
import 'package:fritter_for_reddit/pages/user_page/submission_with_image.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';
import 'package:http/http.dart';

class UserPage extends StatefulWidget {
  final String username;

  const UserPage({Key key, @required this.username}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserPageBloc bloc;

  @override
  void initState() {
    bloc = UserPageBloc(
      username: widget.username,
      feedProvider: FeedProvider.of(context),
    );
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPageBloc, UserPageState>(
      bloc: bloc,
      builder: (BuildContext context, state) {
        var uniqueSubmissions = state.uniqueSubmissions;
        return Scaffold(
          appBar: AppBar(),
          body: Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: state.submissions.length,
                  itemBuilder: (BuildContext context, int index) {
                    SubmissionWithImageData submissionWithImageData =
                        state.submissions[index];
                    return ListTile(
                      title: Text(submissionWithImageData.submission.title),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    Comment comment = state.comments[index];
                    return ListTile(
                      title: Text(comment.body),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getImages() async {
    List<Response> response = await Future.wait([
      get('https://b.thumbs.redditmedia.com/03I8Yuf5SA66jYs5jVDryi9PRuq3irg76ACRPEsLHjM.jpg'),
      get('https://b.thumbs.redditmedia.com/Cj-kgC1D8luQMYDQy6ZOM3yNmxGN9VRDXp7P-Zb60TM.jpg')
    ]);
    bool equal = true;
    final Uint8List imageABytes = response.first.bodyBytes;
    final imageBBytes = response.last.bodyBytes;
    for (var i = 0; i < imageBBytes.length; ++i) {
      var a = imageABytes[i];
      var b = imageBBytes[i];
      if (a != b) {
        equal = false;
        break;
      }
    }
    return;
  }

  Widget demo() {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
          'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'
        ].map((e) => getImageAsBytes(e))),
        builder:
            (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            var data; // = snapshot.data.uniqueBy((value) => true);
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.memory(data[index]);
              },
            );
          }
        },
      ),
    );
  }
}

Future<Uint8List> getImageAsBytes(String url) async =>
    get(url).then((response) => response.bodyBytes);

bool listEquality(List a, List b) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; ++i) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

Map<dynamic, List> difference(Map a, Map b) {
  var maxLength = max(a.length, b.length);
  final differenceMap = {};
  final similaritiesMap = {};
  for (var i = 0; i < maxLength; ++i) {
    final aKey = a.keys.toList()[i];
    final bKey = b.keys.toList()[i];
    assert(aKey == bKey);
    var aValue = a[aKey];
    var bValue = b[aKey];

    if (aValue != bValue) {
      differenceMap[aKey] = [aValue, bValue];
    } else {
      similaritiesMap[aKey] = aValue;
    }
  }
  return differenceMap;
}
