import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive_extensions.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class KumeleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool isRequired;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final bool filled;
  final TextInputAction? textInputAction;
  final bool showBorder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final String? initialValue;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final double? labelGap;
  final bool manageObscureText;
  final String? obscureToggleAssetPath;

  const KumeleTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.isRequired = false,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.filled = true,
    this.textInputAction,
    this.showBorder = false,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.autovalidateMode,
    this.focusNode,
    this.initialValue,
    this.contentPadding,
    this.borderRadius = 9,
    this.labelGap,
    this.manageObscureText = true,
    this.obscureToggleAssetPath,
  });

  factory KumeleTextField.search({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    bool filled = true,
    Color? fillColor,
    Color? borderColor,
    bool showBorder = false,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return KumeleTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      filled: filled,
      fillColor: fillColor ?? ColorSet.tileFillColor,
      borderColor: borderColor,
      showBorder: showBorder,
      focusNode: focusNode,
      prefixIcon: Padding(
        padding: EdgeInsetsDirectional.only(start: 16.w, end: 12.w),
        child: KumeleAssetWidget(
          assetPath: Assets.icons.blogs.search.path,
          width: KumeleTextField.prefixIconSize,
          height: KumeleTextField.prefixIconSize,
          color: ColorSet.subTextColor,
        ),
      ),
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  factory KumeleTextField.normal({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    bool isRequired = false,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    int? maxLines = 1,
    bool readOnly = false,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return KumeleTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      isRequired: isRequired,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      textDirection: textDirection,
      textAlign: textAlign,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: ColorSet.tileFillColor,
    );
  }

  factory KumeleTextField.number({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    bool isRequired = false,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
    bool? filled,
    Color? fillColor,
  }) {
    return KumeleTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      isRequired: isRequired,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters:
          inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
      focusNode: focusNode,
      filled: filled ?? true,
      fillColor: fillColor ?? ColorSet.tileFillColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.8.w),
    );
  }

  factory KumeleTextField.password({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    bool isRequired = false,
    String? prefixAssetPath,
    String? eyeAssetPath,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    bool enabled = true,
    TextInputAction? textInputAction,
  }) {
    return KumeleTextField(
      controller: controller,
      hintText: hintText ?? 'Enter Password',
      labelText: labelText,
      isRequired: isRequired,
      obscureText: true,
      manageObscureText: true,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      focusNode: focusNode,
      textInputAction: textInputAction,
      prefixIcon: _assetIcon(prefixAssetPath ?? IconSet.lockIcon),
      obscureToggleAssetPath: eyeAssetPath ?? IconSet.eyeIcon,
    );
  }

  factory KumeleTextField.fromAsset({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    String? prefixAssetPath,
    String? suffixAssetPath,
    VoidCallback? onSuffixTap,
    bool obscureText = false,
    bool isRequired = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    double iconSize = KumeleTextField.prefixIconSize,
    bool manageObscureText = true,
  }) {
    return KumeleTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      isRequired: isRequired,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      focusNode: focusNode,
      manageObscureText: manageObscureText && suffixAssetPath == null,
      prefixIcon: prefixAssetPath == null ? null : _assetIcon(prefixAssetPath),
      suffixIcon: suffixAssetPath == null
          ? null
          : GestureDetector(
              onTap: onSuffixTap,
              child: _assetIcon(suffixAssetPath, iconSize: 20, isPrefix: false),
            ),
    );
  }

  static const double prefixIconSize = 17;

  static Widget _assetIcon(
    String assetPath, {
    double iconSize = prefixIconSize,
    bool isPrefix = true,
  }) {
    return Center(
      widthFactor: 1.0,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: isPrefix ? 12.w : 8.w,
          end: isPrefix ? 8.w : 12.w,
        ),
        child: KumeleAssetWidget(
          assetPath: assetPath,
          width: iconSize,
          height: iconSize,
          color: ColorSet.textColor,
        ),
      ),
    );
  }

  @override
  State<KumeleTextField> createState() => _KumeleTextFieldState();
}

class _KumeleTextFieldState extends State<KumeleTextField> {
  late bool _obscureText;
  late TextEditingController _effectiveController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _bindController(initial: true);
  }

  @override
  void didUpdateWidget(covariant KumeleTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.manageObscureText &&
        oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _effectiveController.dispose();
      }
      _bindController(initial: true);
      return;
    }
    if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue) {
      final nextValue = widget.initialValue ?? '';
      if (_effectiveController.text != nextValue) {
        _effectiveController.value = TextEditingValue(
          text: nextValue,
          selection: TextSelection.collapsed(offset: nextValue.length),
        );
      }
    }
  }

  void _bindController({required bool initial}) {
    if (widget.controller != null) {
      _effectiveController = widget.controller!;
      _ownsController = false;
      if (initial &&
          (widget.initialValue ?? '').isNotEmpty &&
          _effectiveController.text.isEmpty) {
        final value = widget.initialValue!;
        _effectiveController.value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      }
      return;
    }
    _effectiveController = TextEditingController(text: widget.initialValue);
    _ownsController = true;
  }

  @override
  void dispose() {
    if (_ownsController) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.responsiveOrNull?.isPhone ?? true;
    final effectiveFillColor = widget.fillColor ?? ColorSet.tileFillColor;
    final effectiveBorderColor = widget.borderColor ?? ColorSet.border;
    final effectiveFocusedColor =
        widget.focusedBorderColor ?? ColorSet.textColor;
    final effectiveFontSize = 15.sp;
    final fieldMinHeight = 48.0;
    final effectiveLabelGap = widget.labelGap ?? 8.h;

    final showBuiltInObscureToggle = widget.obscureText &&
        widget.manageObscureText &&
        widget.suffixIcon == null;

    final effectiveSuffixIcon = showBuiltInObscureToggle
        ? (widget.obscureToggleAssetPath != null
            ? GestureDetector(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: KumeleTextField._assetIcon(
                  widget.obscureToggleAssetPath!,
                  iconSize: 20,
                  isPrefix: false,
                ),
              )
            : IconButton(
                iconSize: 20.sp,
                padding: EdgeInsets.all(2.w),
                constraints: BoxConstraints.tightFor(width: 40.w, height: 40.w),
                visualDensity:
                    isMobile ? VisualDensity.compact : VisualDensity.standard,
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20.sp,
                  color: ColorSet.subTextColor,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ))
        : widget.suffixIcon;

    final field = TextFormField(
      controller: _effectiveController,
      obscureText: widget.obscureText &&
          (widget.manageObscureText ? _obscureText : true),
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: effectiveFontSize,
        color: ColorSet.textColor,
        fontWeight: FontWeight.w400,
        fontFamily: AppTextTheme.fontFamily,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: effectiveSuffixIcon,
        prefixIconConstraints: widget.prefixIcon != null
            ? BoxConstraints.tightFor(width: 48.w, height: 48.w)
            : null,
        suffixIconConstraints: effectiveSuffixIcon != null
            ? BoxConstraints(minWidth: 40.w, minHeight: 40.w)
            : null,
        filled: widget.filled,
        fillColor: effectiveFillColor,
        isDense: true,
        constraints: widget.maxLines == 1
            ? BoxConstraints(
                minHeight: fieldMinHeight.w, maxHeight: fieldMinHeight.w)
            : null,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
                horizontal: widget.prefixIcon != null ? 0 : 11.85.w,
                vertical: widget.prefixIcon != null ? 0.0 : 12.w),
        hintStyle: TextStyle(
          fontSize: effectiveFontSize,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: ColorSet.subTextColor,
          fontFamily: AppTextTheme.fontFamily,
        ),
        errorStyle: TextStyle(
            fontSize: 12.sp, color: ColorSet.snackBarErrorBg, height: 1.2),
        border: _buildBorder(widget.borderRadius.r, effectiveBorderColor),
        enabledBorder:
            _buildBorder(widget.borderRadius.r, effectiveBorderColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(
            color: effectiveFocusedColor,
            width: 1.5.w,
          ),
        ),
        errorBorder:
            _buildBorder(widget.borderRadius.r, ColorSet.snackBarErrorBg),
        focusedErrorBorder: _buildBorder(
            widget.borderRadius.r, ColorSet.snackBarErrorBg,
            width: 1.5),
      ),
    );

    if (widget.labelText != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context, effectiveFontSize),
          Gap(effectiveLabelGap),
          SizedBox(height: fieldMinHeight.w, child: field),
        ],
      );
    }

    return SizedBox(height: fieldMinHeight.w, child: field);
  }

  Widget _buildLabel(BuildContext context, double effectiveFontSize) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.labelText,
            style: TextStyle(
              fontSize: (effectiveFontSize * 0.93).clamp(12, 18),
              fontWeight: FontWeight.w500,
              color: ColorSet.tileFontColor,
              fontFamily: AppTextTheme.fontFamily,
            ),
          ),
          if (widget.isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: (effectiveFontSize * 0.93).clamp(12, 18),
                fontWeight: FontWeight.w500,
                color: ColorSet.snackBarErrorBg,
                fontFamily: AppTextTheme.fontFamily,
              ),
            ),
        ],
      ),
    );
  }

  InputBorder _buildBorder(double radius, Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: widget.showBorder
          ? BorderSide(color: color, width: width.w)
          : BorderSide.none,
    );
  }
}

class KumeleTextArea extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool isRequired;
  final int maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool enabled;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCharacterCount;
  final int? maxLength;
  final String? maxLengthText;
  final String Function(int)? characterCountFormatter;
  final String? initialValue;
  final Color? fillColor;
  final double borderRadius;
  final double? labelGap;

  const KumeleTextArea({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.isRequired = false,
    this.maxLines = 3,
    this.minLines,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.showCharacterCount = false,
    this.maxLength,
    this.maxLengthText,
    this.characterCountFormatter,
    this.initialValue,
    this.fillColor,
    this.borderRadius = 9,
    this.labelGap,
  });

  @override
  State<KumeleTextArea> createState() => _KumeleTextAreaState();
}

class _KumeleTextAreaState extends State<KumeleTextArea> {
  late TextEditingController _internalController;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue);
      _isInternalController = true;
    } else {
      _internalController = widget.controller!;
    }
    if (widget.showCharacterCount || widget.maxLength != null) {
      _internalController.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    if (widget.showCharacterCount || widget.maxLength != null) {
      _internalController.removeListener(_onTextChanged);
    }
    if (_isInternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMinLines = widget.minLines ?? widget.maxLines;
    final currentLength = _internalController.text.length;
    final maxLength = widget.maxLength;
    final isOverLimit = maxLength != null && currentLength > maxLength;
    final effectiveFontSize = 15.sp;
    final effectiveLabelGap = widget.labelGap ?? 8.h;
    final showCounter = widget.showCharacterCount ||
        widget.maxLength != null ||
        widget.maxLengthText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.labelText,
                  style: TextStyle(
                    fontSize: (effectiveFontSize * 0.93).clamp(12, 18),
                    fontWeight: FontWeight.w500,
                    color: ColorSet.tileFontColor,
                    fontFamily: AppTextTheme.fontFamily,
                  ),
                ),
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: (effectiveFontSize * 0.93).clamp(12, 18),
                      fontWeight: FontWeight.w500,
                      color: ColorSet.snackBarErrorBg,
                      fontFamily: AppTextTheme.fontFamily,
                    ),
                  ),
              ],
            ),
          ),
          Gap(effectiveLabelGap),
        ],
        TextFormField(
          controller: _internalController,
          maxLines: widget.maxLines,
          minLines: effectiveMinLines,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (showCounter) {
              setState(() {});
            }
          },
          textAlign: widget.textDirection == TextDirection.rtl
              ? TextAlign.right
              : widget.textAlign,
          textDirection: widget.textDirection,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(
            fontSize: effectiveFontSize,
            color: ColorSet.textColor,
            fontWeight: FontWeight.w400,
            fontFamily: AppTextTheme.fontFamily,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: widget.fillColor ?? ColorSet.tileFillColor,
            isDense: false,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 11.85.w, vertical: 15.w),
            hintStyle: TextStyle(
              fontSize: effectiveFontSize,
              height: 1.0,
              fontWeight: FontWeight.w400,
              color: ColorSet.subTextColor,
              fontFamily: AppTextTheme.fontFamily,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide: BorderSide(
                color: ColorSet.textColor,
                width: 1.5.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide:
                  BorderSide(color: ColorSet.snackBarErrorBg, width: 1.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide:
                  BorderSide(color: ColorSet.snackBarErrorBg, width: 1.5.w),
            ),
            counterText: showCounter ? '' : null,
          ),
          validator: widget.validator,
        ),
        if (showCounter) ...[
          Gap(2.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.characterCountFormatter != null
                  ? widget.characterCountFormatter!(currentLength)
                  : maxLength != null
                      ? '$currentLength/$maxLength ${widget.maxLengthText ?? ''}'
                          .trim()
                      : '$currentLength',
              style: context.textTheme.bodySmall.copyWith(
                color: isOverLimit
                    ? ColorSet.snackBarErrorBg
                    : ColorSet.subTextColor,
                fontSize: (effectiveFontSize * 0.8).clamp(10, 16),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class SearchBarWithSuggestions extends StatefulWidget {
  final String? placeHolder;

  const SearchBarWithSuggestions({super.key, this.placeHolder});

  @override
  State<SearchBarWithSuggestions> createState() =>
      _SearchBarWithSuggestionsState();
}

class _SearchBarWithSuggestionsState extends State<SearchBarWithSuggestions> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showSuggestions = false;
  final List<String> _suggestions = const [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _showSuggestions = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final searchBarWidth = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width * 0.3
        : MediaQuery.of(context).size.width * 0.8;

    return Column(
      children: [
        SizedBox(
          width: searchBarWidth,
          height: 55,
          child: KumeleTextField.search(
            controller: _searchController,
            focusNode: _searchFocusNode,
            hintText: widget.placeHolder ?? 'Search Hobby Events',
            fillColor: ColorSet.tileFontRevertColor,
          ),
        ),
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            width: searchBarWidth,
            margin: EdgeInsets.only(top: size(1)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size(8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: size(orientation == Orientation.landscape ? 35 : 30),
                  child: ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -4),
                    minLeadingWidth: 0,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal:
                          size(orientation == Orientation.landscape ? 8 : 6),
                      vertical: 0,
                    ),
                    title: Text(
                      _suggestions[index],
                      style: TextStyle(
                        fontSize: size(
                            orientation == Orientation.landscape ? 14 : 12),
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      _searchController.text = _suggestions[index];
                      setState(() {
                        _showSuggestions = false;
                      });
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
