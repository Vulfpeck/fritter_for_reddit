part of 'userpage_bloc.dart';

@immutable
class UserPageState {
  final List<SubmissionWithImageData> submissions;
  final List<Comment> comments;

  List<SubmissionWithImageData> get uniqueSubmissions => submissions.uniqueBy(
          equals: (SubmissionWithImageData e1, SubmissionWithImageData e2) {
        if (e1.imageData.length != e2.imageData.length) {
          return false;
        }

        return listEquals(e1.imageData, e2.imageData);
      }, hashCode: (SubmissionWithImageData e) {
        final startPoint = e.imageData.length ~/ 2;
        return int.parse(e.imageData
            .sublist(startPoint, startPoint + min(10, startPoint - 1))
            .join());
      });

  UserPageState({@required this.submissions, @required this.comments});

  UserPageState copyWith({
    List<SubmissionWithImageData> submissions,
    List<Comment> comments,
  }) {
    return UserPageState(
      submissions: submissions ?? this.submissions,
      comments: comments ?? this.comments,
    );
  }
}

class UserPageInitial extends UserPageState {
  UserPageInitial() : super(submissions: [], comments: []);
}
