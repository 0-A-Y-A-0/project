import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
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
      title: 'Select start date',
      initialDate: _fromDate,
    );
    if (picked == null) return;

    setState(() => _fromDate = picked);
  }

  Future<void> _pickTo() async {
    final picked = await showListDatePicker(
      context: context,
      title: 'Select end date',
      initialDate: _toDate,
    );
    if (picked == null) return;

    setState(() => _toDate = picked);
  }

  Future<void> _sendBookingToBackend({
    required DateTime from,
    required DateTime to,
    required String cardNumber,
  }) async {
    // TODO: Replace with backend request.
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_isSubmitting) return;

    // ✅ ONLY check if they are filled
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both From and To dates.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final cardDigits = _cardNumberCtrl.text.replaceAll(' ', '');

    setState(() => _isSubmitting = true);
    try {
      await _sendBookingToBackend(
        from: _fromDate!,
        to: _toDate!,
        cardNumber: cardDigits,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking request submitted!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit booking: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fromText = _formatDate(_fromDate);
    final toText = _formatDate(_toDate);

    return SafeArea(
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
              child: const Text(
                'Note: Please double-check that the dates you enter are not highlighted as unavailable on the calendar page.',
              ),
            ),
            const SizedBox(height: 16),

            _DateField(
              label: 'From',
              valueText: fromText.isEmpty ? 'Select date' : fromText,
              onTap: _isSubmitting ? null : _pickFrom,
            ),
            const SizedBox(height: 12),
            _DateField(
              label: 'To',
              valueText: toText.isEmpty ? 'Select date' : toText,
              onTap: _isSubmitting ? null : _pickTo,
            ),

            const SizedBox(height: 24),

            Text(
              'Payment',
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
              decoration: const InputDecoration(
                labelText: 'Card number',
                hintText: '0000 0000 0000 0000',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final digits = (v ?? '').replaceAll(' ', '');
                if (digits.isEmpty) return 'Card number is required';
                if (digits.length < 16) return 'Card number must be 16 digits';
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
                  : const Text('Request booking'),
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
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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
  final years = List<int>.generate(11, (i) => DateTime.now().year + i); // current year .. +10
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
                            .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => year = v);
                        },
                        decoration: const InputDecoration(labelText: 'Year'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: month,
                        items: months
                            .map((m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(m.toString().padLeft(2, '0')),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => month = v);
                        },
                        decoration: const InputDecoration(labelText: 'Month'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: safeDay(),
                  items: days
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(d.toString().padLeft(2, '0')),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => day = v);
                  },
                  decoration: const InputDecoration(labelText: 'Day'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, current()),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}
