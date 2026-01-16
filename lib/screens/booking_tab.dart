import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/providers/activeRentalsProvider.dart';

import '../providers/addRental.dart';
import '../providers/apartmentDetailsProvider.dart';
import '../providers/user_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _fromDate;
  DateTime? _toDate;

  final _cardNumberCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickFrom() async {
    final picked = await showListDatePicker(
      context: context,
      title: AppLocalizations.of(context)!.booking_selectStartDate,
      initialDate: _fromDate,
    );
    if (picked == null) return;

    setState(() => _fromDate = picked);
  }

  Future<void> _pickTo() async {
    final picked = await showListDatePicker(
      context: context,
      title: AppLocalizations.of(context)!.booking_selectEndDate,
      initialDate: _toDate,
    );
    if (picked == null) return;

    setState(() => _toDate = picked);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_isSubmitting) return;

    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.booking_snack_selectBothDates,
          ),
        ),
      );
      return;
    }

    final from = DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day);
    final to = DateTime(_toDate!.year, _toDate!.month, _toDate!.day);

    if (from.isAfter(to)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.booking_snack_fromAfterTo,
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final cardDigits = _cardNumberCtrl.text.replaceAll(' ', '');

    setState(() => _isSubmitting = true);
    try {
      final apartment = ref.read(ApartmentDetailsProvider).value!;

      final formData = FormData.fromMap({
        'apartment_id': apartment.id.toString(),
        'rental_start_date': _formatDate(_fromDate!),
        'rental_end_date': _formatDate(_toDate!),
        'card_number': cardDigits,
        // cardNumber ignored by backend
      });

      print(apartment.id.toString());
      print(_formatDate(_fromDate!));
      print(_formatDate(_toDate!));

      print("submitting") ;
      await ref.read(AddRentalProvider(formData).future);

      print("done------------------------------------------------------------------");

      if (!mounted) return;

      setState(() {
        _fromDate = null;
        _toDate = null;
        _cardNumberCtrl.clear();
      });
      _formKey.currentState?.reset();

      // refreshing the rentals tab
      ref.invalidate(ActiveRentalsProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.booking_snack_submitted),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fromText = _formatDate(_fromDate);
    final toText = _formatDate(_toDate);
    final AppLocalizations t = AppLocalizations.of(context)!;

    final apartment = ref.watch(ApartmentDetailsProvider);
    final user = ref.watch(UserProvider);

    return apartment.value!.owner_id == user!.id
    ? Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "You can't book your own apartment man \n(￣(工)￣)",
        textAlign: TextAlign.center,
      ),
    )
    : SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(t.booking_note),
            ),
            const SizedBox(height: 16),

            _DateField(
              label: t.booking_from,
              valueText: fromText.isEmpty ? t.booking_selectDate : fromText,
              onTap: _isSubmitting ? null : _pickFrom,
            ),
            const SizedBox(height: 12),
            _DateField(
              label: t.booking_to,
              valueText: toText.isEmpty ? t.booking_selectDate : toText,
              onTap: _isSubmitting ? null : _pickTo,
            ),

            const SizedBox(height: 24),

            Text(
              t.booking_payment,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            TextFormField(
              maxLength: 19,
              controller: _cardNumberCtrl,
              enabled: !_isSubmitting,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              decoration: InputDecoration(
                labelText: t.booking_cardNumber,
                hintText: '0000 0000 0000 0000',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final digits = (v ?? '').replaceAll(' ', '');
                if (digits.isEmpty) return t.booking_cardRequired;
                if (digits.length < 16) return t.booking_cardMustBe16;
                return null;
              },
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.booking_requestBooking),
            ),
          ],
        ),
      ),
    );
  }
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

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\s+'), '');
    final buf = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buf.write(digits[i]);
      final isEnd = i == digits.length - 1;
      if (!isEnd && (i + 1) % 4 == 0) buf.write(' ');
    }

    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

Future<DateTime?> showListDatePicker({
  required BuildContext context,
  required String title,
  DateTime? initialDate,
}) async {
  final init = initialDate ?? DateTime.now();

  int year = init.year;
  int month = init.month;
  int day = init.day;

  int daysInMonth(int y, int m) {
    final nextMonth = (m == 12) ? DateTime(y + 1, 1, 1) : DateTime(y, m + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  // Simple year range (purely for UI)
  final years = List<int>.generate(
    11,
    (i) => DateTime.now().year + i,
  ); // current year .. +10
  final months = List<int>.generate(12, (i) => i + 1);

  int safeDay() {
    final maxDay = daysInMonth(year, month);
    if (day > maxDay) day = maxDay;
    if (day < 1) day = 1;
    return day;
  }

  DateTime current() => DateTime(year, month, safeDay());

  return showDialog<DateTime>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          final maxDay = daysInMonth(year, month);
          final days = List<int>.generate(maxDay, (i) => i + 1);
          final AppLocalizations t = AppLocalizations.of(context)!;

          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: year,
                        items: years
                            .map(
                              (y) => DropdownMenuItem(
                                value: y,
                                child: Text(y.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => year = v);
                        },
                        decoration: InputDecoration(
                          labelText: t.datePicker_year,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: month,
                        items: months
                            .map(
                              (m) => DropdownMenuItem(
                                value: m,
                                child: Text(m.toString().padLeft(2, '0')),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => month = v);
                        },
                        decoration: InputDecoration(
                          labelText: t.datePicker_month,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: safeDay(),
                  items: days
                      .map(
                        (d) => DropdownMenuItem(
                          value: d,
                          child: Text(d.toString().padLeft(2, '0')),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => day = v);
                  },
                  decoration: InputDecoration(labelText: t.datePicker_day),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, current()),
                child: Text(AppLocalizations.of(context)!.common_ok),
              ),
            ],
          );
        },
      );
    },
  );
}
