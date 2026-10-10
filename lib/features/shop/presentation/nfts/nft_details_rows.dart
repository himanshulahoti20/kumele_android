import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

/// "NFT Details" rows + QR, shared by the phone card deck and the tablet
/// dialog (each passes its own row style). Fetches `GET /nfts/{id}` because
/// the list endpoints carry no token number or QR — matches iOS.
class NftDetailsRows extends StatefulWidget {
  const NftDetailsRows({
    super.key,
    required this.item,
    required this.rowBuilder,
    required this.qrSize,
  });

  final NftItem item;
  final Widget Function(String label, String? value) rowBuilder;
  final double qrSize;

  @override
  State<NftDetailsRows> createState() => _NftDetailsRowsState();
}

class _NftDetailsRowsState extends State<NftDetailsRows> {
  NftItem? _detail;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant NftDetailsRows oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.id != oldWidget.item.id) _load();
  }

  Future<void> _load() async {
    final id = widget.item.id;
    try {
      final detail = await Web3Repo.getNftById(id);
      if (mounted && widget.item.id == id) setState(() => _detail = detail);
    } catch (_) {
      // List data stays on screen; the extra rows just don't appear.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detail = _detail;
    final shown =
        detail != null && detail.id == widget.item.id ? detail : widget.item;
    final qr = shown.qrCodeUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.rowBuilder(
          l10n.tokenIdLabel,
          shown.tokenNumber ?? (shown.tokenId != null ? '#${shown.tokenId}' : null),
        ),
        widget.rowBuilder(l10n.tokenStandardLabel, shown.tokenStandard),
        widget.rowBuilder(l10n.blockchainLabel, shown.blockchain),
        widget.rowBuilder(l10n.creatorLabel, shown.creator),
        if (qr != null && qr.isNotEmpty) ...[
          const Gap(12),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // Fixed white in both themes so the code stays scannable.
                color: LightColors.bg2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: KumeleAssetWidget(
                assetPath: qr,
                width: widget.qrSize,
                height: widget.qrSize,
                fit: BoxFit.contain,
                semanticLabel: 'NFT QR code',
              ),
            ),
          ),
        ],
      ],
    );
  }
}
