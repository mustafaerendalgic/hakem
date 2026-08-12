import 'package:flutter/material.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/session.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  TopAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(color: AppColors.beyaz, boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 4, color: AppColors.acikGri),]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          spacing: 8,
          children: [
            Image.asset("assets/logo.png", height: 32),
            Text("hakem", style: TextStyles.appTitleSemibold),
            Spacer(),
            IconButton(
              onPressed: () {
                Session.instance.updateIndex(NavigationElement.archives);
              },
              icon: Icon(
                Icons.archive_outlined,
                size: 30,
                color: AppColors.primary,
              ),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              onPressed: () {
                Session.instance.updateIndex(NavigationElement.notifications);
              },
              icon: Icon(
                Icons.notification_add_rounded,
                size: 30,
                color: AppColors.primary,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
