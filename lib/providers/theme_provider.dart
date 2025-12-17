import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<ThemeMode>{
  @override
  ThemeMode build() {
    // this is the default value ... we can change it for texting till we have a toggle
    return ThemeMode.dark ;
  }

  void switchMode() {
    // to switch between modes ... for later use
    state = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}

// this is the cool provider
final ThemeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
        () { return ThemeNotifier(); }
);