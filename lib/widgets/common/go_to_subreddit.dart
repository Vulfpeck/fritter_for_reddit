import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../exports.dart';

class GoToSubredditWidget extends StatefulWidget {
  @override
  _GoToSubredditWidgetState createState() => _GoToSubredditWidgetState();
}

class _GoToSubredditWidgetState extends State<GoToSubredditWidget> {
  final TextEditingController _subredditGoTextController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        decoration: InputDecoration(
          hintText: 'Goto subreddit',
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 2,
            ),
          ),
        ),
        autofocus: false,
        autocorrect: false,
        controller: _subredditGoTextController,
        onSubmitted: (value) {
          loadNewSubreddit(context, value);
        },
      ),
      trailing: IconButton(
        tooltip: "Go",
        icon: Icon(
          Icons.arrow_forward,
        ),
        onPressed: () {
          loadNewSubreddit(context, _subredditGoTextController.text);
        },
      ),
    );
  }

  loadNewSubreddit(BuildContext context, String text) {
    if (_subredditGoTextController.text == "") {
      return;
    }
    final text = _subredditGoTextController.text.replaceAll(" ", "");
    Navigator.of(context).pop();
    return Navigator.of(
      context,
      rootNavigator: false,
    ).push(
      CupertinoPageRoute(
        builder: (context) => SubredditFeedPage(
          subreddit: text,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
