import 'package:isg_ihlal/data/entity/violation.dart';

sealed class ArchiveStates {}

class ArchiveInitialState extends ArchiveStates {}

class ArchiveLoadingState extends ArchiveStates {}

class ArchiveLoadedState extends ArchiveStates {
  final List<Violation> archives;
  ArchiveLoadedState(this.archives);
}

class ArchiveErrorState extends ArchiveStates {
  final String error;
  ArchiveErrorState(this.error);
}
