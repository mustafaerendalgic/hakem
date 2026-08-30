import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/util/action_type.dart';

Widget ActionTypeTag(Violation violation) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: AppColors.primary,
    ),
    child: Text(
      getActionType(violation),
      style: TextStyles.caption.copyWith(color: AppColors.beyaz),
    ),
  );
}
