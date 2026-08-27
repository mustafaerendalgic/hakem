import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/notification_cubit.dart';
import 'package:isg_ihlal/data/states/notification_states.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NotificationsState();
  }
}

class _NotificationsState extends State<NotificationsScreen> {
  late final NotificationCubit _notCubit;

  @override
  void initState() {
    _notCubit = context.read<NotificationCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _notCubit.updateSeenStatus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationStates>(
      builder: (context, state) {
        if (state is NotificationLoadingState) {
          return Center(child: const CircularProgressIndicator());
        } else {
          return Container(
            child: Column(
              children: [Center(child: Text("notifications screen"))],
            ),
          );
        }
      },
    );
  }
}
