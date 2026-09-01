
import 'dart:ui';

import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/theme/app_colors.dart';

Color getBadgeColor(ActionType actionType) {
  Color result = switch (actionType) {
    ActionType.investigating => AppColors.mavi,
    ActionType.resolved => AppColors.yesil,
    ActionType.posted => AppColors.primary,
    ActionType.rejected => AppColors.gray,
  };
  return result;
}
