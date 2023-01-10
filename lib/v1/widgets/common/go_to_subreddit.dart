import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/v1/widgets/desktop/desktop_main_subreddit_tile.dart';
import 'package:fritter_for_reddit/v1/widgets/feed/main_subreddit_tile.dart';

import '../../exports.dart';

enum Mode { desktop, mobile }

class GoToSubredditWidget extends StatefulWidget {
  final FocusNode? focusNode;
  final Mode mode;

  GoToSubredditWidget({this.focusNode, required this.mode});

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
                hintText: 'Go to subreddit',
                filled: true,
                isDense: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                  ),
                  onPressed: () {
                    widget.focusNode!.unfocus();
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
                widget.focusNode!.unfocus();
                loadNewSubreddit(context, value);
              },
            ),
          ),
          if (widget.mode == Mode.mobile)
            MainSubredditTile(
              title: 'Frontpage',
              subreddit: '',
              description: "Posts from subscriptions",
            )
          else
            DesktopMainSubredditTile(
              title: 'Frontpage',
              subreddit: '',
              description: "Posts from subscriptions",
              onTap: (subreddit) {
                Provider.of<FeedProvider>(context, listen: false)
                    .navigateToSubreddit(subreddit);
              },
            ),
          if (widget.mode == Mode.mobile)
            MainSubredditTile(
              title: 'Popular',
              subreddit: 'popular',
              description: "Trending posts from subreddits",
            )
          else
            DesktopMainSubredditTile(
              title: 'Popular',
              subreddit: 'popular',
              description: "Trending posts from subreddits",
              onTap: (subreddit) {
                Provider.of<FeedProvider>(context, listen: false)
                    .navigateToSubreddit(subreddit);
              },
            ),
          if (widget.mode == Mode.mobile)
            MainSubredditTile(
              title: 'All',
              subreddit: 'all',
              description: "Trending posts from all of Reddit",
            )
          else
            DesktopMainSubredditTile(
              title: 'All',
              subreddit: 'all',
              description: "Trending posts from all of Reddit",
              onTap: (subreddit) {
                Provider.of<FeedProvider>(context, listen: false)
                    .navigateToSubreddit(subreddit);
              },
            ),
        ],
      ),
    );
  }

  loadNewSubreddit(BuildContext context, String text) {
    if (_subredditGoTextController.text == "") {
      return;
    }
    widget.focusNode!.unfocus();
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

const List<String> options = [
  'honorable',
  'flap',
  'dangerous',
  'probable',
  'boil',
  'breakable',
  'faithful',
  'evasive',
  'kindhearted',
  'delirious',
  'foot',
  'stew',
  'scold',
  'sudden',
  'bathe',
  'furry',
  'songs',
  'acrid',
  'pleasant',
  'shelter',
  'brush',
  'spurious',
  'basketball',
  'attraction',
  'pastoral',
  'travel',
  'regular',
  'elite',
  'respect',
  'boundless',
  'selfish',
  'marry',
  'mug',
  'spiders',
  'little',
  'car',
  'acidic',
  'limping',
  'yellow',
  'riddle',
  'second',
  'hand',
  'keen',
  'nonstop',
  'even',
  'joke',
  'ripe',
  'thing',
  'makeshift',
  'synonymous',
  'rest',
  'lying',
  'mushy',
  'sister',
  'rice',
  'sprout',
  'toy',
  'hard',
  'to',
  'find',
  'wretched',
  'quack',
  'count',
  'gusty',
  'root',
  'obtainable',
  'hydrant',
  'insect',
  'wing',
  'magenta',
  'things',
  'owe',
  'silver',
  'protect',
  'infamous',
  'efficient',
  'monkey',
  'smile',
  'alike',
  'girl',
  'lip',
  'classy',
  'spell',
  'crow',
  'bubble',
  'bitter',
  'radiate',
  'tow',
  'pies',
  'wander',
  'holiday',
  'teeny',
  'tiny',
  'elastic',
  'stimulating',
  'obtain',
  'humor',
  'shelf',
  'violet',
  'addition',
  'tidy',
  'arithmetic',
  'panicky',
  'lunchroom',
];
