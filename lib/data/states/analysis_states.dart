import 'package:isg_ihlal/data/entity/analysis_data.dart';

sealed class AnalysisStates {}

class AnalysisInitialState extends AnalysisStates {}

class AnalysisLoadingState extends AnalysisStates {}

class AnalysisLoadedState extends AnalysisStates {
  final AnalysisSummary summary;
  final String selectedDateFilter;
  final String selectedLocation;

  AnalysisLoadedState({
    required this.summary,
    this.selectedDateFilter = "Son 30 Gün",
    this.selectedLocation = "Tüm Lokasyonlar",
  });
}

class AnalysisErrorState extends AnalysisStates {
  final String error;
  AnalysisErrorState(this.error);
}
