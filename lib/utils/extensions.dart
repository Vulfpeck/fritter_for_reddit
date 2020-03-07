import 'dart:developer';
import 'dart:io';

import 'package:html_unescape/html_unescape.dart';
import 'package:rxdart/rxdart.dart';

extension PlatformX on Platform {
  static bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
}

extension StringX on String {
  String get withSubredditLinksAsMarkdownLinks =>
      replaceAllMapped(RegExp(r'(\/r\/[\w_-]+\b)'), (Match match) {
        final String content = match[0];
        final convertedString = '[$content]($content)';
        return convertedString;
      });

  String get asSanitizedImageUrl {
    if (contains('.html')) {
      debugger();
    }
    var convertedString = HtmlUnescape().convert(this);
    if (!startsWith('https://external-preview.redd.it/') &&
        !startsWith('https://preview.redd.it/')) {
      if (contains('?')) {
        convertedString = convertedString.substring(0, indexOf('?'));
      }
    }
    return convertedString;
  }

  String get htmlUnescaped => HtmlUnescape().convert(this);
}

extension StreamX<T> on Stream<T> {
  BehaviorSubject<T> get asBehaviorSubject {
    BehaviorSubject<T> newSubject = BehaviorSubject<T>();
    listen(newSubject.add);
    return newSubject;
  }
}
