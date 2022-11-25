abstract class ActiveTabAction {}

class UpdateActiveTab implements ActiveTabAction {
  final int newTabIndex;

  UpdateActiveTab(this.newTabIndex);
}
