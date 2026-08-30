import 'package:isg_ihlal/data/entity/violation.dart';

String getActionType(Violation violation) {
  String result = switch (violation.actionType) {
    ActionType.investigating => "İnceleniyor",
    ActionType.resolved => "Çözümlendi",
    ActionType.posted => "Yeni",
    ActionType.rejected => "Reddedildi",
  };
  return result;
}
