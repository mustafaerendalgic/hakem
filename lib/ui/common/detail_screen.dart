import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/session/constant_strings.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/ui/common/action_type_tag.dart';
import 'package:isg_ihlal/ui/common/parse_date.dart';
import 'package:isg_ihlal/util/risk_string.dart';

class DetailScreen extends StatelessWidget {
  final Violation violation;
  DetailScreen({required this.violation, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beyaz,
      body: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: violation.imageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
                IconButton(
                  onPressed: () {
                    NavigationSession.instance.updateIndex(
                      NavigationElement.home,
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cokTehlikeli,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.warning,
                            size: 28,
                            color: AppColors.beyaz,
                          ),
                        ),
                      ),
                      Text(
                        getRiskString(violation),
                        style: TextStyles.bodyBold,
                      ),
                      Spacer(),
                      ActionTypeTag(violation),
                    ],
                  ),
                  Text(
                    violation.description,
                    style: TextStyles.navigationLabelRegular,
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.location_on_outlined, size: 24),
                      Text(violation.location, style: TextStyles.captionBold),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 20),
                      Text(
                        getTheMonth(violation.date) +
                            ", " +
                            getTheTime(violation.date),
                        style: TextStyles.captionBold,
                      ),
                    ],
                  ),
                  if (violation.actionWhen != null)
                    Row(
                      spacing: 8,
                      children: [
                        Icon(switch (violation.actionType) {
                          ActionType.investigating => Icons.search_rounded,
                          ActionType.resolved => Icons.check_rounded,
                          ActionType.posted => Icons.search_rounded,
                          ActionType.rejected => Icons.search_rounded,
                        }, size: 24),
                        Text(
                          getTheMonth(violation.actionWhen!) +
                            ", " +
                            getTheTime(violation.actionWhen!),
                          style: TextStyles.captionBold,
                        ),
                      ],
                    ),
                  if (violation.actionByWho != null)
                    Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.person_rounded, size: 24),
                        Text(
                          violation.actionByWho!,
                          style: TextStyles.captionBold,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            // ... diğer içerik (açıklama, konum, tarih vs.) buraya
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: detailScreenButtons(violation),
        ),
      ),
    );
  }
}

Widget? detailScreenButtons(Violation violation) {
  final String? uid = FirebaseProvider.instance.uid;
  if (uid == null) throw Exception("Geçersiz kullanıcı");
  if (violation.actionType == ActionType.investigating && uid != violation.uid)
    return null;
  Color topButtonColor = violation.actionType == ActionType.investigating
      ? AppColors.yesil
      : AppColors.primary;
  bool shouldDisplayOneButton =
      violation.actionType == ActionType.rejected ||
      violation.actionType == ActionType.resolved;
  String topButtontext = switch (violation.actionType) {
    ActionType.investigating => ConstantButtonStrings.resolve,
    ActionType.resolved => ConstantButtonStrings.reopen,
    ActionType.posted => ConstantButtonStrings.examine,
    ActionType.rejected => ConstantButtonStrings.reopen,
  };
  String? bottomButtontext = shouldDisplayOneButton == false
      ? ConstantButtonStrings.cancel
      : null;
  return Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    children: [
      SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: topButtonColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              topButtontext,
              style: TextStyles.bodyBold.copyWith(color: AppColors.beyaz),
            ),
          ),
        ),
      ),
      if (!shouldDisplayOneButton)
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.beyaz,
              border: BoxBorder.all(color: AppColors.cokTehlikeli, width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                bottomButtontext!,
                style: TextStyles.bodyBold.copyWith(
                  color: AppColors.cokTehlikeli,
                ),
              ),
            ),
          ),
        ),
    ],
  );
}
