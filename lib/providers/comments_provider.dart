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
  Map<String, List<CommentPojo.Child>> commentsMap = {};

  String moreParentLoadingId = "";
  SecureStorageHelper _storageHelper;

  CommentsProvider() {
    _storageHelper = new SecureStorageHelper();
  }

  Future<void> fetchComments({
    @required String subredditName,
    @required String postId,
    @required CommentSortTypes sort,
    @required bool requestingRefresh,
  }) async {
    _commentsLoadingState = ViewState.Busy;
    notifyListeners();
    if (requestingRefresh || commentsMap[postId] == null) {
      await _storageHelper.init();
      String authToken = await _storageHelper.authToken;
      String sortString = changeCommentSortConvertToString[sort];
      String url;
      this.sort = sort;
      if (_storageHelper.signInStatus) {
        if (await _storageHelper.needsTokenRefresh()) {
          _storageHelper.performTokenRefresh();
        }
        url =
            'https://oauth.reddit.com/r/$subredditName/comments/$postId/_/.json?sort=$sortString&showedits=true&threaded=false';
        try {
          final response = await http.get(
            url,
            headers: {
              'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
              'Authorization': 'bearer ' + authToken,
            },
          );
          if (response.statusCode == 200) {
//      // // print(json.decode(response.body));
            final c =
                CommentPojo.Comment.fromMap(json.decode(response.body)[1]);

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

            commentsMap[postId] = finalList;
          } else {
//            // // print(response.statusCode);
//            // // print('fetch failed');
          }
        } catch (e) {
//          // // print('Exceptions ${e.toString()}');
        }
      } else {
        url =
            'https://api.reddit.com/r/$subredditName/comments/$postId/_/.json?sort=$sortString&showedits=true&threaded=false';
        try {
          final response = await http.get(
            url,
            headers: {
              'User-Agent': 'fritter_for_reddit by /u/SexusMexus',
            },
          );
//          // // print(url);
//          // // print(response.statusCode.toString() + "••••••••••••••");
          if (response.statusCode == 200) {
//      // // print(json.decode(response.body));
            final c =
                CommentPojo.Comment.fromMap(json.decode(response.body)[1]);

            Queue<CommentPojo.Child> q = Queue.from(c.data.children);
            List<CommentPojo.Child> finalList = new List<CommentPojo.Child>();
            while (q.isNotEmpty) {
              var x = q.removeFirst();
              if (x.kind == CommentPojo.Kind.T1 ||
                  (x.kind == CommentPojo.Kind.MORE) &&
                      x.data.children.length != 0) {
//          // // print(" | " * x.data.depth + "-" + x.data.author)
                finalList.add(x);
                if (x.kind == CommentPojo.Kind.MORE) {
//            // // print(x.data.children);
                }
              }
            }
            commentsMap[postId] = finalList;
          } else {
            // // print(response.statusCode);
            // // print('fetch failed');
          }
        } catch (e) {
          // // print('Exceptions ${e.toString()}');
        }
      }
    } else {}
    _commentsLoadingState = ViewState.Idle;
    notifyListeners();
  }

  Future<void> fetchChildren({
    @required List<String> children,
    @required String postId,
    @required String postFullName,
    @required String moreParentId,
  }) async {
    _commentsMoreLoadingState = ViewState.Busy;
    moreParentLoadingId = moreParentId;
    notifyListeners();

    if (await _storageHelper.needsTokenRefresh()) {
      _storageHelper.performTokenRefresh();
    }
    String childrenString = "";
    if (children != null)
      for (String child in children) {
        childrenString += child + ",";
      }
    else
    // // print('children is null');

    if (childrenString != "") {
      childrenString = childrenString.substring(0, childrenString.length - 2);
    }

    if (_storageHelper.signInStatus) {
      String authToken = await _storageHelper.authToken;
      // // print("User is auth so using oauth to get more comments");
      final url =
          'https://oauth.reddit.com/api/morechildren?link_id=$postFullName&api_type=json&children=$childrenString&sort=${changeCommentSortConvertToString[this.sort]}';
      // // print(url);
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
          // // print("comments saved in the entity");
          CommentPojo.Child parent = commentsMap[postId].firstWhere((ele) {
            if (ele.data.id.compareTo(moreParentId) == 0) {
              return true;
            } else {
              return false;
            }
          });
          int parentIndex = commentsMap[postId].indexOf(parent);
          // // print(parent.kind);
          // // print(parent.data.children);
          // // print(parentIndex);
          commentsMap[postId].remove(parent);
          for (var x in _moreComments.json.data.things) {
            commentsMap[postId].insert(
              parentIndex++,
              new CommentPojo.Child.fromMap(
                x.toJson(),
              ),
            );
          }
//        // // print(_moreComments.json);
        } else {
          // // print(response.reasonPhrase);
          // // print("there was an error fetching the comments");
        }
      } catch (e) {
        // // print(e.toString());
      }
    } else {
      final url =
          'https://api.reddit.com/api/morechildren?link_id=$postFullName&api_type=json&children=$childrenString&sort={$changeCommentSortConvertToString[this.sort]}';
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
          // // print("comments saved in the entity");
          CommentPojo.Child parent = commentsMap[postId].firstWhere((ele) {
            // // print(ele.data.id);
            if (ele.data.id.compareTo(moreParentId) == 0) {
              return true;
            } else {
              return false;
            }
          });
          int parentIndex = commentsMap[postId].indexOf(parent);
          // // print(parent.kind);
          // // print(parent.data.children);
          // // print(parentIndex);
          commentsMap[postId].remove(parent);
          for (var x in _moreComments.json.data.things) {
            commentsMap[postId].insert(
              parentIndex++,
              new CommentPojo.Child.fromMap(
                x.toJson(),
              ),
            );
          }
//        // // print(_moreComments.json);
        } else {
          // // print("there was an error fetching the comments");
        }
      } catch (e) {
        // // print(e.toString());
      }
    }

    moreParentLoadingId = "";
    _commentsMoreLoadingState = ViewState.Idle;
    notifyListeners();
  }

  Future<int> collapseUncollapseComment({
    @required int parentCommentIndex,
    @required bool collapse,
    @required postId,
  }) async {
    // first find where the "parent" is in the list
    int index = parentCommentIndex;
    CommentPojo.Child comment =
        commentsMap[postId].elementAt(parentCommentIndex);
    comment.data.collapse = collapse;
    comment.data.collapseParent = collapse;
    index++;
    int count = 0;
    // iterate through comments until you find one which has more depth than the parent
    while (index < commentsMap[postId].length) {
      if (commentsMap[postId].elementAt(index).data.depth <=
          comment.data.depth) {
        break;
      } else {
        commentsMap[postId].elementAt(index).data.collapseParent = false;
        commentsMap[postId].elementAt(index).data.collapse = collapse;
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

  Future<bool> voteComment(
      {@required String id, @required int dir, @required postId}) async {
    await _storageHelper.fetchData();
    CommentPojo.Child item = commentsMap[postId].firstWhere((v) {
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
    // // print(authToken);
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
