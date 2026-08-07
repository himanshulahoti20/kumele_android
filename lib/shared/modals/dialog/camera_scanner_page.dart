import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScannerSheet extends StatefulWidget {
  const CameraScannerSheet({super.key});

  @override
  State<CameraScannerSheet> createState() => _CameraScannerSheetState();
}

class _CameraScannerSheetState extends State<CameraScannerSheet> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned || !mounted) return;

    for (final barcode in capture.barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        _hasScanned = true;
        context.pop(code);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const scanSize = 220.0;
    final themeColor = ColorSet.specialColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 340,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.55),
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: Colors.black),
                      Center(
                        child: Container(
                          width: scanSize,
                          height: scanSize,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: scanSize,
                    height: scanSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: themeColor, width: 2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(16),
        Text(
          AppLocalizations.of(context)!.alignQrInFrame,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.subTextColor,
          ),
        ),
        const Gap(8),
        ValueListenableBuilder<MobileScannerState>(
          valueListenable: _controller,
          builder: (context, state, _) {
            final isOn = state.torchState == TorchState.on;
            return IconButton(
              onPressed: () => _controller.toggleTorch(),
              icon: Icon(
                isOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                color: isOn ? themeColor : ColorSet.textColor,
                size: 28,
              ),
            );
          },
        ),
      ],
    );
  }
}
