import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/notification_cubit.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/notification_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/ui/common/parse_date.dart';
import 'package:isg_ihlal/util/get_risk_color.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beyaz,
      body: BlocBuilder<NotificationCubit, NotificationStates>(
        builder: (context, state) {
          if (state is NotificationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationErrorState) {
            return Center(
              child: Text(
                "Bir hata oluştu: ${state.error}",
                style: TextStyles.body,
              ),
            );
          }

          if (state is NotificationLoadedState) {
            final items = state.items;

            if (items.isEmpty) {
              return const Center(
                child: Text(
                  "Henüz bildiriminiz bulunmamaktadır.",
                  style: TextStyles.body,
                ),
              );
            }

            // Tarih gruplaması (Bugün, Dün, Daha Önce)
            final Map<String, List<NotificationItem>> groupedItems = {};
            for (final item in items) {
              final group = _getDateGroup(item.violation.date);
              groupedItems.putIfAbsent(group, () => []).add(item);
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: groupedItems.keys.length,
              itemBuilder: (context, index) {
                final groupTitle = groupedItems.keys.elementAt(index);
                final groupList = groupedItems[groupTitle]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        groupTitle,
                        style: TextStyles.titlesBold.copyWith(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    ...groupList.map((item) {
                      return _NotificationTile(
                        violation: item.violation,
                        isNew: item.isNew,
                        onTap: () {
                          NavigationSession.instance.navigateToDetail(
                            item.violation,
                          );
                        },
                      );
                    }),
                  ],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  static String _getDateGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return "Bugün";
    } else if (itemDate == yesterday) {
      return "Dün";
    } else {
      return getTheMonth(date);
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final Violation violation;
  final bool isNew;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.violation,
    required this.isNew,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color riskColor = getRiskColor(violation.violationType);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isNew ? const Color(0xFFF0F1F3) : AppColors.beyaz,
          border: Border(
            bottom: BorderSide(
              color: AppColors.acikGri.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sol İkon + "Yeni" Badge Stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: riskColor,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 24,
                      color: AppColors.beyaz,
                    ),
                  ),
                ),
                if (isNew)
                  Positioned(
                    top: -6,
                    left: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Yeni",
                        style: TextStyle(
                          color: AppColors.beyaz,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Orta Açıklama Metni
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "${violation.location} bölgesinde ${violation.violationType.title.toLowerCase()} bir ihlal tespit edildi. ",
                      style: TextStyles.navigationLabelRegular.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: isNew ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: _formatTimeAgo(violation.date),
                      style: TextStyles.caption.copyWith(
                        color: AppColors.gray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),

            // Sağ Görsel Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 48,
                height: 48,
                child: CachedNetworkImage(
                  imageUrl: violation.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.acikGri,
                    child: const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.acikGri,
                    child: const Icon(Icons.broken_image, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "Az önce";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} dakika önce";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} saat önce";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} gün önce";
    } else {
      return "${(difference.inDays / 30).floor()} ay önce";
    }
  }
}
