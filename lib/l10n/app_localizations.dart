import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to peruvian food'**
  String get welcome;

  /// No description provided for @descriptionWelcome.
  ///
  /// In en, this message translates to:
  /// **'The best of Peruvian gastronomy.'**
  String get descriptionWelcome;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @descriptionLogin.
  ///
  /// In en, this message translates to:
  /// **'Please enter your credentials.'**
  String get descriptionLogin;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter an password'**
  String get enterPassword;

  /// No description provided for @newUser.
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get newUser;

  /// No description provided for @titleAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get titleAccessDenied;

  /// No description provided for @textAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'The data entered is incorrect or you do not have a registered user, please try again.'**
  String get textAccessDenied;

  /// No description provided for @validateEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validateEmpty;

  /// No description provided for @emptyPassword.
  ///
  /// In en, this message translates to:
  /// **'The password cannot be empty.'**
  String get emptyPassword;

  /// No description provided for @minEightCharacters.
  ///
  /// In en, this message translates to:
  /// **'* Must be at least 8 characters long.'**
  String get minEightCharacters;

  /// No description provided for @labelUpper.
  ///
  /// In en, this message translates to:
  /// **'* Must contain at least one capital letter'**
  String get labelUpper;

  /// No description provided for @labelLower.
  ///
  /// In en, this message translates to:
  /// **'* Must contain at least one lowercase letter'**
  String get labelLower;

  /// No description provided for @anyNumber.
  ///
  /// In en, this message translates to:
  /// **'* Must contain at least one number'**
  String get anyNumber;

  /// No description provided for @specialCharacter.
  ///
  /// In en, this message translates to:
  /// **'* Must contain at least one special character.'**
  String get specialCharacter;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is invalid'**
  String get invalidPassword;

  /// No description provided for @validateList.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validateList;

  /// No description provided for @validateEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validateEmail;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter an email'**
  String get enterEmail;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPassword;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @validatePasswordText.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match, please try again.'**
  String get validatePasswordText;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get changeLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @searchRecipe.
  ///
  /// In en, this message translates to:
  /// **'search recipe'**
  String get searchRecipe;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by title'**
  String get searchTitle;

  /// No description provided for @insertTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get insertTitle;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @writeNote.
  ///
  /// In en, this message translates to:
  /// **'write a note'**
  String get writeNote;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @messageAddNote.
  ///
  /// In en, this message translates to:
  /// **'A note was created successfully.'**
  String get messageAddNote;

  /// No description provided for @messageDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'The note was deleted: '**
  String get messageDeleteNote;

  /// No description provided for @updateTask.
  ///
  /// In en, this message translates to:
  /// **'Update task'**
  String get updateTask;

  /// No description provided for @messageUpdateNote.
  ///
  /// In en, this message translates to:
  /// **'A note was update successfully.'**
  String get messageUpdateNote;

  /// No description provided for @noNote.
  ///
  /// In en, this message translates to:
  /// **'There is no note'**
  String get noNote;

  /// No description provided for @listPending.
  ///
  /// In en, this message translates to:
  /// **'List Pending'**
  String get listPending;

  /// No description provided for @completeInformation.
  ///
  /// In en, this message translates to:
  /// **'Please complete the details and create an account'**
  String get completeInformation;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @userPass.
  ///
  /// In en, this message translates to:
  /// **'Username and password'**
  String get userPass;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter fullname'**
  String get enterFullName;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Fresh and Delicious Meals'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Discover healthy and tasty recipes every day.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Cook at Home'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Find recipes to cook yourself.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Chef Recipes & Traditional Dishes'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Explore chef-created recipes and traditional flavors from around the world.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cocinando!'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'Use AI to discover what to cook with the ingredients you already have at home.'**
  String get onboardingSubtitle4;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
