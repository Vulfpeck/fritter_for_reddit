import 'dart:io';

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
}
