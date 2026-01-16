import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/locale_provider.dart';
import 'package:project/providers/theme_provider.dart';
import 'package:project/screens/main_screen.dart';
import 'package:project/screens/register_first_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/components/theme.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/services/local_notification.dart';
import 'package:project/services/providerContainer.dart';
import 'package:project/services/push_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await LocalNotificationService.init();
  await PushNotificationsService.init();

  // AYA
  // cOOS0pLsTjGTiGkbHgbS4K:APA91bEIEO1Z9TfOwfPbQpPapgX4vRKCubVsPe0rxk0lWU1m3nTz4uauw_vomHLQbVII-vw562SRMLSy9VY51fjDUGM4h-P_uWPMt-BrksUHEJnDln_9I9U
  // SARAH
  // fyG79EruRyS8t5lQZIKR5d:APA91bG8OFxB5qXfX18zARRQPUGTK8bTBFC65CygxY9bNnyxPCZPdysJm6pwpCKHmyoa0G8bkM3aztfAf9y2SmtE7tTkN8XOkhXLtp2zpeymF-OON5RMSS4

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: watashiWaSta(),
    ),
  );
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

       localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // supportedLocales: const [
      //   Locale('en'),
      //   Locale('ar'),
      // ],
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      
       // consuming the theme provider let's go!
      routes: {
        'SignInPage' : (context) => SignInScreen(),
        'MainScreen' : (context) => MainScreen(),
        'RegisterFirstPage' : (context) => RegisterFirstScreen(),
      },
      initialRoute: 'RegisterFirstPage',
    );
  }
}


