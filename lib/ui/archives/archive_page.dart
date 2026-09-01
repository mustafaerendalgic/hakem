import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/archive_cubit.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/archive_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/ui/common/search_bar.dart';
import 'package:isg_ihlal/ui/common/sorry_empty.dart';
import 'package:isg_ihlal/ui/common/violation_card.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beyaz,
      body: BlocBuilder<ArchiveCubit, ArchiveStates>(
        builder: (context, state) {
          if (state is ArchiveLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ArchiveErrorState) {
            return Center(
              child: Text(
                "Bir hata oluştu: ${state.error}",
                style: TextStyles.body,
              ),
            );
          }

          if (state is ArchiveLoadedState) {
            final List<Violation> archives = state.archives;

            if (archives.isEmpty) {
              return Center(
                child: SorryEmpty(() {
                  context.read<ArchiveCubit>().listenToArchives();
                }, "arşivler"),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchBarSection(),
                          const SizedBox(height: 16),
                          Text(
                            "Reddedilen İhlaller",
                            style: TextStyles.titlesBold.copyWith(
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final item = archives[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: InkWell(
                            onTap: () {
                              NavigationSession.instance.navigateToDetail(item);
                            },
                            child: ViolationCard(item),
                          ),
                        );
                      },
                      childCount: archives.length,
                    ),
                    itemExtent: 451,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
