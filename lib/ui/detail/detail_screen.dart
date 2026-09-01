import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/details_cubit.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/session/constant_strings.dart';
import 'package:isg_ihlal/data/session/navigation_enum.dart';
import 'package:isg_ihlal/data/session/navigation_session.dart';
import 'package:isg_ihlal/data/states/detail_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:isg_ihlal/ui/common/action_type_tag.dart';
import 'package:isg_ihlal/ui/common/parse_date.dart';
import 'package:isg_ihlal/util/get_risk_color.dart';
import 'package:isg_ihlal/util/risk_string.dart';

class DetailScreen extends StatefulWidget {
  final Violation violation;
  const DetailScreen({required this.violation, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Violation _lastViolation;

  @override
  void initState() {
    super.initState();
    _lastViolation = widget.violation;
    context.read<DetailsCubit>().listenToViolation(widget.violation.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailStates>(
      builder: (context, state) {
        if (state is DetailLoaded) {
          _lastViolation = state.violation;
        }
        final activeViolation = _lastViolation;

        return Scaffold(
          backgroundColor: AppColors.beyaz,
          body: SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: activeViolation.imageUrl,
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getRiskColor(activeViolation.violationType),
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
                            getRiskString(activeViolation),
                            style: TextStyles.bodyBold,
                          ),
                          Spacer(),
                          ActionTypeTag(activeViolation),
                        ],
                      ),
                      Text(
                        activeViolation.description,
                        style: TextStyles.navigationLabelRegular,
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.location_on_outlined, size: 24),
                          Text(
                            activeViolation.location,
                            style: TextStyles.captionBold,
                          ),
                        ],
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 20),
                          Text(
                            getTheMonth(activeViolation.date) +
                                ", " +
                                getTheTime(activeViolation.date),
                            style: TextStyles.captionBold,
                          ),
                        ],
                      ),
                      if (activeViolation.actionWhen != null)
                        Row(
                          spacing: 8,
                          children: [
                            Icon(switch (activeViolation.actionType) {
                              ActionType.investigating => Icons.search_rounded,
                              ActionType.resolved => Icons.check_rounded,
                              ActionType.posted => Icons.search_rounded,
                              ActionType.rejected => Icons.search_rounded,
                            }, size: 24),
                            Text(
                              getTheMonth(activeViolation.actionWhen!) +
                                  ", " +
                                  getTheTime(activeViolation.actionWhen!),
                              style: TextStyles.captionBold,
                            ),
                          ],
                        ),
                      if (activeViolation.actionByWho != null)
                        Row(
                          spacing: 8,
                          children: [
                            Icon(Icons.person_rounded, size: 24),
                            Text(
                              activeViolation.actionByWho!,
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
              child: DetailScreenButtons(activeViolation, state),
            ),
          ),
        );
      },
    );
  }
}

class DetailScreenButtons extends StatelessWidget {
  final Violation violation;
  final DetailStates state;
  const DetailScreenButtons(this.violation, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseProvider.instance.uid;
    if (uid == null) throw Exception("Geçersiz kullanıcı");
    if (violation.actionType == ActionType.investigating &&
        uid != violation.uid) {
      return const SizedBox.shrink();
    }

    final cubit = context.read<DetailsCubit>();
    final bool isLoading = state is DetailViolationCanceling ||
        state is DetailViolationInvestigating ||
        state is DetailViolationResolving ||
        state is DetailViolationReopening;

    final bool isTopLoading = state is DetailViolationInvestigating ||
        state is DetailViolationResolving ||
        state is DetailViolationReopening;

    final bool isBottomLoading = state is DetailViolationCanceling;

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

    VoidCallback topButtonAction = switch (violation.actionType) {
      ActionType.investigating => () => cubit.resolveViolation(violation),
      ActionType.resolved => () => cubit.reopenViolation(violation),
      ActionType.posted => () => cubit.takeUnderReview(violation),
      ActionType.rejected => () => {cubit.reopenViolation(violation)},
    };

    return AbsorbPointer(
      absorbing: isLoading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          InkWell(
            onTap: topButtonAction,
            child: SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: topButtonColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: isTopLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.beyaz,
                          ),
                        )
                      : Text(
                          topButtontext,
                          style: TextStyles.bodyBold
                              .copyWith(color: AppColors.beyaz),
                        ),
                ),
              ),
            ),
          ),
          if (!shouldDisplayOneButton)
            InkWell(
              onTap: () => cubit.cancelViolation(violation),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.beyaz,
                    border: Border.all(
                      color: AppColors.cokTehlikeli,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: isBottomLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.cokTehlikeli,
                            ),
                          )
                        : Text(
                            ConstantButtonStrings.cancel,
                            style: TextStyles.bodyBold.copyWith(
                              color: AppColors.cokTehlikeli,
                            ),
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
