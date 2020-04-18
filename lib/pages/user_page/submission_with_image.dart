import 'dart:typed_data';

import 'package:draw/draw.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@immutable
class SubmissionWithImageData {
  final Submission submission;
  final Uint8List imageData;

  SubmissionWithImageData({
    @required this.submission,
    @required this.imageData,
  });
}
