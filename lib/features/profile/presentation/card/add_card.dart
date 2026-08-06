import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';

class AddCardDialog extends StatefulWidget implements BasePage {
  const AddCardDialog({super.key});

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();

  @override
  String get screenName => 'AddCardDialog';
}

class _AddCardDialogState extends State<AddCardDialog> {
  bool _isSubmitting = false;

  Future<void> _addCard() async {
    setState(() => _isSubmitting = true);
    try {
      final setupIntent = await Web3Repo.createCardSetupIntent();
      final opened = await PaymentSdkService.presentStripePaymentSheet(
        setupIntent,
        primaryButtonLabel: 'Save card',
      );
      if (!opened) {
        InjectionHelper.snackBar.showError('Card setup is unavailable.');
        return;
      }
      InjectionHelper.snackBar.showSuccess('Card added successfully.');
      if (mounted) context.pop();
    } on ApiException catch (e) {
      InjectionHelper.snackBar.showError(e.error ?? 'Could not add card.');
    } catch (_) {
      InjectionHelper.snackBar.showError('Could not add card.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ColorSet.bg2Color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add card',
                    style: context.textTheme.titleLargeBold,
                  ),
                ),
                IconButton(
                  onPressed: _isSubmitting ? null : () => context.pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Gap(12),
            Text(
              'Card details are collected securely by Stripe.',
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            const Gap(24),
            AppButton.primary(
              label: 'Add Card',
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : _addCard,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
