import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isg_ihlal/data/entity/violation_types.dart';
import 'package:isg_ihlal/data/repo/catalog/violation_catalog.dart';
import 'package:isg_ihlal/data/session/constant_strings.dart';
import 'package:isg_ihlal/ui/common/parse_date.dart';

class Violation {
  final String id;
  final String imageUrl;
  final String description;
  final String location;
  final DateTime date;
  final String uid;
  final ViolationType violationType;
  final DateTime? actionWhen;
  final String? actionByWho;
  final ActionType actionType;
  Violation(
    this.id,
    this.imageUrl,
    this.description,
    this.location,
    this.date,
    this.uid,
    this.violationType,
    this.actionByWho,
    this.actionWhen, {
    this.actionType = ActionType.posted,
  });
  factory Violation.fromMap(String id, Map<String, dynamic> map) {
    return Violation(
      id,
      map[ConstantFieldStrings.image_url],
      map[ConstantFieldStrings.description],
      map[ConstantFieldStrings.location],
      parseDateTime(map[ConstantFieldStrings.date] ?? ''),
      map[ConstantFieldStrings.uid],
      ViolationCatalog.byId(map[ConstantFieldStrings.violation_type_id]),
      map[ConstantFieldStrings.action_by_who],
      map[ConstantFieldStrings.action_when],
      actionType: ActionType.fromString(map[ConstantFieldStrings.action_type]),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      ConstantFieldStrings.id: id,
      ConstantFieldStrings.image_url: imageUrl,
      ConstantFieldStrings.description: description,
      ConstantFieldStrings.location: location,
      ConstantFieldStrings.date: date,
      ConstantFieldStrings.uid: uid,
      ConstantFieldStrings.violation_type_id: violationType.id,
      ConstantFieldStrings.action_by_who: actionByWho,
      ConstantFieldStrings.action_when: actionWhen,
      ConstantFieldStrings.action_type: ActionType.fromAction(actionType),
    };
  }
  Violation copyWith({
  String? id,
  String? imageUrl,
  String? description,
  String? location,
  DateTime? date,
  String? uid,
  ViolationType? violationType,
  String? actionByWho,
  DateTime? actionWhen,
  ActionType? actionType,
}) {
  return Violation(
    id ?? this.id,
    imageUrl ?? this.imageUrl,
    description ?? this.description,
    location ?? this.location,
    date ?? this.date,
    uid ?? this.uid,
    violationType ?? this.violationType,
    actionByWho ?? this.actionByWho,
    actionWhen ?? this.actionWhen,
    actionType: actionType ?? this.actionType,
  );
}

  static String getTheTag(ActionType action) {
    return switch (action) {
      ActionType.investigating => "İnceleniyor",
      ActionType.resolved => "Çözümlendi",
      ActionType.posted => "Yeni",
      ActionType.rejected => "Reddedildi",
    };
  }

  void operator []=(String other, FieldValue value) {}
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
