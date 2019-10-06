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

  List<CommentPojo.Child> _commentsList;
  List<CommentPojo.Child> get commentsList => _commentsList;

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

  Future<void> fetchComments({
    String subredditName,
    String postId,
    String sort,
  }) async {
    _state = ViewState.Busy;
    notifyListeners();
    final url =
        'https://www.reddit.com/r/$subredditName/comments/$postId/_/.json?showedits=true&threaded=false&depth=4';
    final response = await http.get(url,
        headers: {'User-Agent': 'fritter_for_reddit by /u/SexusMexus'});
    if (response.statusCode == 200) {
//      print(json.decode(response.body));
      final c = CommentPojo.Comment.fromMap(json.decode(response.body)[1]);

      Queue<CommentPojo.Child> q = Queue.from(c.data.children);
      List<CommentPojo.Child> finalList = new List<CommentPojo.Child>();
      while (q.isNotEmpty) {
        var x = q.removeFirst();
        if (x.kind == CommentPojo.Kind.T1) {
          print(" | " * x.data.depth + "-" + x.data.author);
          finalList.add(x);
        }
      }

      _commentsList = finalList;
    } else {
      print('fetch failed');
    }
    _state = ViewState.Idle;
    notifyListeners();
  }
}
