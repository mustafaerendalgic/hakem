import 'package:isg_ihlal/data/entity/analysis_data.dart';
import 'package:isg_ihlal/data/repo/catalog/supabase_api.dart';

abstract class AnalysisRepository {
  Future<AnalysisSummary> fetchAnalytics({
    String dateFilter = "Son 30 Gün",
    String locationFilter = "Tüm Lokasyonlar",
  });
}

class AnalysisRepo implements AnalysisRepository {
  AnalysisRepo._init();
  static final AnalysisRepo instance = AnalysisRepo._init();
  factory AnalysisRepo() => instance;

  @override
  Future<AnalysisSummary> fetchAnalytics({
    String dateFilter = "Son 30 Gün",
    String locationFilter = "Tüm Lokasyonlar",
  }) async {
    final response = await SupabaseApi.callRpc(
      'get_violation_analytics',
      params: {
        'p_date_filter': dateFilter,
        'p_location_filter': locationFilter,
      },
    );

    return AnalysisSummary.fromSupabaseJson(response);
  }
}