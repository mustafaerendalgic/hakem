import 'package:isg_ihlal/data/entity/violation_types.dart';
import 'package:isg_ihlal/data/repo/catalog/facility_locations.dart';
import 'package:isg_ihlal/data/repo/catalog/facility_zones.dart';
import 'package:isg_ihlal/data/repo/catalog/supabase_api.dart';

class ViolationReferenceDataRepo {
  ViolationReferenceDataRepo._();

  static Future<List<ViolationCategory>> fetchCategories() async {
    final rows = await SupabaseApi.fetchViolationInfo(
      'violation_categories',
      order: 'title',
    );
    return rows.map((category) {
      return ViolationCategory.fromJson(category);
    }).toList();
  }

  static Future<List<ViolationRisk>> fetcRiskTypes() async {
    final rows = await SupabaseApi.fetchViolationInfo(
      'violation_risks',
      order: 'title',
    );
    return rows.map((risk) {
      return ViolationRisk.fromJson(risk);
    }).toList();
  }

  static Future<List<ViolationType>> fetchViolationTypes() async {
    final rows = await SupabaseApi.fetchViolationInfo(
      'violation_types',
      order: 'title',
    );
    return rows.map((type) {
      return ViolationType.fromJson(type);
    }).toList();
  }

  static Future<List<FacilityZones>> fetchZones() async {
    final rows = await SupabaseApi.fetchViolationInfo('facility_zones');
    return rows.map((zone) {
      return FacilityZones.fromJson(zone);
    }).toList();
  }

  static Future<List<FacilityLocations>> fetchLocations() async {
    final rows = await SupabaseApi.fetchViolationInfo('facility_locations');
    return rows.map((location) {
      return FacilityLocations.fromJson(location);
    }).toList();
  }
}
