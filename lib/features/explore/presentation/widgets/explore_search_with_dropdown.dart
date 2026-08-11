import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/theme/app_input_styles.dart';
import 'package:kuemele/shared/widgets/dropdown_textfield/dropdown_textfield.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ExploreSearchWithDropdown extends StatelessWidget {
  const ExploreSearchWithDropdown({
    super.key,
    this.hint,
    this.radius = 8,
    this.dropDownList,
    this.onTextChanged,
  });

  final String? hint;
  final double radius;
  final List<DropDownValueModel>? dropDownList;
  final ValueChanged<String>? onTextChanged;

  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      readOnly: false,
      clearOption: true,
      dropDownIconProperty: IconProperty(
        color: ColorSet.bgColor.withValues(alpha: 0),
      ),
      textFieldDecoration:
          AppInputStyles.borderlessInputDeco(radius: radius).copyWith(
        hintText: hint,
        prefixIconConstraints:
            const BoxConstraints(minHeight: 10, minWidth: 10),
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
          child: KumeleAssetWidget.square(
            assetPath: Assets.icons.search.path,
            size: 20,
            color: ColorSet.color525252,
          ),
        ),
      ),
      dropdownDecoration: BoxDecoration(
        color: ColorSet.tileFontRevertColor,
        borderRadius: BorderRadius.circular(size(8)),
        boxShadow: [
          BoxShadow(
            color: ColorSet.revertBgColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      onTextFieldChanged: onTextChanged,
      dropDownList: dropDownList ?? const [],
    );
  }
}

typedef SearchWithDropdown = ExploreSearchWithDropdown;
