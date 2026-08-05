import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/models/event_location.dart';
import 'package:kuemele/shared/widgets/location_picker/event_location_picker.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class EventAddressCard extends StatelessWidget {
  const EventAddressCard({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
    required this.onClearLocation,
  });

  final EventLocation? selectedLocation;
  final ValueChanged<EventLocation> onLocationSelected;
  final VoidCallback onClearLocation;

  Future<void> _openPicker(BuildContext context) async {
    final result = await EventLocationPicker.show(
      context,
      initial: selectedLocation,
    );
    if (result != null) {
      onLocationSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation = selectedLocation != null;

    return GestureDetector(
      onTap: () => _openPicker(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: ColorSet.tileFillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasLocation ? ColorSet.specialYellowColor : ColorSet.border,
            width: hasLocation ? 1.5 : 1,
          ),
        ),
        child: hasLocation
            ? _FilledView(
                location: selectedLocation!,
                onEdit: () => _openPicker(context),
                onClear: onClearLocation,
              )
            : const _EmptyView(),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorSet.specialYellowColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.location_on_outlined,
            color: ColorSet.specialYellowColor,
            size: 22,
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.pickEventLocationPlaceholder,
                style: context.textTheme.bodyMediumSemiBold.copyWith(
                  color: ColorSet.textColor,
                ),
              ),
              const Gap(3),
              Text(
                AppStrings.tapToOpenMapPlaceholder,
                style: context.textTheme.bodySmall.copyWith(
                  color: ColorSet.textColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: ColorSet.textColor.withValues(alpha: 0.4),
          size: 20,
        ),
      ],
    );
  }
}

class _FilledView extends StatelessWidget {
  const _FilledView({
    required this.location,
    required this.onEdit,
    required this.onClear,
  });

  final EventLocation location;
  final VoidCallback onEdit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorSet.specialYellowColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 22),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            location.displayAddress,
            style: context.textTheme.bodySmall.copyWith(
              color: ColorSet.textColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Gap(8),
        GestureDetector(
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.edit_outlined,
                color: ColorSet.specialYellowColor, size: 18),
          ),
        ),
        const Gap(4),
        GestureDetector(
          onTap: onClear,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.close,
                color: ColorSet.textColor.withValues(alpha: 0.5), size: 18),
          ),
        ),
      ],
    );
  }
}
