import 'package:flutter/material.dart';

//calendar that only shows taken days takes a list of DateTimeRange from backend 
//broke my butt while coloring it without errors💀
class TakenDaysCalendar extends StatelessWidget {
  const TakenDaysCalendar({
    super.key,
    required this.takenRanges,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.takenDayBackground,
    this.takenDayForeground,
    this.availableDayForeground,
    this.todayBorderColor,
  });

  final List<DateTimeRange> takenRanges;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  //optional overrides(used them when debugging)
  final Color? takenDayBackground;
  final Color? takenDayForeground;
  final Color? availableDayForeground;
  final Color? todayBorderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    //calendar from to
    final today = _dateOnly(DateTime.now());
    final first = firstDate ?? DateTime(today.year - 1, 1, 1);
    final last = lastDate ?? DateTime(today.year + 2, 12, 31);

    //choosing an initial day that is NOT taken (CalendarDatePicker requires this i hated it it drank my soul)
    final desired = _clamp(_dateOnly(initialDate ?? today), first, last);
    final safeInitial = _firstSelectableDay(
      desired: desired,
      first: first,
      last: last,
      isSelectable: (d) => !_isTaken(d, takenRanges),
    );

    //if everything is taken in the whole range
    if (safeInitial == null) {
      return const Center(child: Text('No available dates'));
    }

    //colors
    final takenBg = takenDayBackground ?? cs.primary;
    final takenFg = takenDayForeground ?? cs.onPrimary;
    final availableFg = availableDayForeground ?? cs.onSurface;
    return Theme(
      data: theme.copyWith(
        datePickerTheme: DatePickerThemeData(
          //we color days by state:
          //disabled => taken
          //normal => available
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return takenFg;
            return availableFg;
          }),
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return takenBg;
            return Colors.transparent;
          }),
          todayBorder: BorderSide(width: 1.5, color: cs.onPrimary),
          todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return takenBg;
            return Colors.transparent;
          }),
          todayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return takenFg;
            return availableFg;
          }),
        ),
      ),
      child: CalendarDatePicker(
        firstDate: first,
        lastDate: last,
        initialDate: safeInitial, // date should be selectable
        selectableDayPredicate: (d) => !_isTaken(_dateOnly(d), takenRanges), //taken => disabled
        onDateChanged: (_) {}, //display-only
      ),
    );
  }

  // --- helpers ---

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime _clamp(DateTime d, DateTime min, DateTime max) {
    if (d.isBefore(min)) return min;
    if (d.isAfter(max)) return max;
    return d;
  }

  ///find a selectable day (try today, then forward)
  static DateTime? _firstSelectableDay({
    required DateTime desired,
    required DateTime first,
    required DateTime last,
    required bool Function(DateTime day) isSelectable,
  }) {
    if (isSelectable(desired)) return desired;

    // look forward
    for (var d = desired.add(const Duration(days: 1));
        !d.isAfter(last);
        d = d.add(const Duration(days: 1))) {
      final day = d;
      if (isSelectable(day)) return day;
    }
    return null;
  }

  //check if a day is inside any taken range
  static bool _isTaken(DateTime day, List<DateTimeRange> ranges) {
    final d = day;

    for (final r in ranges) {
      final start = r.start;
      final end = r.end;
      final bool inRange =
          (d.isAtSameMomentAs(start) || d.isAfter(start)) &&
          (d.isAtSameMomentAs(end) || d.isBefore(end));

      if (inRange) return true;
    }
    return false;
  }
}
