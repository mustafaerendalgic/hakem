import 'package:isg_ihlal/data/entity/violation_types.dart';
import 'package:isg_ihlal/data/repo/catalog/facility_locations.dart';
import 'package:isg_ihlal/data/repo/catalog/facility_zones.dart';
import 'package:isg_ihlal/data/repo/catalog/violation_info_repo.dart';

class ViolationCatalog {
  ViolationCatalog._();

  static List<ViolationType> _violationType = [];
  static List<ViolationType> get violationType => _violationType;

  static List<ViolationCategory> _violationCategory = [];
  static List<ViolationCategory> get violationCategory => _violationCategory;

  static List<FacilityZones> _facilityZones = [];
  static List<FacilityZones> get facilityZones => _facilityZones;

  static List<FacilityLocations> _facilityLocations = [];
  static List<FacilityLocations> get facilityLocations => _facilityLocations;

  static Future<void> loadAll() async {
    try {
      _violationType = await ViolationReferenceDataRepo.fetchViolationTypes();
      _violationCategory = await ViolationReferenceDataRepo.fetchCategories();
      _facilityZones = await ViolationReferenceDataRepo.fetchZones();
      _facilityLocations = await ViolationReferenceDataRepo.fetchLocations();
    } catch (e) {
      throw Exception(e);
    }
  }

  static ViolationType byId(String id) {
    return _violationType.firstWhere(
      (type) => type.id == id,
      orElse: () => throw StateError("Bilinmeyen tip"),
    );
  }
}
