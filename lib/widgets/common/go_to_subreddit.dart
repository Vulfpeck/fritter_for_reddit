import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../exports.dart';

class GoToSubredditWidget extends StatefulWidget {
  final FocusNode focusNode;

  GoToSubredditWidget({this.focusNode});
  @override
  _GoToSubredditWidgetState createState() => _GoToSubredditWidgetState();
}

class _GoToSubredditWidgetState extends State<GoToSubredditWidget> {
  final TextEditingController _subredditGoTextController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            height: 16,
          ),
          ListTile(
            title: TextField(
              keyboardAppearance: MediaQuery.of(context).platformBrightness,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: 'Goto subreddit',
                filled: true,
                isDense: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                  ),
                  onPressed: () {
                    widget.focusNode.unfocus();
                    loadNewSubreddit(context, _subredditGoTextController.text);
                  },
                ),
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
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                widget.focusNode.unfocus();
                loadNewSubreddit(context, value);
              },
            ),
          ),
          ListTile(
            title: Text(
              'Frontpage',
              style: Theme.of(context).textTheme.subhead,
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/default_icon.png'),
              backgroundColor: Theme.of(context).accentColor,
              maxRadius: 16,
            ),
            subtitle: Text("Posts from subscriptions"),
            dense: true,
            onTap: () {
              widget.focusNode.unfocus();
              return Navigator.of(
                context,
                rootNavigator: false,
              ).push(
                CupertinoPageRoute(
                  maintainState: true,
                  builder: (context) => SubredditFeedPage(
                    subreddit: "",
                    frontPageLoad: true,
                  ),
                  fullscreenDialog: false,
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Popular',
              style: Theme.of(context).textTheme.subhead,
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/default_icon.png'),
              backgroundColor: Theme.of(context).accentColor,
              maxRadius: 16,
            ),
            subtitle: Text("Trending posts from subreddits"),
            dense: true,
            onTap: () {
              widget.focusNode.unfocus();
              return Navigator.of(
                context,
                rootNavigator: false,
              ).push(
                CupertinoPageRoute(
                  maintainState: true,
                  builder: (context) => SubredditFeedPage(
                    subreddit: "popular",
                  ),
                  fullscreenDialog: false,
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'All',
              style: Theme.of(context).textTheme.subhead,
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/default_icon.png'),
              backgroundColor: Theme.of(context).accentColor,
              maxRadius: 16,
            ),
            subtitle: Text("Trending posts from all of Reddit"),
            dense: true,
            onTap: () {
              widget.focusNode.unfocus();
              return Navigator.of(
                context,
                rootNavigator: false,
              ).push(
                CupertinoPageRoute(
                  maintainState: true,
                  builder: (context) => SubredditFeedPage(
                    subreddit: "all",
                  ),
                  fullscreenDialog: false,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  loadNewSubreddit(BuildContext context, String text) {
    if (_subredditGoTextController.text == "") {
      return;
    }
    widget.focusNode.unfocus();
    final text = _subredditGoTextController.text.replaceAll(" ", "");
    return Navigator.of(
      context,
      rootNavigator: false,
    ).push(
      CupertinoPageRoute(
        maintainState: true,
        builder: (context) => SubredditFeedPage(
          subreddit: text,
        ),
        fullscreenDialog: false,
      ),
    );
  }
}
