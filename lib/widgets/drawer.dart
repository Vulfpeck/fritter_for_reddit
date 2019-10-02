import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/hex_color.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserInformationProvider>(
          builder: (BuildContext context, UserInformationProvider model, _) {
        if (model.signedIn) {
          if (model.state == ViewState.Busy) {
            return Center(child: CircularProgressIndicator());
          } else if (model.state == ViewState.Idle) {
            return ListView.builder(
              itemCount: model.userSubreddits.data.children.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    model.userSubreddits.data.children[index].display_name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      model.userSubreddits.data.children[index].community_icon,
                    ),
                    backgroundColor: model.userSubreddits.data.children[index]
                                .primary_color ==
                            ""
                        ? Theme.of(context).accentColor
                        : HexColor(
                            model.userSubreddits.data.children[index]
                                .primary_color,
                          ),
                  ),
                );
              },
            );

//            return ListView.builder(
//              itemBuilder: (context, int index) {
//                return ListTile(
//                  title: Text(
//                      model.userInformation.subredditsList[index].displayName),
//                  leading: CircleAvatar(
//                    backgroundImage: NetworkImage(model
//                        .userInformation.subredditsList[index].communityIcon),
//                  ),
//                );
//              },
//              itemCount: model.userInformation.subredditsList.length,
//            );
          }
        } else {
          return SafeArea(
            child: ListTile(
              title: Text("Sign into reddit"),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(
                  Icons.person_outline,
                ),
              ),
              onTap: () {
                model.performAuthentication();
              },
            ),
          );
        }
        return Container();
      }),
    );
  }
}
