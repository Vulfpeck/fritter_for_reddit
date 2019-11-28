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

  var collapsedChildrenCount = new Map();

  List<CommentPojo.Child> _commentsList;
  List<CommentPojo.Child> get commentsList => _commentsList;

  String moreParentLoadingId = "";
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
    String url;
    this.sort = sort;
    if (_storageHelper.signInStatus) {
      url =
          'https://oauth.reddit.com/r/$subredditName/comments/$postId/_/.json?sort=$sortString&showedits=true&threaded=false&depth=3';
      try {
        final response = await http.get(
          url,
          headers: {
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
            'Authorization': 'bearer ' + authToken,
          },
        );
        print(url);
        print(response.statusCode.toString() + "••••••••••••••");
        if (response.statusCode == 200) {
          _commentsList = new List<CommentPojo.Child>();
//      print(json.decode(response.body));
          final c = CommentPojo.Comment.fromMap(json.decode(response.body)[1]);

          Queue<CommentPojo.Child> q = Queue.from(c.data.children);
          List<CommentPojo.Child> finalList = new List<CommentPojo.Child>();
          while (q.isNotEmpty) {
            var x = q.removeFirst();
            if (x.kind == CommentPojo.Kind.T1 ||
                (x.kind == CommentPojo.Kind.MORE) &&
                    x.data.children.length != 0) {
              finalList.add(x);
            }
          }

          _commentsList = finalList;
        } else {
          print(response.statusCode);
          print('fetch failed');
        }
      } catch (e) {
        print('Exceptions ${e.toString()}');
      }
    } else {
      url =
          'https://api.reddit.com/r/$subredditName/comments/$postId/_/.json?sort=$sortString&showedits=true&threaded=false&depth=3';
      try {
        final response = await http.get(
          url,
          headers: {
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        );
        print(url);
        print(response.statusCode.toString() + "••••••••••••••");
        if (response.statusCode == 200) {
          _commentsList = new List<CommentPojo.Child>();
//      print(json.decode(response.body));
          final c = CommentPojo.Comment.fromMap(json.decode(response.body)[1]);

          Queue<CommentPojo.Child> q = Queue.from(c.data.children);
          List<CommentPojo.Child> finalList = new List<CommentPojo.Child>();
          while (q.isNotEmpty) {
            var x = q.removeFirst();
            if (x.kind == CommentPojo.Kind.T1 ||
                (x.kind == CommentPojo.Kind.MORE) &&
                    x.data.children.length != 0) {
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
      } catch (e) {
        print('Exceptions ${e.toString()}');
      }
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
    moreParentLoadingId = moreParentId;
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

    if (_storageHelper.signInStatus) {
      String authToken = await _storageHelper.authToken;
      final url =
          'https://oauth.reddit.com/api/morechildren?link_id=$id&api_type=json&children=$childrenString&sort={$ChangeCommentSortConvertToString[this.sort]}&depth=2';
      try {
        final response = await http.get(
          url,
          headers: {
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
            'Authorization': 'bearer ' + authToken,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final CommentMoreEntity _moreComments =
              new CommentMoreEntity.fromJson(
            json.decode(response.body),
          );
          print("comments saved in the entity");
          CommentPojo.Child parent = _commentsList.firstWhere((ele) {
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
    } else {
      final url =
          'https://api.reddit.com/api/morechildren?link_id=$id&api_type=json&children=$childrenString&sort={$ChangeCommentSortConvertToString[this.sort]}';
      try {
        final response = await http.get(
          url,
          headers: {
            'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final CommentMoreEntity _moreComments =
              new CommentMoreEntity.fromJson(
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
    }

    moreParentLoadingId = "";
    _commentsMoreLoadingState = ViewState.Idle;
    notifyListeners();
  }

  Future<int> collapseUncollapseComment(
      {@required CommentPojo.Child comment, @required bool collapse}) async {
    int index = _commentsList.indexWhere(
      (ele) {
        return ele.data.id == comment.data.id;
      },
    );
    comment.data.collapse = collapse;
    comment.data.collapseParent = collapse;
    index++;
    int count = 0;
    while (index < _commentsList.length) {
      if (_commentsList.elementAt(index).data.depth <= comment.data.depth) {
        break;
      } else {
        _commentsList.elementAt(index).data.collapse = collapse;
        _commentsList.elementAt(index).data.collapseParent = false;
      }
      index++;
      count++;
    }
    if (collapse) {
      collapsedChildrenCount[comment.data.id] = count;
    } else {
      collapsedChildrenCount.remove(comment.data.id);
    }
    notifyListeners();
    return count;
  }

  Future<bool> voteComment({@required String id, @required int dir}) async {
    await _storageHelper.fetchData();
    CommentPojo.Child item = _commentsList.firstWhere((v) {
      return v.data.id.compareTo(id) == 0 ? true : false;
    });
    notifyListeners();
    if (item.data.likes == true) {
      item.data.score--;
    } else if (item.data.likes == false) {
      item.data.score++;
    }
    if (dir == 1) {
      item.data.score++;
      item.data.likes = true;
    } else if (dir == -1) {
      item.data.score--;
      item.data.likes = false;
    } else if (dir == 0) {
      item.data.score =
          item.data.likes == true ? item.data.score-- : item.data.score++;
      item.data.likes = null;
    }
    String url = "https://oauth.reddit.com/api/vote";
    final String authToken = await _storageHelper.authToken;
    print(authToken);
    http.Response voteResponse;
    voteResponse = await http.post(
      url + '?dir=$dir&id=$id&rank=2',
      headers: {
        'Authorization': 'bearer ' + authToken,
        'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
      },
    );

    notifyListeners();
    if (voteResponse.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
