import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/notification_cubit.dart';
import 'package:isg_ihlal/data/cubits/violation_cubit.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/home_states.dart';
import 'package:isg_ihlal/data/states/notification_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  TopAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.beyaz,
        boxShadow: [
          BoxShadow(spreadRadius: 0, blurRadius: 4, color: AppColors.acikGri),
        ],
      ),
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
                context.read<ViolationCubit>().addViolations();
              },
              icon: Icon(Icons.upload),
            ),
            IconButton(
              onPressed: () {
                NavigationSession.instance.updateIndex(
                  NavigationElement.archives,
                );
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
                NavigationSession.instance.updateIndex(
                  NavigationElement.notifications,
                );
              },
              icon: BlocBuilder<NotificationCubit, NotificationStates>(
                builder: (context, state) {
                  int _unseenViolations = 0;
                  if (state is NotificationLoadedState) {
                    _unseenViolations = state.notifications.length;
                  }
                  return Badge(
                    backgroundColor: AppColors.beyaz,
                    textColor: AppColors.primary,
                    label: Text(
                      _unseenViolations.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    isLabelVisible: _unseenViolations > 0,
                    alignment: AlignmentDirectional.topEnd,
                    offset: Offset(0, -4),
                    child: Icon(
                      Icons.notifications_rounded,
                      size: 30,
                      color: AppColors.primary,
                    ),
                  );
                },
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
