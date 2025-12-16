import 'package:flutter/material.dart';

class MyDateField extends StatelessWidget {
  const MyDateField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onTap,
    this.sizedBoxHeight,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onTap;
  final double? sizedBoxHeight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w200),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: cs.onSurface.withAlpha(170)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cs.onSurface, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cs.secondary, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_month, color: cs.onSurface),
          onPressed: onTap,
        ),
      ),
    );
  }
}
