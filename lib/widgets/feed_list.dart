import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/widgets/comments_sheet.dart';
import 'package:flutter_provider_app/widgets/feed_card.dart';
import 'package:flutter_provider_app/widgets/translucent_app_bar.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider model, _) {
      return CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.sort,
                ),
                onSelected: (value) {
                  if (value == 'Close') {
                  } else
                    Provider.of<FeedProvider>(context).fetchPostsListing(
                        currentSort: value, currentSubreddit: model.sub);
                },
                itemBuilder: (BuildContext context) {
                  return <String>[
                    'Close',
                    'Best',
                    'Hot',
                    'New',
                    'Controversial',
                    'Rising'
                  ].map((String value) {
                    return new PopupMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList();
                },
                onCanceled: () {},
              ),
            ],
            pinned: false,
            snap: true,
            floating: true,
            primary: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData.fallback(),
            brightness: Brightness.light,
            flexibleSpace: FlexibleSpaceBar(
              background: model.partialState == ViewState.Busy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : TranslucentAppBarBackground(),
            ),
            expandedHeight:
                model.currentPage == CurrentPage.FrontPage ? 150 : 200,
          ),
//          SliverPersistentHeader(
//            delegate:
//                TranslucentSliverAppDelegate(MediaQuery.of(context).padding),
//            pinned: false,
//            floating: false,
//          ),
          SliverList(
            delegate: model.state == ViewState.Idle &&
                    Provider.of<UserInformationProvider>(context).state ==
                        ViewState.Idle
                ? SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var item = model.postFeed.data.children[index].data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 4.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return CommentsSheet();
                              },
                            );
                          },
                          child: item.isSelf == false && item.preview != null
                              ? FeedCardImage(item)
                              : FeedCardSelfText(item),
                        ),
                      );
                    },
                    childCount: model.postFeed.data.children.length,
                  )
                : SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
          )
        ],
      );
    });
  }
}
