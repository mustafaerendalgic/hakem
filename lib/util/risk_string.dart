import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/session/constant_strings.dart';

String getRiskString(Violation violation) {
  String result = switch (violation.violationType.defaultRiskId) {
    ConstantRiskStrings.lethal => "Hayati İhlal!",
    ConstantRiskStrings.high_risk => "Yüksek Riskli İhlal!",
    ConstantRiskStrings.mild_risk => "Riskli İhlal!",
    ConstantRiskStrings.min_risk => "Minimum Riskli İhlal",
    String() => throw UnimplementedError(),
  };
  return result;
}
