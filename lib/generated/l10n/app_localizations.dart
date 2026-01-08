import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'My App'**
  String get appName;

  /// No description provided for @ourApp.
  ///
  /// In en, this message translates to:
  /// **'Our App'**
  String get ourApp;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @selectGovernorateFirst.
  ///
  /// In en, this message translates to:
  /// **'Select governorate first'**
  String get selectGovernorateFirst;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get app;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @myApartments.
  ///
  /// In en, this message translates to:
  /// **'My apartments'**
  String get myApartments;

  /// No description provided for @rentalHistory.
  ///
  /// In en, this message translates to:
  /// **'Rental history'**
  String get rentalHistory;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @priceOptionLessThan1000.
  ///
  /// In en, this message translates to:
  /// **'Less than 1000\$'**
  String get priceOptionLessThan1000;

  /// No description provided for @priceOptionBetween1000And2500.
  ///
  /// In en, this message translates to:
  /// **'Between 1000\$ and 2500\$'**
  String get priceOptionBetween1000And2500;

  /// No description provided for @priceOptionMoreThan2500.
  ///
  /// In en, this message translates to:
  /// **'More than 2500\$'**
  String get priceOptionMoreThan2500;

  /// No description provided for @ratingOptionLessThan3.
  ///
  /// In en, this message translates to:
  /// **'Less than ☆☆☆'**
  String get ratingOptionLessThan3;

  /// No description provided for @ratingOptionBetween2And4.
  ///
  /// In en, this message translates to:
  /// **'Between ☆☆ and ☆☆☆☆'**
  String get ratingOptionBetween2And4;

  /// No description provided for @gov_damascus.
  ///
  /// In en, this message translates to:
  /// **'Damascus'**
  String get gov_damascus;

  /// No description provided for @gov_rifDamascus.
  ///
  /// In en, this message translates to:
  /// **'Rif Damascus'**
  String get gov_rifDamascus;

  /// No description provided for @gov_aleppo.
  ///
  /// In en, this message translates to:
  /// **'Aleppo'**
  String get gov_aleppo;

  /// No description provided for @gov_homs.
  ///
  /// In en, this message translates to:
  /// **'Homs'**
  String get gov_homs;

  /// No description provided for @gov_hama.
  ///
  /// In en, this message translates to:
  /// **'Hama'**
  String get gov_hama;

  /// No description provided for @gov_latakia.
  ///
  /// In en, this message translates to:
  /// **'Latakia'**
  String get gov_latakia;

  /// No description provided for @gov_tartous.
  ///
  /// In en, this message translates to:
  /// **'Tartous'**
  String get gov_tartous;

  /// No description provided for @gov_idlib.
  ///
  /// In en, this message translates to:
  /// **'Idlib'**
  String get gov_idlib;

  /// No description provided for @gov_daraa.
  ///
  /// In en, this message translates to:
  /// **'Daraa'**
  String get gov_daraa;

  /// No description provided for @gov_asSuwayda.
  ///
  /// In en, this message translates to:
  /// **'As Suwayda'**
  String get gov_asSuwayda;

  /// No description provided for @gov_quneitra.
  ///
  /// In en, this message translates to:
  /// **'Quneitra'**
  String get gov_quneitra;

  /// No description provided for @gov_deirEzzor.
  ///
  /// In en, this message translates to:
  /// **'Deir Ezzor'**
  String get gov_deirEzzor;

  /// No description provided for @gov_alHasakah.
  ///
  /// In en, this message translates to:
  /// **'Al Hasakah'**
  String get gov_alHasakah;

  /// No description provided for @gov_raqqa.
  ///
  /// In en, this message translates to:
  /// **'Raqqa'**
  String get gov_raqqa;

  /// No description provided for @signin_title.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin_title;

  /// No description provided for @signin_phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get signin_phoneLabel;

  /// No description provided for @signin_passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signin_passwordLabel;

  /// No description provided for @signin_button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signin_button;

  /// No description provided for @signin_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get signin_loading;

  /// No description provided for @signin_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get signin_forgotPassword;

  /// No description provided for @signin_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?\nregister  '**
  String get signin_noAccount;

  /// No description provided for @signin_here.
  ///
  /// In en, this message translates to:
  /// **'here'**
  String get signin_here;

  /// No description provided for @auth_errorTryLater.
  ///
  /// In en, this message translates to:
  /// **'ERROR !!! Try again later'**
  String get auth_errorTryLater;

  /// No description provided for @auth_waitingReview.
  ///
  /// In en, this message translates to:
  /// **'Your account has been saved successfully, wait till the admin review it then sign in'**
  String get auth_waitingReview;

  /// No description provided for @auth_adminAccepted.
  ///
  /// In en, this message translates to:
  /// **'The admin accepted your account! you can sign in'**
  String get auth_adminAccepted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
