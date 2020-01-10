import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRoute<T> extends PageRouteBuilder<T> {
  final Widget enterPage;
  final Widget exitPage;

  CustomRoute({this.enterPage, this.exitPage})
      : super(
          pageBuilder: (BuildContext context, Animation<double> primary,
              Animation<double> secondary) {
            return enterPage;
          },
          opaque: true,
          transitionsBuilder: (BuildContext context, Animation<double> primary,
              Animation<double> secondary, Widget child) {
            return Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 0.9).animate(
                    CurvedAnimation(
                      curve: Curves.linearToEaseOut,
                      reverseCurve: Curves.easeInToLinear,
                      parent: primary,
                    ),
                  ),
                  child: SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(0.0, 0.01),
                    ).animate(
                      CurvedAnimation(
                        curve: Curves.linearToEaseOut,
                        reverseCurve: Curves.easeInToLinear,
                        parent: primary,
                      ),
                    ),
                    child: exitPage,
                  ),
                ),
                FadeTransition(
                  opacity: primary,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: const Offset(0, 0),
                  ).animate(
                    CurvedAnimation(
                      curve: Curves.linearToEaseOut,
                      reverseCurve: Curves.easeInToLinear,
                      parent: primary,
                    ),
                  ),
                  child: enterPage,
                )
              ],
            );
          },
        );
}
