class Violation {
  final int id;
  final String imageUrl;
  final String description;
  final String location;
  final String violationRisk;
  final String date;
  final String status;
  final String? actionWhen;
  final ActionType actionType;
  Violation(this.id, this.imageUrl, this.description, this.location, this.violationRisk, this.date, this.status, this.actionWhen, this.actionType);
}

enum ActionType { investigating, resolved, posted }
