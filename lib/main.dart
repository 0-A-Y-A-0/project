import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/locale_provider.dart';
import 'package:project/providers/theme_provider.dart';
import 'package:project/screens/main_screen.dart';
import 'package:project/screens/register_first_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/components/theme.dart';

void main() {
  runApp(const ProviderScope(child: watashiWaSta()));
}

class watashiWaSta extends ConsumerWidget {
  const watashiWaSta({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeNotifierProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: theme,
      
       locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
       // consuming the theme provider let's go!
      routes: {
        'SignInPage' : (context) => SignInScreen(),
        'MainScreen' : (context) => MainScreen(),
        'RegisterFirstPage' : (context) => RegisterFirstScreen(),
      },
      initialRoute: 'MainScreen',
    );
  }
}


