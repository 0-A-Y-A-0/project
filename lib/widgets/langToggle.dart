import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/locale_provider.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final locale = ref.watch(localeProvider);
    final isAr = locale.languageCode == 'ar';

    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).toggle(),
      child: Container(
        margin: EdgeInsets.all(3),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: cs.onPrimary.withAlpha(80),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.primary.withAlpha(90)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Chip(
              text: 'EN',
              selected: !isAr,
              cs: cs,
            ),
            const SizedBox(width: 6),
            _Chip(
              text: 'AR',
              selected: isAr,
              cs: cs,
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.text,
    required this.selected,
    required this.cs,
  });

  final String text;
  final bool selected;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? cs.primary.withAlpha(30) : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? cs.primary : cs.primary.withAlpha(130),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
