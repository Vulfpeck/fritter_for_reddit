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
        return difference.inMinutes.toString() +
            (difference.inMinutes == 1 ? " minute" : " minutes") +
            " ago";
      }
    } else {
      return difference.inHours.toString() +
          (difference.inHours == 1 ? " hour" : " hours") +
          " ago";
    }
  } else {
    return difference.inDays.toString() +
        (difference.inDays == 1 ? " day" : " days") +
        " ago";
  }
}
