String getTimePosted(double orig) {
  DateTime postDate = DateTime.fromMillisecondsSinceEpoch(
    orig.floor() * 1000,
    isUtc: true,
  );
  Duration difference = DateTime.now().toUtc().difference(postDate);
  if (difference.inDays <= 0) {
    if (difference.inHours <= 0) {
      if (difference.inMinutes <= 0) {
        return "Few Moments Ago";
      } else {
        return difference.inMinutes.toString() + "m";
      }
    } else {
      return difference.inHours.toString() + "h";
    }
  } else {
    return difference.inDays.toString() + "d";
  }
}
