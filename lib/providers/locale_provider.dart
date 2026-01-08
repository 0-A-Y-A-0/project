import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar'));

  bool get isArabic => state.languageCode == 'ar';

  void setEnglish() => state = const Locale('en');
  void setArabic() => state = const Locale('ar');

  void toggle() {
    state = isArabic ? const Locale('en') : const Locale('ar');
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
