import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/repo/analysis_repo.dart';
import 'package:isg_ihlal/data/states/analysis_states.dart';

class AnalysisCubit extends Cubit<AnalysisStates> {
  final AnalysisRepository _repo;

  String _currentDateFilter = "Son 30 Gün";
  String _currentLocation = "Tüm Lokasyonlar";

  AnalysisCubit({AnalysisRepository? repo})
      : _repo = repo ?? AnalysisRepo.instance,
        super(AnalysisInitialState()) {
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    emit(AnalysisLoadingState());
    try {
      final summary = await _repo.fetchAnalytics(
        dateFilter: _currentDateFilter,
        locationFilter: _currentLocation,
      );

      emit(
        AnalysisLoadedState(
          summary: summary,
          selectedDateFilter: _currentDateFilter,
          selectedLocation: _currentLocation,
        ),
      );
    } catch (e) {
      emit(AnalysisErrorState(e.toString()));
    }
  }

  void updateDateFilter(String filter) {
    _currentDateFilter = filter;
    loadAnalytics();
  }

  void updateLocationFilter(String location) {
    _currentLocation = location;
    loadAnalytics();
  }
}