import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class ViolationCard extends StatelessWidget {
  Violation violation;
  ViolationCard(this.violation);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: AppColors.kirli, offset: Offset(0, 2), )],
        color: AppColors.beyaz,
        border: Border(top: BorderSide(color: AppColors.cokTehlikeli, width: 3, ))
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
                child: Center(child: Icon(Icons.warning, size: 28, color: AppColors.beyaz,)),
              ),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(violation.violationRisk, style: TextStyles.smallBodySemibold,),
                  Text("Konum: " + violation.location, style: TextStyles.smallBodySemibold,),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.primary,
                ),
                child: Center(child: Text(violation.status, style: TextStyles.caption.copyWith(color: AppColors.beyaz),),),
              )
            ],
          ),
          Text(violation.description, style: TextStyles.caption,),
          Container(
            height: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),),
            child: Image.asset("assets/mockimage.png"),
          ),
          Row(
            spacing: 4,
            children: [
              Text(violation.date, style: TextStyles.smallBodySemibold,),
              Text(violation.time, style: TextStyles.smallBodySemibold,),
              Spacer(),
              Icon(Icons.watch, size: 16, color: AppColors.gray,),
              Text(violation.howManyViewed.toString(), style: TextStyles.smallBodySemibold.copyWith(color: AppColors.gray),)
            ],
          )
        ],
      ),
    );
  }
}
