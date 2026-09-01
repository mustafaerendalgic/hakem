import 'dart:ui';

import 'package:isg_ihlal/data/entity/violation_types.dart';
import 'package:isg_ihlal/data/session/constant_strings.dart';
import 'package:isg_ihlal/theme/app_colors.dart';

Color getRiskColor(ViolationType type) {
  Color result = switch (type.defaultRiskId) {
    ConstantRiskStrings.high_risk => AppColors.tehlikeli,
    ConstantRiskStrings.lethal => AppColors.cokTehlikeli,
    ConstantRiskStrings.mild_risk => AppColors.azTehlikeli,
    ConstantRiskStrings.min_risk => AppColors.minRisk,
    String() => AppColors.azTehlikeli,
  };
  return result;
}
