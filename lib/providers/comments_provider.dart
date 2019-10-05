import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/comment_chain/comment.dart'
    as CommentPojo;
import 'package:http/http.dart' as http;

class CommentsProvider with ChangeNotifier {
  String result = "";
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  CommentsProvider() {}

  void process(List<dynamic> commentList, int level) {
    for (int i = 0; i < commentList.length; i++) {
      if (commentList.elementAt(i)['kind'] == null) {
        continue;
      }
      if (commentList.elementAt(i)['kind'] != 't1') {
        continue;
      }
      Map<String, dynamic> dataMap = commentList.elementAt(i)['data'];
    }
  }

  Future<void> fetchComments({String subredditName, String sort}) async {
    final url =
        'https://www.reddit.com/r/android/comments/dd4nl3/_/.json?context=1&showedits=true&threaded=false&limit=100&depth=4';
    final response = await http.get(url,
        headers: {'User-Agent': 'fritter_for_reddit by /u/SexusMexus'});
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      final c = CommentPojo.Comment.fromMap(json.decode(response.body)[1]);

      Queue<CommentPojo.Child> q = Queue.from(c.data.children);
      List<CommentPojo.Child> finalList = new List<CommentPojo.Child>();
      while (q.isNotEmpty) {
        final x = q.removeFirst();
        if (x.kind != CommentPojo.Kind.MORE)
          print(x.data.depth.toString() + " " + x.data.author);
        finalList.add(x);
      }
      notifyListeners();
    } else {
      print('fetch failed');
    }
  }
}
