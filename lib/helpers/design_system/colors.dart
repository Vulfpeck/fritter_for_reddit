import 'package:flutter/material.dart';
import 'package:flutter_provider_app/helpers/design_system/color_enums.dart';

Color getColor(Brightness platformBrightness, ColorObjects obj) {
  if (platformBrightness == Brightness.light) {
    switch (obj) {
      case ColorObjects.TagColor:
        {
          return Colors.lightGreen.shade100;
        }
      case ColorObjects.UpvoteColor:
        {
          return Colors.deepOrange;
        }
      case ColorObjects.DownvoteColor:
        {
          return Colors.deepPurple;
        }
    }
  } else {
    switch (obj) {
      case ColorObjects.TagColor:
        {
          return Colors.lightGreen.shade900;
        }
      case ColorObjects.UpvoteColor:
        {
          return Colors.orangeAccent;
        }
      case ColorObjects.DownvoteColor:
        {
          return Colors.purpleAccent;
        }
    }
  }
}
