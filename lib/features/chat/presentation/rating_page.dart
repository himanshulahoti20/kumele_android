import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/close_keyboard_widget.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/rating.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/events/events_repo.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class RatingPage extends StatefulWidget implements BasePage {
  const RatingPage({super.key, this.embedded = false, this.eventId = ''});

  final bool embedded;
  final String eventId;

  @override
  State<RatingPage> createState() => _RatingPageState();

  @override
  String get screenName => 'RatingPage';
}

class _RatingPageState extends State<RatingPage> {
  final _commentController = TextEditingController();
  final Map<RatingType, double> ratingSummaryData = {
    RatingType.communication: 0,
    RatingType.respect: 0,
    RatingType.professional: 0,
    RatingType.atmosphere: 0,
    RatingType.value: 0,
  };
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.eventId.isEmpty) {
      goBack();
      return;
    }
    final stars = ratingSummaryData.values;
    if (stars.any((v) => v <= 0)) {
      InjectionHelper.snackBar.showError(
        AppLocalizations.of(context)!.pleaseCompleteAllFields,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final overall =
        (stars.reduce((a, b) => a + b) / stars.length).round().clamp(1, 5);

    try {
      await EventsRepo.rateEvent(
        eventId: widget.eventId,
        eventRating: overall,
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
        communication:
            ratingSummaryData[RatingType.communication]!.round().clamp(1, 5),
        respect: ratingSummaryData[RatingType.respect]!.round().clamp(1, 5),
        professionalism:
            ratingSummaryData[RatingType.professional]!.round().clamp(1, 5),
        atmosphere:
            ratingSummaryData[RatingType.atmosphere]!.round().clamp(1, 5),
        valueForMoney:
            ratingSummaryData[RatingType.value]!.round().clamp(1, 5),
      );
      if (!mounted) return;
      InjectionHelper.snackBar.showSuccess(
        AppLocalizations.of(context)!.ratingSubmittedSuccess,
      );
      goBack();
    } on ApiException catch (e) {
      if (!mounted) return;
      InjectionHelper.snackBar.showError(
        e.error ?? AppLocalizations.of(context)!.ratingSubmitFailed,
      );
    } catch (_) {
      if (!mounted) return;
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.ratingSubmitFailed);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void goBack() {
    if (FormFactor.isTablet) {
      InjectionHelper.homePageCubit.goBack(context);
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return SingleChildScrollView(child: buildContent());
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goBack();
      },
      child: Scaffold(
        backgroundColor: ColorSet.bgColor,
        body: WidgetByDevice(
          tablet: buildTablet(),
          phone: Container(
            color: ColorSet.bg3Color,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(26, 16, 26, 0),
                child: Column(
                  children: [
                    MobileHeader(label: AppLocalizations.of(context)!.ratingPageTitle),
                    const Gap(22),
                    Expanded(
                      child: SingleChildScrollView(child: buildContent()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTablet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorSet.bg3Color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: goBack,
                    child: KumeleAssetWidget(
                      assetPath: IconSet.arrowleft,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(40),
                  Text(
                    AppLocalizations.of(context)!.ratingsTitle,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.5, color: Colors.grey[200]),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: buildContent(),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return CloseKeyboard(
      child: SizedBox(
        width: FormFactor.isTablet ? Utils.getLongestSide * 0.45 : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.rateEventTitle,
              style: context.textTheme.bodyMediumBold
                  .copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
            ),
            Gap(size(10)),
            Text(
              AppLocalizations.of(context)!.attendeeRatingsLabel,
              style: context.textTheme.bodySmallSemiBold.copyWith(
                color: ColorSet.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(15),
            RARatingSummary(
              ratingSummaryData: ratingSummaryData,
              showValue: false,
              onChanged: (type, star) {
                setState(() {
                  ratingSummaryData[type] = star;
                });
              },
            ),
            Gap(size(10)),
            Text(
              AppLocalizations.of(context)!.comment,
              style: context.textTheme.bodyMediumBold
                  .copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
            ),
            Gap(size(10)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: ColorSet.bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.addCommentsHint,
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Gap(size(45)),
            AppButton.primary(
              onPressed: _isSubmitting ? null : _submit,
              isLoading: _isSubmitting,
              width: FormFactor.isTablet ? 300 : null,
              fullWidth: !FormFactor.isTablet,
              label: AppLocalizations.of(context)!.send,
            ),
          ],
        ),
      ),
    );
  }
}
