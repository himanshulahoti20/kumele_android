import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuemele/shared/components/app_colors.dart';

enum _AppLoadingIndicatorType {
  chasingDots,
  circle,
  cubeGrid,
  dancingSquare,
  doubleBounce,
  dualRing,
  fadingCircle,
  fadingCube,
  fadingFour,
  fadingGrid,
  foldingCube,
  hourGlass,
  pianoWave,
  pouringHourGlass,
  pouringHourGlassRefined,
  pulse,
  pulsingGrid,
  pumpingHeart,
  ring,
  ripple,
  rotatingCircle,
  rotatingPlain,
  spinningCircle,
  spinningLines,
  squareCircle,
  threeBounce,
  threeInOut,
  wanderingCubes,
  wave,
  waveSpinner,
}

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator.chasingDots({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.chasingDots,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.circle({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.circle,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.cubeGrid({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.cubeGrid,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.dancingSquare({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.dancingSquare,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.doubleBounce({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.doubleBounce,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.dualRing({
    Key? key,
    Color? color,
    double? size,
    double? lineWidth,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.dualRing,
          color: color,
          size: size,
          lineWidth: lineWidth,
        );

  const AppLoadingIndicator.fadingCircle({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.fadingCircle,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.fadingCube({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.fadingCube,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.fadingFour({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.fadingFour,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.fadingGrid({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.fadingGrid,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.foldingCube({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.foldingCube,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.hourGlass({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.hourGlass,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.pianoWave({
    Key? key,
    Color? color,
    double? size,
    SpinKitPianoWaveType? waveType,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.pianoWave,
          color: color,
          size: size,
          pianoWaveType: waveType,
        );

  const AppLoadingIndicator.pouringHourGlass({
    Key? key,
    Color? color,
    double? size,
    double? strokeWidth,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.pouringHourGlass,
          color: color,
          size: size,
          strokeWidth: strokeWidth,
        );

  const AppLoadingIndicator.pouringHourGlassRefined({
    Key? key,
    Color? color,
    double? size,
    double? strokeWidth,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.pouringHourGlassRefined,
          color: color,
          size: size,
          strokeWidth: strokeWidth,
        );

  const AppLoadingIndicator.pulse({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.pulse,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.pulsingGrid({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.pulsingGrid,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.pumpingHeart({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.pumpingHeart,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.ring({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.ring,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.ripple({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.ripple,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.rotatingCircle({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.rotatingCircle,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.rotatingPlain({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.rotatingPlain,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.spinningCircle({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.spinningCircle,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.spinningLines({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.spinningLines,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.squareCircle({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.squareCircle,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.threeBounce({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.threeBounce,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.threeInOut({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.threeInOut,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.wanderingCubes({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.wanderingCubes,
          color: color,
          size: size,
        );

  const AppLoadingIndicator.wave({
    Key? key,
    Color? color,
    double? size,
    SpinKitWaveType? waveType,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.wave,
          color: color,
          size: size,
          waveType: waveType,
        );

  const AppLoadingIndicator.waveSpinner({
    Key? key,
    Color? color,
    double? size,
  }) : this._(
          key: key,
          type: _AppLoadingIndicatorType.waveSpinner,
          color: color,
          size: size,
        );

  const AppLoadingIndicator._({
    super.key,
    required _AppLoadingIndicatorType type,
    this.color,
    this.size,
    this.lineWidth,
    this.waveType,
    this.pianoWaveType,
    this.strokeWidth,
  }) : _type = type;

  final _AppLoadingIndicatorType _type;
  final Color? color;
  final double? size;
  final double? lineWidth;
  final SpinKitWaveType? waveType;
  final SpinKitPianoWaveType? pianoWaveType;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? ColorSet.specialBlueColor;
    final resolvedSize = size ?? 20.w;

    return switch (_type) {
      _AppLoadingIndicatorType.chasingDots => SpinKitChasingDots(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.circle => SpinKitCircle(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.cubeGrid => SpinKitCubeGrid(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.dancingSquare => SpinKitDancingSquare(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.doubleBounce => SpinKitDoubleBounce(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.dualRing => SpinKitDualRing(
          color: resolvedColor,
          size: resolvedSize,
          lineWidth: lineWidth ?? 4.r,
        ),
      _AppLoadingIndicatorType.fadingCircle => SpinKitFadingCircle(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.fadingCube => SpinKitFadingCube(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.fadingFour => SpinKitFadingFour(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.fadingGrid => SpinKitFadingGrid(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.foldingCube => SpinKitFoldingCube(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.hourGlass => SpinKitHourGlass(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.pianoWave => SpinKitPianoWave(
          color: resolvedColor,
          size: resolvedSize,
          type: pianoWaveType ?? SpinKitPianoWaveType.center,
        ),
      _AppLoadingIndicatorType.pouringHourGlass => SpinKitPouringHourGlass(
          color: resolvedColor,
          size: resolvedSize,
          strokeWidth: strokeWidth ?? 2.r,
        ),
      _AppLoadingIndicatorType.pouringHourGlassRefined =>
        SpinKitPouringHourGlassRefined(
          color: resolvedColor,
          size: resolvedSize,
          strokeWidth: strokeWidth ?? 2.r,
        ),
      _AppLoadingIndicatorType.pulse => SpinKitPulse(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.pulsingGrid => SpinKitPulsingGrid(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.pumpingHeart => SpinKitPumpingHeart(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.ring => SpinKitRing(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.ripple => SpinKitRipple(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.rotatingCircle => SpinKitRotatingCircle(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.rotatingPlain => SpinKitRotatingPlain(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.spinningCircle => SpinKitSpinningCircle(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.spinningLines => SpinKitSpinningLines(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.squareCircle => SpinKitSquareCircle(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.threeBounce => SpinKitThreeBounce(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.threeInOut => SpinKitThreeInOut(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.wanderingCubes => SpinKitWanderingCubes(
          color: resolvedColor,
          size: resolvedSize,
        ),
      _AppLoadingIndicatorType.wave => SpinKitWave(
          color: resolvedColor,
          size: resolvedSize,
          type: waveType ?? SpinKitWaveType.start,
        ),
      _AppLoadingIndicatorType.waveSpinner => SpinKitWaveSpinner(
          color: resolvedColor,
          size: resolvedSize,
        ),
    };
  }
}
