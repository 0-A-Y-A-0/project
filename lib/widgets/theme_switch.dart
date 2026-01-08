import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final themeMode = ref.watch(ThemeNotifierProvider);
    final notifier = ref.read(ThemeNotifierProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;


    return Padding(
      padding: EdgeInsetsDirectional.only(top: 4, bottom: 4, start: screenWidth * 0.025),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: CupertinoSwitch(
          value: themeMode == ThemeMode.light,
          onChanged: (_) {
            notifier.switchMode();
          },

          thumbColor: cs.primary, // the circle color ... always the opposite of the theme

          activeTrackColor: cs.primary.withAlpha(100), // the bg color when we're on the light theme
        ),
      ),
    );
  }
}
