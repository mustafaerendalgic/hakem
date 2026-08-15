class Violation {
  final int id;
  final String imageUrl;
  final String description;
  final String location;
  final String violationRisk;
  final String date;
  final String time;
  final String status;
  final String? actionWhen;
  final int howManyViewed;
  final ActionType actionType;
  Violation(
    this.id,
    this.imageUrl,
    this.description,
    this.location,
    this.violationRisk,
    this.date,
    this.time,
    this.status,
    this.howManyViewed,
    this.actionWhen,
    {this.actionType = ActionType.posted}
  );
}

enum ActionType { investigating, resolved, posted }
