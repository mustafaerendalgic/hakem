import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/ui/common/action_type_tag.dart';
import 'package:isg_ihlal/ui/common/parse_date.dart';
import 'package:isg_ihlal/util/get_badge_color.dart';
import 'package:isg_ihlal/util/get_risk_color.dart';
import 'package:isg_ihlal/util/risk_string.dart';

class ViolationCard extends StatelessWidget {
  final Violation violation;
  const ViolationCard(this.violation, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = getRiskColor(violation.violationType);
    final Color tagColor = getBadgeColor(violation.actionType);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: AppColors.kirli, offset: Offset(0, 2)),
        ],
        color: AppColors.beyaz,
        border: Border(top: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderColor,
                ),
                child: const Center(
                  child: Icon(Icons.warning, size: 28, color: AppColors.beyaz),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getRiskString(violation),
                      style: TextStyles.smallBodySemibold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Konum: ${violation.location}",
                      style: TextStyles.smallBodySemibold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ActionTypeTag(violation),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Text(
              violation.description,
              textAlign: TextAlign.start,
              style: TextStyles.caption,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: violation.imageUrl,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 48),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                getTheMonth(violation.date),
                style: TextStyles.smallBodySemibold,
              ),
              const SizedBox(width: 4),
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
