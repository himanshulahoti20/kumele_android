import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive_data.dart';

class CreateEventLayout {
  const CreateEventLayout(this.responsive);

  final ResponsiveData responsive;

  EdgeInsets get phoneScreenPadding => EdgeInsets.fromLTRB(
      responsive.w(16), responsive.h(16), responsive.w(16), 0);

  EdgeInsets get phoneListPadding =>
      EdgeInsets.symmetric(horizontal: responsive.w(20));

  EdgeInsets get tabletOuterMargin => EdgeInsets.all(responsive.w(32));

  EdgeInsets get tabletHeaderPadding => EdgeInsets.all(responsive.w(24));

  EdgeInsets get tabletContentPadding => EdgeInsets.symmetric(
        vertical: responsive.h(40),
        horizontal: responsive.w(50),
      );

  double get sectionGap => responsive.h(22);

  double get fieldGap => responsive.h(16);

  double get labelGap => responsive.h(6);

  double get columnGap => responsive.w(38);

  double get borderRadius => responsive.w(10);

  double get headerFontSize => responsive.sp(21);

  double get labelFontSize => responsive.sp(13);

  double get imageUploadHeight => responsive.pick(
        mobilePortrait: responsive.h(100),
        tabletPortrait: responsive.h(250),
      );

  double get categoryItemSize => responsive.w(70);

  double get previewButtonHorizontalPadding => responsive.w(40);

  double get previewButtonVerticalPadding => responsive.h(15);
}
