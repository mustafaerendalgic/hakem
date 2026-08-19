import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/ui/common/parse_date.dart';

class ViolationCard extends StatelessWidget {
  Violation violation;
  ViolationCard(this.violation);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: AppColors.kirli, offset: Offset(0, 2))],
        color: AppColors.beyaz,
        border: Border(
          top: BorderSide(color: AppColors.cokTehlikeli, width: 3),
        ),
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cokTehlikeli,
                ),
                child: Center(
                  child: Icon(Icons.warning, size: 28, color: AppColors.beyaz),
                ),
              ),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(switch (violation.violationRisk) {
                    ViolationRisk.lethal => "Hayati İhlal!",
                    ViolationRisk.highRisk => "Yüksek Riskli İhlal!",
                    ViolationRisk.mildRisk => "Riskli İhlal!",
                    ViolationRisk.minRisk => "Minimum Riskli İhlal",
                  }, style: TextStyles.smallBodySemibold),
                  Text(
                    "Konum: " + violation.location,
                    style: TextStyles.smallBodySemibold,
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.primary,
                ),
                child: Center(
                  child: Text(
                    switch (violation.actionType) {
                      ActionType.investigating => "İnceleniyor",
                      ActionType.resolved => "Çözümlendi",
                      ActionType.posted => "Yeni",
                      ActionType.rejected => "Reddedildi",
                    },
                    style: TextStyles.caption.copyWith(color: AppColors.beyaz),
                  ),
                ),
              ),
            ],
          ),
          Text(violation.description, style: TextStyles.caption),
          Container(
            height: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.asset("assets/mockimage.png"),
          ),
          Row(
            spacing: 4,
            children: [
              Text(
                getTheMonth(violation.date),
                style: TextStyles.smallBodySemibold,
              ),
              Text(
                getTheTime(violation.date),
                style: TextStyles.smallBodySemibold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
