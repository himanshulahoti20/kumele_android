import 'package:kuemele/core/responsive/responsive_data.dart';

/// Responsive sizing tokens shared across event card variants.
class EventCardLayout {
  const EventCardLayout(this.responsive);

  final ResponsiveData responsive;

  double get borderRadius => responsive.w(17.41);

  double get contentPaddingH => responsive.w(10);

  double get contentPaddingV => responsive.h(8);

  double get infoIconSize => responsive.w(14);

  double get infoRowSpacing => responsive.w(8);

  double get infoRowRunSpacing => responsive.h(4);

  double get startTimeClockSize => responsive.w(14);

  double get categoryTagTop => responsive.h(15);

  double get categoryTagRight => responsive.w(10);
}
