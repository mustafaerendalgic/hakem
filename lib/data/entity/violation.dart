import 'package:isg_ihlal/ui/common/parse_date.dart';

class Violation {
  final String id;
  final String imageUrl;
  final String description;
  final String location;
  final ViolationRisk violationRisk;
  final DateTime date;
  final String? actionWhen;
  final String? actionByWho;
  final ActionType actionType;
  Violation(
    this.id,
    this.imageUrl,
    this.description,
    this.location,
    this.violationRisk,
    this.date,
    this.actionByWho,
    this.actionWhen, {
    this.actionType = ActionType.posted,
  });
  factory Violation.fromMap(String id, Map<String, dynamic> map) {
    return Violation(
      id,
      map['imageUrl'],
      map['description'],
      map['location'],
      ViolationRisk.fromString(map['violationRisk']),
      parseDateTime(map['date'] ?? ''),
      map['actionByWho'],
      map['actionWhen'],
      actionType: ActionType.fromString(map['actionType']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
      'location': location,
      'violationRisk': ViolationRisk.fromViolation(violationRisk),
      'date': date,
      'actionByWho': actionByWho,
      'actionWhen': actionWhen,
      'actionType': ActionType.fromAction(actionType),
    };
  }

  static String getTheTag(ActionType action) {
    return switch (action) {
      ActionType.investigating => "İnceleniyor",
      ActionType.resolved => "Çözümlendi",
      ActionType.posted => "Yeni",
      ActionType.rejected => "Reddedildi",
    };
  }
}

enum ActionType {
  investigating("investigating"),
  resolved("resolved"),
  posted("posted"),
  rejected("rejected");

  final String value;
  const ActionType(this.value);

  static ActionType fromString(String name) {
    return ActionType.values.firstWhere(
      (e) => e.value.toLowerCase() == name.toLowerCase(),
      orElse: () => ActionType.posted,
    );
  }

  static String fromAction(ActionType action) {
    final actionType = ActionType.values.firstWhere(
      (e) => e == action,
      orElse: () => ActionType.posted,
    );
    return actionType.value;
  }
}

enum ViolationRisk {
  lethal("lethal"),
  highRisk("high_risk"),
  mildRisk("mild_risk"),
  minRisk("min_risk");

  final String value;
  const ViolationRisk(this.value);

  static ViolationRisk fromString(String name) {
    return ViolationRisk.values.firstWhere(
      (e) => e.value.toLowerCase() == name.toLowerCase(),
      orElse: () => ViolationRisk.mildRisk,
    );
  }

  static String fromViolation(ViolationRisk risk) {
    final riskType = ViolationRisk.values.firstWhere(
      (e) => e == risk,
      orElse: () => ViolationRisk.mildRisk,
    );
    return riskType.value;
  }
}
