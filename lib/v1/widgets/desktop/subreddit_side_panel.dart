import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v1/models/subreddit_info/rule.dart';
import 'package:fritter_for_reddit/v1/models/subreddit_info/subreddit_information_entity.dart';
import 'package:fritter_for_reddit/v1/utils/extensions.dart';
import 'package:fritter_for_reddit/v1/widgets/desktop/desktop_subreddit_drawer_tile.dart';
import 'package:fritter_for_reddit/v1/widgets/subreddit_aware_text.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SubredditSidePanel extends StatelessWidget {
  final SubredditInformationEntity subredditInformation;

  const SubredditSidePanel({
    Key key,
    @required this.subredditInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subredditInformation == null) {
      return Drawer(child: PopularSubsSidePanelList());
    } else {
      return Drawer(
        child: ListView(
//        shrinkWrap: true,
          children: <Widget>[
            AboutCommunity(
              subredditName: subredditInformation.data.displayName,
              activeUserAccounts: subredditInformation.data.activeUserCount,
              description: subredditInformation.data.description,
              isNsfw: subredditInformation.data.over18,
              createdDate: DateTime.fromMillisecondsSinceEpoch(
                  subredditInformation.data.createdUtc.toInt() * 1000,
                  isUtc: true),
            ),
            Divider()
          ],
        ),
      );
    }
  }
}

class PopularSubsSidePanelList extends StatelessWidget {
  const PopularSubsSidePanelList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FeedProvider.of(context).fetchPopularSubreddits(),
      builder: (BuildContext context,
          AsyncSnapshot<List<SubredditInformationEntity>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading');
        } else {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              StickyHeader(
                header: CupertinoNavigationBar(
                  middle: Text(
                    'Popular Subreddits',
                    style:
                        Theme.of(context).primaryTextTheme.bodyText1.copyWith(),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                ),
                content: Column(
                  children: <Widget>[
                    for (final subreddit in snapshot.data)
                      DesktopSubredditDrawerTile.fromSubredditInformationEntity(
                        subreddit: subreddit,
                      )
                  ],
                ),
              )
            ],
          );
        }
      },
    );
  }
}

class AboutCommunity extends StatelessWidget {
  final String subredditName;
  final int activeUserAccounts;
  final String description;
  final bool isNsfw;
  final DateTime createdDate;

  const AboutCommunity({
    Key key,
    @required this.activeUserAccounts,
    @required this.description,
    @required this.isNsfw,
    @required this.createdDate,
    @required this.subredditName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoNavigationBar(
          middle: Text(
            'About Community',
            style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: StickyHeader(
                header: Card(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: double.infinity,
                      color: Theme.of(context).cardColor,
                      child: Text(
                        'Rules',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                ),
                content: FutureBuilder<List<Rule>>(
                  future:
                      FeedProvider.of(context).getSubredditRules(subredditName),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Rule>> snapshot) {
                    return Container();
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    final oldErrorWidgetBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (error) => PopularSubsSidePanelList();
    Future.delayed(Duration(milliseconds: 100))
        .then((value) => ErrorWidget.builder = oldErrorWidgetBuilder);
    String sanitizedData = description
        .htmlUnescaped.withSubredditLinksAsMarkdownLinks
        .cleanupMarkdown();
    return Markdown(
      physics: NeverScrollableScrollPhysics(),
      data: sanitizedData,
      shrinkWrap: true,
      onTapLink: (link, _, __) =>
          FeedProvider.of(context).navigateToSubreddit(link),
    );
  }
}
