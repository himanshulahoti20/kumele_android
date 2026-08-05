import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/map_config.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/event_location.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/widgets/location_picker/location_picker_cubit.dart';
import 'package:kuemele/shared/widgets/location_picker/location_picker_state.dart';
import 'package:latlong2/latlong.dart';

class EventLocationPicker extends StatefulWidget {
  const EventLocationPicker({super.key, this.initial});

  final EventLocation? initial;

  static Future<EventLocation?> show(
    BuildContext context, {
    EventLocation? initial,
  }) {
    final initialCentre = initial != null
        ? LatLng(initial.latitude, initial.longitude)
        : const LatLng(MapConfig.defaultLatitude, MapConfig.defaultLongitude);

    context.read<LocationPickerCubit>().setInitialLocation(
          initialCentre: initialCentre,
          initialAddress: initial?.displayAddress,
        );

    return Navigator.of(context).push<EventLocation>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => EventLocationPicker(initial: initial),
      ),
    );
  }

  @override
  State<EventLocationPicker> createState() => _EventLocationPickerState();
}

class _EventLocationPickerState extends State<EventLocationPicker> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.bgColor,
      appBar: AppBar(
        backgroundColor: ColorSet.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: ColorSet.textColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.pickEventLocation,
          style: context.textTheme.titleMediumSemiBold.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<LocationPickerCubit, LocationPickerState>(
        listenWhen: (previous, current) =>
            previous.mapTargetMove != current.mapTargetMove ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.mapTargetMove != null) {
            _mapController.move(state.mapTargetMove!, MapConfig.defaultZoom);
            context.read<LocationPickerCubit>().onMapTargetMoveCompleted();
          }
          if (state.errorMessage != null) {
            InjectionHelper.snackBar.showError(state.errorMessage!);
            context.read<LocationPickerCubit>().onErrorShown();
          }
        },
        child: Stack(
          children: [
            BlocBuilder<LocationPickerCubit, LocationPickerState>(
              buildWhen: (previous, current) => false,
              builder: (context, state) {
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: state.centre,
                    initialZoom: MapConfig.defaultZoom,
                    onMapEvent: (event) {
                      if (event is MapEventMoveEnd) {
                        context
                            .read<LocationPickerCubit>()
                            .onMapMoved(event.camera.center);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: MapConfig.osmUrlTemplate,
                      userAgentPackageName: MapConfig.userAgentPackageName,
                    ),
                  ],
                );
              },
            ),
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MapPin(),
                  Gap(36),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 200,
              child: BlocBuilder<LocationPickerCubit, LocationPickerState>(
                buildWhen: (previous, current) =>
                    previous.isLocating != current.isLocating,
                builder: (context, state) {
                  return FloatingActionButton.small(
                    backgroundColor: ColorSet.bgColor,
                    onPressed: state.isLocating
                        ? null
                        : () => context
                            .read<LocationPickerCubit>()
                            .goToMyLocation(),
                    child: state.isLocating
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorSet.specialYellowColor,
                            ),
                          )
                        : Icon(Icons.my_location,
                            color: ColorSet.specialYellowColor),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorSet.bgColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: AppBottomSheet(
                    showDragHandle: true,
                    showCloseButton: false,
                    titleWidget: Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: ColorSet.specialYellowColor, size: 20),
                        const Gap(8),
                        Text(
                          AppStrings.selectedLocation,
                          style: context.textTheme.bodyMediumSemiBold.copyWith(
                            color: ColorSet.textColor,
                          ),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child:
                        BlocBuilder<LocationPickerCubit, LocationPickerState>(
                      buildWhen: (previous, current) =>
                          previous.address != current.address ||
                          previous.isGeocoding != current.isGeocoding,
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: state.isGeocoding
                                  ? Row(
                                      key: const ValueKey('loading'),
                                      children: [
                                        SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: ColorSet.specialYellowColor,
                                          ),
                                        ),
                                        const Gap(8),
                                        Text(
                                          AppStrings.fetchingAddress,
                                          style: context.textTheme.bodySmall
                                              .copyWith(
                                            color: ColorSet.textColor
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      key: const ValueKey('address'),
                                      state.address,
                                      style:
                                          context.textTheme.bodySmall.copyWith(
                                        color: ColorSet.textColor
                                            .withValues(alpha: 0.75),
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                            const Gap(20),
                            AppButton.primary(
                              label: AppStrings.confirmLocation,
                              onPressed: () {
                                context.pop(
                                  EventLocation(
                                    latitude: state.centre.latitude,
                                    longitude: state.centre.longitude,
                                    displayAddress: state.address,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: ColorSet.specialYellowColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ColorSet.specialYellowColor.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 20),
        ),
        CustomPaint(
          size: const Size(12, 10),
          painter: _PinTailPainter(color: ColorSet.specialYellowColor),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  const _PinTailPainter({required this.color});
  final Color color;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = ui.Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PinTailPainter old) => old.color != color;
}
