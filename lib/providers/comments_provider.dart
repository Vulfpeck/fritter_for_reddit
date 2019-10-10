import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/comment_chain/comment.dart'
    as CommentPojo;
import 'package:flutter_provider_app/models/comment_chain/comment_more_entity.dart';
import 'package:http/http.dart' as http;

class CommentsProvider with ChangeNotifier {
  String result = "";
  CommentSortTypes sort;
  ViewState _commentsLoadingState = ViewState.Idle;
  ViewState _commentsMoreLoadingState = ViewState.Idle;

  ViewState get commentsLoadingState => _commentsLoadingState;
  ViewState get commentsMoreLoadingState => _commentsMoreLoadingState;

  List<CommentPojo.Child> _commentsList;
  List<CommentPojo.Child> get commentsList => _commentsList;
  SecureStorageHelper _storageHelper;

  CommentsProvider() {
    _storageHelper = new SecureStorageHelper();
  }

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
    CommentSortTypes sort,
  }) async {
    await _storageHelper.init();
    String authToken = await _storageHelper.authToken;
    _commentsLoadingState = ViewState.Busy;
    notifyListeners();
    String sortString = ChangeCommentSortConvertToString[sort];

    this.sort = sort;
    final url =
        'https://oauth.reddit.com/r/$subredditName/comments/$postId/_/.json?sort=$sortString&showedits=true&threaded=false';
    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
        'Authorization': 'bearer ' + authToken,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      _commentsList = new List<CommentPojo.Child>();
//      print(json.decode(response.body));
      final c = CommentPojo.Comment.fromMap(json.decode(response.body)[1]);

      Queue<CommentPojo.Child> q = Queue.from(c.data.children);
      List<CommentPojo.Child> finalList = new List<CommentPojo.Child>();
      while (q.isNotEmpty) {
        var x = q.removeFirst();
        if (x.kind == CommentPojo.Kind.T1 || x.kind == CommentPojo.Kind.MORE) {
//          print(" | " * x.data.depth + "-" + x.data.author)
          finalList.add(x);
          if (x.kind == CommentPojo.Kind.MORE) {
//            print(x.data.children);
          }
        }
      }

      _commentsList = finalList;
    } else {
      print(response.statusCode);
      print('fetch failed');
    }
    _commentsLoadingState = ViewState.Idle;
    notifyListeners();
  }

  Future<void> fetchChildren({
    List<String> children,
    String id,
    String moreParentId,
  }) async {
    _commentsMoreLoadingState = ViewState.Busy;
    notifyListeners();
    String childrenString = "";
    if (children != null)
      for (String child in children) {
        childrenString += child + ", ";
      }
    else
      print('children is null');

    if (childrenString != "") {
      childrenString = childrenString.substring(0, childrenString.length - 2);
    }
    String authToken = await _storageHelper.authToken;
    print(childrenString);
    print("more id : " + moreParentId);
    final url =
        'https://oauth.reddit.com/api/morechildren?link_id=$id&api_type=json&children=$childrenString&sort={$ChangeCommentSortConvertToString[this.sort]}';
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          'Authorization': 'bearer ' + authToken,
        },
      );

//      print(response.statusCode);
//      print(json.decode(response.body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final CommentMoreEntity _moreComments = new CommentMoreEntity.fromJson(
          json.decode(response.body),
        );
        print("comments saved in the entity");
        CommentPojo.Child parent = _commentsList.firstWhere((ele) {
          print(ele.data.id);
          if (ele.data.id.compareTo(moreParentId) == 0) {
            return true;
          } else {
            return false;
          }
        });
        int parentIndex = _commentsList.indexOf(parent);
        print(parent.kind);
        print(parent.data.children);
        print(parentIndex);
        _commentsList.remove(parent);
        for (var x in _moreComments.json.data.things) {
          _commentsList.insert(
            parentIndex++,
            new CommentPojo.Child.fromMap(
              x.toJson(),
            ),
          );
        }
//        print(_moreComments.json);
      } else {
        print("there was an error fetching the comments");
      }
    } catch (e) {
      print(e.toString());
    }
    _commentsMoreLoadingState = ViewState.Idle;
    notifyListeners();
  }
}
