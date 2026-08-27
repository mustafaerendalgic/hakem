import 'package:isg_ihlal/data/session/constant_strings.dart';

class FacilityZones {
  String id;
  String title;
  String code;
  FacilityZones(this.id, this.title, this.code);

  factory FacilityZones.fromJson(Map<String, dynamic> json) {
    return FacilityZones(
      json[ConstantFieldStrings.id],
      json[ConstantFieldStrings.title],
      json[ConstantFieldStrings.code],
    );
  }
}

