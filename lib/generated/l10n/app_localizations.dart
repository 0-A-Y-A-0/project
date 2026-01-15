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
  /// **'Less than 100\$'**
  String get priceOptionLessThan1000;

  /// No description provided for @priceOptionBetween1000And2500.
  ///
  /// In en, this message translates to:
  /// **'Between 100\$ and 250\$'**
  String get priceOptionBetween1000And2500;

  /// No description provided for @priceOptionMoreThan2500.
  ///
  /// In en, this message translates to:
  /// **'More than 250\$'**
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

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

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

  /// No description provided for @here.
  ///
  /// In en, this message translates to:
  /// **'here'**
  String get here;

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

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_title;

  /// No description provided for @register_firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get register_firstNameLabel;

  /// No description provided for @register_firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'first name'**
  String get register_firstNameHint;

  /// No description provided for @register_lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get register_lastNameLabel;

  /// No description provided for @register_lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'last name'**
  String get register_lastNameHint;

  /// No description provided for @register_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get register_continue;

  /// No description provided for @register_haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?\nsign in '**
  String get register_haveAccount;

  /// No description provided for @register2_birthdateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get register2_birthdateLabel;

  /// No description provided for @register2_birthdateHint.
  ///
  /// In en, this message translates to:
  /// **'dd/mm/yyyy'**
  String get register2_birthdateHint;

  /// No description provided for @register2_birthdateHelp.
  ///
  /// In en, this message translates to:
  /// **'Select birthdate'**
  String get register2_birthdateHelp;

  /// No description provided for @register2_profilePictureLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get register2_profilePictureLabel;

  /// No description provided for @register2_idPictureLabel.
  ///
  /// In en, this message translates to:
  /// **'ID picture'**
  String get register2_idPictureLabel;

  /// No description provided for @register2_pickCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get register2_pickCamera;

  /// No description provided for @register2_pickGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get register2_pickGallery;

  /// No description provided for @register_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_button;

  /// No description provided for @addApt_title.
  ///
  /// In en, this message translates to:
  /// **'Add Apartment'**
  String get addApt_title;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @addApt_added.
  ///
  /// In en, this message translates to:
  /// **'Apartment added'**
  String get addApt_added;

  /// No description provided for @addApt_photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get addApt_photos;

  /// No description provided for @common_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get common_gallery;

  /// No description provided for @common_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get common_camera;

  /// No description provided for @addApt_addUpTo5Images.
  ///
  /// In en, this message translates to:
  /// **'Add up to 5 images'**
  String get addApt_addUpTo5Images;

  /// No description provided for @addApt_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addApt_address;

  /// No description provided for @addApt_amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get addApt_amenities;

  /// No description provided for @field_governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get field_governorate;

  /// No description provided for @field_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get field_city;

  /// No description provided for @field_street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get field_street;

  /// No description provided for @field_buildingNumber.
  ///
  /// In en, this message translates to:
  /// **'Building number'**
  String get field_buildingNumber;

  /// No description provided for @field_floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get field_floor;

  /// No description provided for @field_apartmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Apartment number'**
  String get field_apartmentNumber;

  /// No description provided for @field_bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get field_bedrooms;

  /// No description provided for @field_bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get field_bathrooms;

  /// No description provided for @field_area.
  ///
  /// In en, this message translates to:
  /// **'Area (m²)'**
  String get field_area;

  /// No description provided for @field_rentPricePerNight.
  ///
  /// In en, this message translates to:
  /// **'Rent price per night'**
  String get field_rentPricePerNight;

  /// No description provided for @field_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get field_description;

  /// No description provided for @hint_selectGovernorateFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a governorate first'**
  String get hint_selectGovernorateFirst;

  /// No description provided for @error_selectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Select a governorate'**
  String get error_selectGovernorate;

  /// No description provided for @error_selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select a city'**
  String get error_selectCity;

  /// No description provided for @error_streetRequired.
  ///
  /// In en, this message translates to:
  /// **'Street is required'**
  String get error_streetRequired;

  /// No description provided for @error_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get error_required;

  /// No description provided for @error_enterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter number'**
  String get error_enterNumber;

  /// No description provided for @error_mustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Must be > 0'**
  String get error_mustBeGreaterThanZero;

  /// No description provided for @error_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get error_select;

  /// No description provided for @error_descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description required'**
  String get error_descriptionRequired;

  /// No description provided for @profile_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_editProfile;

  /// No description provided for @profile_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get profile_history;

  /// No description provided for @profile_myApartments.
  ///
  /// In en, this message translates to:
  /// **'My apartments'**
  String get profile_myApartments;

  /// No description provided for @profile_favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get profile_favorites;

  /// No description provided for @profile_rentalHistory.
  ///
  /// In en, this message translates to:
  /// **'Rental history'**
  String get profile_rentalHistory;

  /// No description provided for @profile_app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get profile_app;

  /// No description provided for @profile_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profile_theme;

  /// No description provided for @profile_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_language;

  /// No description provided for @profile_logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profile_logout;

  /// No description provided for @profile_help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get profile_help;

  /// No description provided for @profile_sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get profile_sendFeedback;

  /// No description provided for @profile_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profile_privacyPolicy;

  /// No description provided for @profile_aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get profile_aboutUs;

  /// No description provided for @profile_version.
  ///
  /// In en, this message translates to:
  /// **'my app v2.3.5 (12548)'**
  String get profile_version;

  /// No description provided for @apartment_building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get apartment_building;

  /// No description provided for @apartment_apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartment_apartment;

  /// No description provided for @apartment_street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get apartment_street;

  /// No description provided for @apartment_perNight.
  ///
  /// In en, this message translates to:
  /// **'per night'**
  String get apartment_perNight;

  /// No description provided for @apartment_floorNumber.
  ///
  /// In en, this message translates to:
  /// **'Floor {floor}'**
  String apartment_floorNumber(Object floor);

  /// No description provided for @apartment_descriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get apartment_descriptionTitle;

  /// No description provided for @apartment_aboutOwner.
  ///
  /// In en, this message translates to:
  /// **'About Owner'**
  String get apartment_aboutOwner;

  /// No description provided for @rating_addReviewOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a review (optional)'**
  String get rating_addReviewOptional;

  /// No description provided for @rating_postReview.
  ///
  /// In en, this message translates to:
  /// **'Post your review'**
  String get rating_postReview;

  /// No description provided for @rating_noWrittenReview.
  ///
  /// In en, this message translates to:
  /// **'No written review'**
  String get rating_noWrittenReview;

  /// No description provided for @booking_note.
  ///
  /// In en, this message translates to:
  /// **'Note: Please double-check that the dates you enter are not highlighted as unavailable on the calendar page.'**
  String get booking_note;

  /// No description provided for @booking_from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get booking_from;

  /// No description provided for @booking_to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get booking_to;

  /// No description provided for @booking_selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get booking_selectDate;

  /// No description provided for @booking_payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get booking_payment;

  /// No description provided for @booking_cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get booking_cardNumber;

  /// No description provided for @booking_cardHint.
  ///
  /// In en, this message translates to:
  /// **'0000 0000 0000 0000'**
  String get booking_cardHint;

  /// No description provided for @booking_cardRequired.
  ///
  /// In en, this message translates to:
  /// **'Card number is required'**
  String get booking_cardRequired;

  /// No description provided for @booking_cardMustBe16.
  ///
  /// In en, this message translates to:
  /// **'Card number must be 16 digits'**
  String get booking_cardMustBe16;

  /// No description provided for @booking_requestBooking.
  ///
  /// In en, this message translates to:
  /// **'Request booking'**
  String get booking_requestBooking;

  /// No description provided for @booking_selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get booking_selectStartDate;

  /// No description provided for @booking_selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get booking_selectEndDate;

  /// No description provided for @booking_snack_selectBothDates.
  ///
  /// In en, this message translates to:
  /// **'Please select both From and To dates.'**
  String get booking_snack_selectBothDates;

  /// No description provided for @booking_snack_submitted.
  ///
  /// In en, this message translates to:
  /// **'Booking request submitted!'**
  String get booking_snack_submitted;

  /// No description provided for @booking_snack_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit booking: '**
  String get booking_snack_failed;

  /// No description provided for @booking_snack_fromAfterTo.
  ///
  /// In en, this message translates to:
  /// **'Start date can’t be after end date.'**
  String get booking_snack_fromAfterTo;

  /// No description provided for @datePicker_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get datePicker_year;

  /// No description provided for @datePicker_month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get datePicker_month;

  /// No description provided for @datePicker_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get datePicker_day;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'apartment'**
  String get apartment;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'owner'**
  String get owner;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'tenant'**
  String get tenant;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'status'**
  String get status;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get pending;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'accepted'**
  String get accepted;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'ongoing'**
  String get ongoing;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'passed'**
  String get passed;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get rejected;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'canceled'**
  String get canceled;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'edit'**
  String get edit;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'reject'**
  String get reject;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @editBookingDates.
  ///
  /// In en, this message translates to:
  /// **'Edit booking dates'**
  String get editBookingDates;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @fromMustBeBeforeTo.
  ///
  /// In en, this message translates to:
  /// **'From must be before To.'**
  String get fromMustBeBeforeTo;

  /// No description provided for @activeRentalTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Rentals'**
  String get activeRentalTitle;

  /// No description provided for @basedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOn;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'review'**
  String get review;

  /// No description provided for @youCantRent.
  ///
  /// In en, this message translates to:
  /// **'You can\'t rate an apartment that you haven\'t rented before'**
  String get youCantRent;
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
