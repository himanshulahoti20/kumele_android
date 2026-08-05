import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class CreateEventAddressFields extends StatelessWidget {
  const CreateEventAddressFields({
    super.key,
    required this.streetController,
    required this.homeNumberController,
    required this.districtController,
    required this.zipController,
    required this.stateController,
  });

  final TextEditingController streetController;
  final TextEditingController homeNumberController;
  final TextEditingController districtController;
  final TextEditingController zipController;
  final TextEditingController stateController;

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hintText,
    bool isNumber = false,
    bool compact = false,
  }) {
    final hint = hintText ?? label;

    if (isNumber) {
      if (compact) {
        return KumeleTextField(
          controller: controller,
          hintText: hint,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        );
      }

      return KumeleTextField.number(
        controller: controller,
        labelText: label,
        hintText: hint,
      );
    }

    return KumeleTextField.normal(
      controller: controller,
      labelText: compact ? null : label,
      hintText: hint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 17,
            children: [
              Expanded(
                flex: 3,
                child: _field(
                  controller: streetController,
                  label: 'Street',
                  hintText: 'Enter street',
                ),
              ),
              Expanded(
                flex: 2,
                child: _field(
                  controller: homeNumberController,
                  label: 'Home Number',
                  hintText: 'Enter home number',
                ),
              ),
              Expanded(
                flex: 3,
                child: _field(
                  controller: districtController,
                  label: 'District',
                  hintText: 'Enter district',
                ),
              ),
            ],
          ),
          const Gap(15),
          Row(
            spacing: 17,
            children: [
              Expanded(
                flex: 3,
                child: _field(
                  controller: zipController,
                  label: 'Postal/zip code',
                  hintText: 'Enter postal or zip code',
                  isNumber: true,
                ),
              ),
              Expanded(
                flex: 2,
                child: _field(
                  controller: stateController,
                  label: 'State',
                  hintText: 'Enter state',
                ),
              ),
              const Expanded(flex: 3, child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
      phone: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 50,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          _field(controller: streetController, label: 'Street', compact: true),
          _field(
            controller: homeNumberController,
            label: 'Home Number',
            compact: true,
          ),
          _field(
            controller: districtController,
            label: 'District',
            compact: true,
          ),
          _field(
            controller: zipController,
            label: 'Postal/zip code',
            isNumber: true,
            compact: true,
          ),
          _field(controller: stateController, label: 'State', compact: true),
        ],
      ),
    );
  }
}
