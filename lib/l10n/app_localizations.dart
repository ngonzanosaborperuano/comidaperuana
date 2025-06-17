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
    Locale('en'),
    Locale('es'),
  ];

  /// Welcome message on the home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to peruvian food'**
  String get welcome;

  /// Subtitle under the welcome message
  ///
  /// In en, this message translates to:
  /// **'The best of Peruvian gastronomy.'**
  String get descriptionWelcome;

  /// Button to start the app or onboarding
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Prompt for user to enter login credentials
  ///
  /// In en, this message translates to:
  /// **'Please enter your credentials.'**
  String get descriptionLogin;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Hint to enter password
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get enterPassword;

  /// Label for new user prompt
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get newUser;

  /// Title for access denied message
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get titleAccessDenied;

  /// Detailed message when access is denied
  ///
  /// In en, this message translates to:
  /// **'The data entered is incorrect or you do not have a registered user, please try again.'**
  String get textAccessDenied;

  /// Validation message for empty fields
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validateEmpty;

  /// Validation message for empty password
  ///
  /// In en, this message translates to:
  /// **'The password cannot be empty.'**
  String get emptyPassword;

  /// Password requirement: minimum length
  ///
  /// In en, this message translates to:
  /// **'* Must be at least 8 characters long.'**
  String get minEightCharacters;

  /// Password requirement: uppercase letter
  ///
  /// In en, this message translates to:
  /// **'* Must contain at least one capital letter'**
  String get labelUpper;

  /// Password requirement: lowercase letter
  ///
  /// In en, this message translates to:
  /// **'* Must contain at least one lowercase letter'**
  String get labelLower;

  /// Password requirement: number
  ///
  /// In en, this message translates to:
  /// **'* Must contain at least one number'**
  String get anyNumber;

  /// Password requirement: special character
  ///
  /// In en, this message translates to:
  /// **'* Must contain at least one special character.'**
  String get specialCharacter;

  /// Validation message for an invalid password
  ///
  /// In en, this message translates to:
  /// **'The password is invalid'**
  String get invalidPassword;

  /// Generic validation message
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validateList;

  /// Validation message for email format
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validateEmail;

  /// Prompt for user to register
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// Hint to enter email
  ///
  /// In en, this message translates to:
  /// **'Enter an email'**
  String get enterEmail;

  /// Label for repeat password field
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPassword;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Validation message for mismatched passwords
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match, please try again.'**
  String get validatePasswordText;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Accept button text
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Title for settings section
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// Log out button text
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for first name field
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Label for last name field
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Option to change the app's language
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get changeLanguage;

  /// Toggle option for dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// Status label for completed tasks
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Status label for pending tasks
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Label for task status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Label for title input
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Label or placeholder for recipe search
  ///
  /// In en, this message translates to:
  /// **'Search recipe'**
  String get searchRecipe;

  /// Prompt to search by title
  ///
  /// In en, this message translates to:
  /// **'Search by title'**
  String get searchTitle;

  /// Placeholder to enter a note title
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get insertTitle;

  /// Label for body or content of a note
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// Prompt to write a note
  ///
  /// In en, this message translates to:
  /// **'Write a note'**
  String get writeNote;

  /// Button to add a new note
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// Button to save content
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button to go back to previous screen
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Success message when a note is added
  ///
  /// In en, this message translates to:
  /// **'A note was created successfully.'**
  String get messageAddNote;

  /// Message shown when a note is deleted
  ///
  /// In en, this message translates to:
  /// **'The note was deleted: '**
  String get messageDeleteNote;

  /// Label or button to update a task
  ///
  /// In en, this message translates to:
  /// **'Update task'**
  String get updateTask;

  /// Success message when a note is updated
  ///
  /// In en, this message translates to:
  /// **'A note was updated successfully.'**
  String get messageUpdateNote;

  /// Message shown when no notes are found
  ///
  /// In en, this message translates to:
  /// **'There is no note'**
  String get noNote;

  /// Label for a list of pending items
  ///
  /// In en, this message translates to:
  /// **'List Pending'**
  String get listPending;

  /// Prompt for user to complete registration
  ///
  /// In en, this message translates to:
  /// **'Please complete the details and create an account'**
  String get completeInformation;

  /// Label for user input
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Alternative option label (e.g., login or register)
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Description for login with credentials
  ///
  /// In en, this message translates to:
  /// **'Username and password'**
  String get userPass;

  /// Label for full name input
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Hint to enter full name
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Fresh and Delicious Meals'**
  String get onboardingTitle1;

  /// First onboarding screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Discover healthy and tasty recipes every day.'**
  String get onboardingSubtitle1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Cook at Home'**
  String get onboardingTitle2;

  /// Second onboarding screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Find recipes to cook yourself.'**
  String get onboardingSubtitle2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Chef Recipes & Traditional Dishes'**
  String get onboardingTitle3;

  /// Third onboarding screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Explore chef-created recipes and traditional flavors from around the world.'**
  String get onboardingSubtitle3;

  /// Fourth onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cocinando!'**
  String get onboardingTitle4;

  /// Fourth onboarding screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Use AI to discover what to cook with the ingredients you already have at home.'**
  String get onboardingSubtitle4;

  /// Error message when auth method isn't supported
  ///
  /// In en, this message translates to:
  /// **'Sign-in method not supported'**
  String get unsupportedSignInMethod;

  /// Generic sign-in error message
  ///
  /// In en, this message translates to:
  /// **'Error during sign-in'**
  String get signInError;

  /// Message when user cancels Google sign-in
  ///
  /// In en, this message translates to:
  /// **'Google sign-in aborted by user'**
  String get googleSignInAborted;

  /// Message when Google sign-in returns no tokens
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed: No access token or ID token received.'**
  String get googleNoToken;

  /// Message for existing account with another auth method
  ///
  /// In en, this message translates to:
  /// **'The account already exists with a different credential.'**
  String get accountExistsWithDifferentCredential;

  /// Message when auth credential is invalid
  ///
  /// In en, this message translates to:
  /// **'The credential received is invalid.'**
  String get invalidCredential;

  /// Message when operation is disabled in Firebase
  ///
  /// In en, this message translates to:
  /// **'Operation not allowed. Please enable Google sign-in in Firebase console.'**
  String get operationNotAllowed;

  /// Message for disabled user account
  ///
  /// In en, this message translates to:
  /// **'User disabled. Please contact support.'**
  String get userDisabled;

  /// Message when user doesn't exist
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get userNotFound;

  /// Message for incorrect password
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided for that user.'**
  String get wrongPassword;

  /// Generic unknown error for Google sign-in
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred during Google sign-in'**
  String get unknownGoogleSignInError;

  /// Error during Google sign-in
  ///
  /// In en, this message translates to:
  /// **'An error occurred during Google sign-in'**
  String get googleSignInError;

  /// Message on successful login/registration
  ///
  /// In en, this message translates to:
  /// **'Login or registration successful'**
  String get authSuccess;

  /// Error during login or registration
  ///
  /// In en, this message translates to:
  /// **'Error during login or registration'**
  String get authError;

  /// Password does not meet strength requirements
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get weakPassword;

  /// Email already registered message
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get emailAlreadyInUse;

  /// Generic unknown error for email login
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred during email/password login'**
  String get unknownEmailLoginError;

  /// Error during email/password login
  ///
  /// In en, this message translates to:
  /// **'An error occurred during email/password login'**
  String get emailLoginError;

  /// It will be the title of an alert or modal.
  ///
  /// In en, this message translates to:
  /// **'Recover email'**
  String get recoverEmail;

  /// Instructions for account recovery using email.
  ///
  /// In en, this message translates to:
  /// **'To recover your account, enter an email address and then accept. Check your email. If you don\'t see it, check your other emails or spam folders.'**
  String get recoverAccountMessage;

  /// Title to recover password.
  ///
  /// In en, this message translates to:
  /// **'Recover password.'**
  String get recoverPassword;

  /// Send infomation
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Message shown when no user is found for the given email.
  ///
  /// In en, this message translates to:
  /// **'No user is registered with that email.'**
  String get errorUserNotFound;

  /// Message shown when the user is sending too many requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get errorTooManyRequests;

  /// Message shown when there's a network error.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your internet connection.'**
  String get errorNetwork;

  /// Generic message shown when an unknown error occurs.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get errorDefault;

  /// Message shown when the email format is invalid.
  ///
  /// In en, this message translates to:
  /// **'The email format is not valid.'**
  String get errorInvalidEmail;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
