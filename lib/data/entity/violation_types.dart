import 'package:isg_ihlal/data/session/constant_strings.dart';

class ViolationRisk {
  String id;
  String title;
  int severity;
  ViolationRisk(this.id, this.title, this.severity);
  factory ViolationRisk.fromJson(Map<String, dynamic> json) {
    return ViolationRisk(json[ConstantFieldStrings.id], json[ConstantFieldStrings.title], json[ConstantFieldStrings.severity_order]);
  }
}

class ViolationCategory {
  String id;
  String title;
  ViolationCategory(this.id, this.title);
  factory ViolationCategory.fromJson(Map<String, dynamic> json) {
    return ViolationCategory(json[ConstantFieldStrings.id], json[ConstantFieldStrings.title]);
  }
}

class ViolationType {
  final String id;
  final String title;
  final String categoryId;
  final String defaultRiskId;

  const ViolationType({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.defaultRiskId,
  });
  factory ViolationType.fromJson(Map<String, dynamic> json) {
    return ViolationType(
      id: json[ConstantFieldStrings.id],
      title: json[ConstantFieldStrings.title],
      categoryId: json[ConstantFieldStrings.category_id],
      defaultRiskId: json[ConstantFieldStrings.default_risk_id],
    );
  }
}
