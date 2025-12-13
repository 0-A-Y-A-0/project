import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/sign_in_screen.dart';
import 'package:project/components/theme.dart';

void main() {
  runApp(const ProviderScope(child: watashiWaSta()));
}

class watashiWaSta extends StatelessWidget {
  const watashiWaSta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark, 
      home: const SignInScreen(),
    );
  }
}

