// import 'package:conditional_builder/conditional_builder.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fritter_for_reddit/v1/exports.dart';
// import 'package:fritter_for_reddit/v1/models/postsfeed/posts_feed_entity.dart';
// import 'package:fritter_for_reddit/v1/widgets/comments/comments_page.dart';
// import 'package:fritter_for_reddit/v1/widgets/common/gallery_card.dart';
// import 'package:fritter_for_reddit/v1/widgets/desktop/desktop_subreddit_feed.dart';

// class DesktopFeedList extends StatefulWidget {
//   final List<PostsFeedDataChild> posts;
//   final ViewMode viewMode;

//   final bool hasError;
//   final bool isLoading;

//   DesktopFeedList({
//     Key key,
//     @required this.posts,
//     @required this.viewMode,
//     @required this.hasError,
//     @required this.isLoading,
//   }) : super(key: key);

//   @override
//   _DesktopFeedListState createState() => _DesktopFeedListState();
// }

// class _DesktopFeedListState extends State<DesktopFeedList> {
//   PersistentBottomSheetController controller;
//   List<PostsFeedDataChild> pics = [];

//   @override
//   Widget build(BuildContext context) {
//     return ConditionalBuilder(
//       condition: widget.viewMode == ViewMode.gallery,
//       builder: (context) {
//         final List<PostsFeedDataChild> postsWithImages =
//             widget.posts.where((element) => element.data.hasImage).toList();

//         return SliverGrid.count(
//           crossAxisCount: 3,
//           children: <Widget>[
//             for (final postFeedItem in postsWithImages)
//               Card(
//                 elevation: 3,
//                 child: GalleryImage(postFeedItem: postFeedItem),
//               )
//           ],
//         );
//       },
//       fallback: (context) {
//         SliverChildDelegate sliverChildDelegate;
//         if (widget.hasError) {
//           sliverChildDelegate = SliverChildListDelegate([
//             Column(
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 Icon(Icons.error_outline),
//                 Text("Couldn't Load subreddit")
//               ],
//             )
//           ]);
//         } else {
//           sliverChildDelegate = SliverChildBuilderDelegate(
//             (BuildContext context, int index) {
//               if (index == widget.posts.length) {
//                 if (widget.isLoading) {
//                   return Material(
//                     color: Colors.transparent,
//                     child: Column(
//                       children: <Widget>[
//                         ListTile(
//                           title: Center(child: CircularProgressIndicator()),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               }

//               final item = widget.posts[index].data;
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   DesktopPostCard(
//                     item: item,
//                     onTap: () {
//                       _openComments(item, context, index);
//                     },
//                     onDoubleTap: () {
//                       if (item.isTextPost == false) {
//                         launchURL(Theme.of(context).primaryColor, item.url);
//                       }
//                     },
//                   ),
//                   Divider(),
//                 ],
//               );
//             },
//             childCount: widget.posts.length,
//           );
//         }
//         return SliverList(
//           delegate: sliverChildDelegate,
//         );
//       },
//     );
//   }

//   void _openComments(
//       PostsFeedDataChildrenData item, BuildContext context, int index) {
//     Provider.of<CommentsProvider>(context, listen: false).fetchComments(
//       requestingRefresh: false,
//       subredditName: item.subreddit,
//       postId: item.id,
//       sort: item.suggestedSort != null
//           ? changeCommentSortConvertToEnum[item.suggestedSort]
//           : CommentSortTypes.Best,
//     );
//     Navigator.of(context).push(
//       CupertinoPageRoute(
//         maintainState: true,
//         builder: (BuildContext context) {
//           return DesktopCommentsScreen(
//             postData: item,
//           );
//         },
//       ),
//     );
//   }
// }
