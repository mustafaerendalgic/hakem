import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/authentication_cubit.dart';
import 'package:isg_ihlal/data/cubits/violation_cubit.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/states/authentication_states.dart';
import 'package:isg_ihlal/data/states/home_states.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/ui/common/search_bar.dart';
import 'package:isg_ihlal/ui/common/sorry_empty.dart';
import 'package:isg_ihlal/ui/common/top_bar.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ViolationCubit, ViolationStates>(
        builder: (context, state) {
          if (state is ViolationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ViolationLoadedState) {
            final List<Violation> violations = state.violations;
            if (violations.length == 0) {
              return Center(
                child: SorryEmpty(() {
                  context.read<ViolationCubit>().listenToTheList();
                }, "burası"),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [SearchBarSection()],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
