import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/violation_cubit.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/states/home_states.dart';
import 'package:isg_ihlal/ui/common/sorry_empty.dart';
import 'package:isg_ihlal/ui/common/top_bar.dart';

class ArchivePage extends StatelessWidget {
  ArchivePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationCubit, ViolationStates>(
      builder: (context, state) {
        if (state is ViolationLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ViolationLoadedState) {
          List<Violation> violations = state.violations;
          if (violations.length == 0) {
            return Center(
              child: SorryEmpty(() {
                context.read<ViolationCubit>().listenToTheArchives();
              }, "arşivler"),
            );
          }
          return Center(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16,
                    children: [],
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
