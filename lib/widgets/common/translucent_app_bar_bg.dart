import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/hex_color.dart';

class TranslucentAppBarBackground extends StatefulWidget {
  @override
  _TranslucentAppBarBackgroundState createState() =>
      _TranslucentAppBarBackgroundState();
}

class _TranslucentAppBarBackgroundState
    extends State<TranslucentAppBarBackground> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        var headerColor = TransparentHexColor("#FAF0D9");

        if (model.subredditInformationEntity != null &&
            model.subredditInformationEntity.data.bannerBackgroundColor != "") {
          headerColor = TransparentHexColor(
              model.subredditInformationEntity.data.bannerBackgroundColor);
        }
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              // Don't wrap this in any SafeArea widgets, use padding instead
              padding: EdgeInsets.only(top: 0),
              color: headerColor,
              // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
              child: model != null
                  ? model.state == ViewState.Idle
                      ? model.currentPage == CurrentPage.FrontPage
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 32, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Front Page',
                                    style: Theme.of(context).textTheme.headline,
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
                                        vertical: 16.0),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          maxRadius: 24,
                                          minRadius: 24,
                                          backgroundImage: model
                                                      .subredditInformationEntity
                                                      .data
                                                      .communityIcon !=
                                                  ""
                                              ? NetworkImage(model
                                                  .subredditInformationEntity
                                                  .data
                                                  .communityIcon)
                                              : model.subredditInformationEntity
                                                          .data.iconImg !=
                                                      ""
                                                  ? NetworkImage(model
                                                      .subredditInformationEntity
                                                      .data
                                                      .iconImg)
                                                  : AssetImage(
                                                      'assets/default_icon.png'),
                                          backgroundColor: model
                                                      .subredditInformationEntity
                                                      .data
                                                      .primaryColor ==
                                                  ""
                                              ? Theme.of(context).accentColor
                                              : HexColor(model
                                                  .subredditInformationEntity
                                                  .data
                                                  .primaryColor),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        OutlineButton(
                                          child: model.partialState ==
                                                  ViewState.Busy
                                              ? Container(
                                                  width: 24.0,
                                                  height: 24.0,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                              : Text(model
                                                      .subredditInformationEntity
                                                      .data
                                                      .userIsSubscriber
                                                  ? 'Subscribed'
                                                  : 'Join'),
                                          onPressed: () {
                                            model.changeSubscriptionStatus(
                                                model.subredditInformationEntity
                                                    .data.name,
                                                !model
                                                    .subredditInformationEntity
                                                    .data
                                                    .userIsSubscriber);
                                          },
                                        ),
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
                                            Text(
                                              model.subredditInformationEntity
                                                  .data.displayNamePrefixed,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            ),
                                            Text(
                                              model.subredditInformationEntity
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
                            style: Theme.of(context).textTheme.headline,
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
