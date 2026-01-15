import 'package:flutter/material.dart';
import 'package:project/generated/l10n/app_localizations.dart';

Future<DateTimeRange?> showEditBookingDatesDialog(
  BuildContext context, {
  DateTime? initialFrom,
  DateTime? initialTo,
  DateTime? firstDate,
  DateTime? lastDate,
  
}) async {
  final screenHeight = MediaQuery.of(context).size.height;
  final cs = ColorScheme.of(context);
  final t = AppLocalizations.of(context)!;
  DateTime? from = initialFrom;
  DateTime? to = initialTo;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<DateTime?> _pickDate({
    required DateTime? initial,
  }) {
    final now = _dateOnly(DateTime.now());
    final fd = _dateOnly(firstDate ?? now.subtract(const Duration(days: 365)));
    final ld = _dateOnly(lastDate ?? now.add(const Duration(days: 365 * 2)));
    
    //keep initial inside bounds(so it doesn't give wierd errors)
    final safeInitial = _dateOnly(initial ?? now);
    final initialForPicker = safeInitial.isBefore(fd)
        ? fd
        : safeInitial.isAfter(ld)
            ? ld
            : safeInitial;

    return showDatePicker(
      context: context,
      firstDate: fd,
      lastDate: ld,
      initialDate: initialForPicker,
    );
  }

  return showDialog<DateTimeRange?>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          String _label(DateTime? d) =>
              d == null ? t.select : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

          final canConfirm = from != null && to != null && !from!.isAfter(to!);

          return AlertDialog(
            title: Text(t.editBookingDates),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                         _DateField(
                  label: t.from,
                  valueText: _label(from),
                  onTap: () async {
                    final picked = await _pickDate(initial: from);
                    if (picked == null) return;
                    setState(() {
                      from = _dateOnly(picked);
                    });
                  },
                ),
                const SizedBox(height: 12),
                _DateField(
                  label: t.to,
                  valueText: _label(to),
                  onTap: () async {
                    final picked = await _pickDate(initial: to);
                    if (picked == null) return;
                    setState(() {
                      to = _dateOnly(picked);
                    });
                  },
                ),
            
                SizedBox(height: screenHeight * 0.02),
                if (from != null && to != null && from!.isAfter(to!))
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      t.fromMustBeBeforeTo,
                      style: TextStyle(color: cs.primary),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: Text(t.cancel),
              ),
              FilledButton(
                onPressed: canConfirm
                    ? () => Navigator.pop(
                          ctx,
                          DateTimeRange(start: from!, end: to!),
                        )
                    : null,
                child: Text(t.confirm),
              ),
            ],
          );
        },
      );
    },
  );
}
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.valueText,
    required this.onTap,
  });

  final String label;
  final String valueText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
        ),
        child: Text(valueText),
      ),
    );
  }
}