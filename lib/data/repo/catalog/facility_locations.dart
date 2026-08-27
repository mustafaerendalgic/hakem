import 'package:isg_ihlal/data/session/constant_strings.dart';

class FacilityLocations {
  String id;
  String zone_id;
  String title;
  String code;
  bool is_active;
  FacilityLocations(this.id, this.zone_id, this.title, this.code, this.is_active);
  factory FacilityLocations.fromJson(Map<String, dynamic> json) {
    return FacilityLocations(
      json[ConstantFieldStrings.id],
      json[ConstantFieldStrings.zone_id],
      json[ConstantFieldStrings.title],
      json[ConstantFieldStrings.code],
      json[ConstantFieldStrings.is_active]
    );
  }
}
