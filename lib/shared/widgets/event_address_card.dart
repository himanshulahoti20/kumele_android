import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/models/event_location.dart';

class EventAddressCard extends StatefulWidget {
  const EventAddressCard({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
    required this.onClearLocation,
    this.showValidationErrors = false,
  });

  final EventLocation? selectedLocation;
  final ValueChanged<EventLocation> onLocationSelected;
  final VoidCallback onClearLocation;
  final bool showValidationErrors;

  @override
  State<EventAddressCard> createState() => _EventAddressCardState();
}

class _EventAddressCardState extends State<EventAddressCard> {
  late final TextEditingController _streetController;
  late final TextEditingController _homeNumberController;
  late final TextEditingController _districtController;
  late final TextEditingController _zipController;
  late final TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    final location = widget.selectedLocation;
    _streetController = TextEditingController(text: location?.street);
    _homeNumberController = TextEditingController(text: location?.homeNumber);
    _districtController = TextEditingController(text: location?.district);
    _zipController = TextEditingController(text: location?.postalCode);
    _stateController = TextEditingController(text: location?.stateName);

    for (final controller in _controllers) {
      controller.addListener(_syncLocation);
    }
  }

  List<TextEditingController> get _controllers => [
        _streetController,
        _homeNumberController,
        _districtController,
        _zipController,
        _stateController,
      ];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncLocation() {
    setState(() {});

    final street = _streetController.text.trim();
    final homeNumber = _homeNumberController.text.trim();
    final district = _districtController.text.trim();
    final postalCode = _zipController.text.trim();
    final stateName = _stateController.text.trim();

    if ([street, district, postalCode, stateName].any((value) => value.isEmpty)) {
      widget.onClearLocation();
      return;
    }

    final fullStreet = [street, homeNumber]
        .where((value) => value.isNotEmpty)
        .join(' ');

    widget.onLocationSelected(
      EventLocation(
        latitude: 0,
        longitude: 0,
        displayAddress: '$fullStreet, $district, $postalCode, $stateName',
        street: street,
        homeNumber: homeNumber,
        district: district,
        postalCode: postalCode,
        stateName: stateName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;
        final spacing = isCompact ? 10.0 : 17.0;

        return Wrap(
          spacing: spacing,
          runSpacing: 12,
          children: [
            _AddressField(
              width: _fieldWidth(constraints.maxWidth, spacing, isCompact),
              controller: _streetController,
              hintText: l10n.createEventStreetLabel,
              showValidationErrors: widget.showValidationErrors,
            ),
            _AddressField(
              width: _fieldWidth(constraints.maxWidth, spacing, isCompact),
              controller: _homeNumberController,
              hintText: l10n.createEventHomeNumberLabel,
              showValidationErrors: widget.showValidationErrors,
            ),
            _AddressField(
              width: _fieldWidth(constraints.maxWidth, spacing, isCompact),
              controller: _districtController,
              hintText: l10n.createEventDistrictLabel,
              showValidationErrors: widget.showValidationErrors,
            ),
            _AddressField(
              width: _fieldWidth(constraints.maxWidth, spacing, isCompact),
              controller: _zipController,
              hintText: l10n.createEventPostalCodeLabel,
              isNumber: true,
              showValidationErrors: widget.showValidationErrors,
            ),
            _AddressField(
              width: _fieldWidth(constraints.maxWidth, spacing, isCompact),
              controller: _stateController,
              hintText: l10n.createEventStateLabel,
              showValidationErrors: widget.showValidationErrors,
            ),
          ],
        );
      },
    );
  }

  double _fieldWidth(double maxWidth, double spacing, bool isCompact) {
    if (!isCompact) return (maxWidth - spacing * 2) / 3;
    return (maxWidth - spacing) / 2;
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.width,
    required this.controller,
    required this.hintText,
    required this.showValidationErrors,
    this.isNumber = false,
  });

  final double width;
  final TextEditingController controller;
  final String hintText;
  final bool showValidationErrors;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    final isEmpty = controller.text.trim().isEmpty;
    final showError = showValidationErrors && isEmpty;

    return SizedBox(
      width: width,
      child: KumeleTextField(
        controller: controller,
        hintText: hintText,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        fillColor: ColorSet.textBoxBgColor,
        showBorder: true,
        borderColor: showError ? Colors.red : Colors.transparent,
        focusedBorderColor: showError ? Colors.red : ColorSet.textColor,
      ),
    );
  }
}
