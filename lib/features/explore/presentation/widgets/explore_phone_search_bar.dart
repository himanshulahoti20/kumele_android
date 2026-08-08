import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_search_with_dropdown.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ExplorePhoneSearchBar extends StatelessWidget {
  const ExplorePhoneSearchBar({
    super.key,
    required this.isExpanded,
    required this.onTapSearch,
    this.onTextChanged,
    this.hint,
  });

  final bool isExpanded;
  final VoidCallback onTapSearch;
  final ValueChanged<String>? onTextChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: 200.milliseconds,
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTapSearch,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ColorSet.tileFontRevertColor,
                shape: BoxShape.circle,
              ),
              child: KumeleAssetWidget.square(
                assetPath: Assets.icons.search.path,
                size: 20,
                color: ColorSet.color525252,
              ),
            ),
          ),
          if (isExpanded)
            ExploreSearchWithDropdown(
              hint: hint ?? AppLocalizations.of(context)!.exploreSearchHint,
              radius: 200,
              onTextChanged: onTextChanged,
            ),
        ],
      ),
    );
  }
}
