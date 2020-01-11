import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/functions/hex_to_color_class.dart';
import 'package:flutter_provider_app/widgets/drawer/drawer.dart';

class TranslucentAppBarBackground extends StatefulWidget {
  @override
  _TranslucentAppBarBackgroundState createState() =>
      _TranslucentAppBarBackgroundState();
}

class _TranslucentAppBarBackgroundState
    extends State<TranslucentAppBarBackground> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<FeedProvider>(context);
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        var headerColor =
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? TransparentHexColor("#000000", "80")
                : TransparentHexColor("#FFFFFF", "bb");

//        if (prov.subredditInformationEntity != null &&
//            prov.subredditInformationEntity.data.bannerBackgroundColor != "") {
//          headerColor = TransparentHexColor(
//            prov.subredditInformationEntity.data.bannerBackgroundColor,
//            "00",
//          );
//        }
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              // Don't wrap this in any SafeArea widgets, use padding instead
              padding: EdgeInsets.only(top: 0),
              color: headerColor,
              // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
              child: prov != null
                  ? prov.state == ViewState.Idle
                      ? prov.currentPage == CurrentPage.FrontPage
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 32, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Front Page',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.chevron_right),
                                        onPressed: () {
                                          return Navigator.of(context,
                                                  rootNavigator: false)
                                              .push(
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  LeftDrawer(),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                        },
                                        color: Theme.of(context).accentColor,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 0.0,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          maxRadius: 24,
                                          minRadius: 24,
                                          backgroundImage: prov
                                                      .subredditInformationEntity
                                                      .data
                                                      .communityIcon !=
                                                  ""
                                              ? NetworkImage(prov
                                                  .subredditInformationEntity
                                                  .data
                                                  .communityIcon)
                                              : prov.subredditInformationEntity
                                                          .data.iconImg !=
                                                      ""
                                                  ? NetworkImage(prov
                                                      .subredditInformationEntity
                                                      .data
                                                      .iconImg)
                                                  : AssetImage(
                                                      'assets/default_icon.png'),
                                          backgroundColor: prov
                                                      .subredditInformationEntity
                                                      .data
                                                      .primaryColor ==
                                                  ""
                                              ? Theme.of(context).accentColor
                                              : HexColor(prov
                                                  .subredditInformationEntity
                                                  .data
                                                  .primaryColor),
                                        ),
                                        prov.subredditInformationEntity.data
                                                    .userIsSubscriber !=
                                                null
                                            ? Expanded(
                                                child: Container(),
                                              )
                                            : Container(),
                                        prov.subredditInformationEntity.data
                                                    .userIsSubscriber !=
                                                null
                                            ? OutlineButton(
                                                textColor: Theme.of(context)
                                                    .textTheme
                                                    .body1
                                                    .color,
                                                child: prov.partialState ==
                                                        ViewState.Busy
                                                    ? Container(
                                                        width: 24.0,
                                                        height: 24.0,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      )
                                                    : Text(prov
                                                            .subredditInformationEntity
                                                            .data
                                                            .userIsSubscriber
                                                        ? 'Subscribed'
                                                        : 'Join'),
                                                onPressed: () {
                                                  prov.changeSubscriptionStatus(
                                                    prov.subredditInformationEntity
                                                        .data.name,
                                                    !prov
                                                        .subredditInformationEntity
                                                        .data
                                                        .userIsSubscriber,
                                                  );
                                                },
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  prov.subredditInformationEntity
                                                      .data.displayNamePrefixed,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                ),
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.arrow_forward),
                                                  onPressed: () => Navigator.of(
                                                          context,
                                                          rootNavigator: false)
                                                      .push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LeftDrawer(),
                                                      fullscreenDialog: true,
                                                    ),
                                                  ),
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                )
                                              ],
                                            ),
                                            Text(
                                              prov.subredditInformationEntity
                                                      .data.subscribers
                                                      .toString() +
                                                  " Subscribers",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subhead,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  )
                                ],
                              ),
                            )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Front Page',
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
