import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:draw/draw.dart';
import 'package:flutter/foundation.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/pages/user_page/submission_with_image.dart';
import 'package:fritter_for_reddit/pages/user_page/user_page.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';
import 'package:meta/meta.dart';

part 'userpage_event.dart';

part 'userpage_state.dart';

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  final String username;
  RedditorRef redditorRef;
  Sort sortType = Sort.newest;
  List<SubmissionWithImageData> _submissions = [];
  List<Comment> _comments = [];

  UserPageBloc({@required this.username, @required FeedProvider feedProvider}) {
    redditorRef = feedProvider.fetchUserInfo(username);
    _initStream();
  }

  @override
  UserPageState get initialState => UserPageInitial();

  @override
  Stream<UserPageState> mapEventToState(
    UserPageEvent event,
  ) async* {
    if (event is YieldUserPageState) {
      yield event.state;
      return;
    }
  }

  _initStream([Stream<UserContent> contentStream]) async {
    contentStream ??= redditorRef.newest();
    await for (UserContent userContent in contentStream) {
      if (userContent is Submission) {
        Uint8List imageBytes;
        if (userContent.preview.isNotEmpty) {
          imageBytes = await getImageAsBytes(
            userContent.preview.first.source.url.toString(),
          );
        }

        _submissions.add(
          SubmissionWithImageData(
            submission: userContent,
            imageData: imageBytes,
          ),
        );

        add(YieldUserPageState(state.copyWith(submissions: _submissions)));
      } else {
        assert(userContent is Comment);
        _comments.add(userContent);
        add(YieldUserPageState(state.copyWith(comments: _comments)));
      }
    }
  }
}
