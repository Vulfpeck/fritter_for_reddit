import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/models/subreddit_info/subreddit_information_entity.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';

class SubredditSidePanel extends StatelessWidget {
  final SubredditInformationEntity subredditInformation;

  const SubredditSidePanel({
    Key key,
    @required this.subredditInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subredditInformation == null) {
      return Text('null');
    } else {
      return ListView(
        children: <Widget>[
          AboutCommunity(
            activeUserAccounts: subredditInformation.data.activeUserCount,
            description: subredditInformation.data.description,
            isNsfw: subredditInformation.data.over18,
            createdDate: DateTime.fromMillisecondsSinceEpoch(
                subredditInformation.data.createdUtc.toInt() * 1000,
                isUtc: true),
          ),
          Divider()
        ],
      );
    }
  }
}

class AboutCommunity extends StatelessWidget {
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CupertinoNavigationBar(
            middle: Text(
              'About Community',
              style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
          ),
          Markdown(
            physics: NeverScrollableScrollPhysics(),
            data: description.withSubredditLinksAsMarkdownLinks,
            shrinkWrap: true,
            onTapLink: (link) =>
                FeedProvider.of(context).navigateToSubreddit(link),
          ),
        ],
      ),
    );
  }
}
