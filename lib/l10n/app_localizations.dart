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

  /// No description provided for @aiDbHub.
  ///
  /// In en, this message translates to:
  /// **'AI-DB Hub'**
  String get aiDbHub;

  /// No description provided for @yourIntelligentDatabaseManagementSolution.
  ///
  /// In en, this message translates to:
  /// **'Your intelligent database management solution'**
  String get yourIntelligentDatabaseManagementSolution;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @cloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get cloud;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @manageProjects.
  ///
  /// In en, this message translates to:
  /// **'Manage your database projects'**
  String get manageProjects;

  /// No description provided for @searchForProject.
  ///
  /// In en, this message translates to:
  /// **'Search for a project'**
  String get searchForProject;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @noProjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get noProjectsYet;

  /// No description provided for @createOneToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Create one to get started'**
  String get createOneToGetStarted;

  /// No description provided for @cloudManagement.
  ///
  /// In en, this message translates to:
  /// **'Cloud Management'**
  String get cloudManagement;

  /// No description provided for @manageCloudResources.
  ///
  /// In en, this message translates to:
  /// **'Manage your cloud resources and deployments'**
  String get manageCloudResources;

  /// No description provided for @noCloudProjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No cloud projects yet'**
  String get noCloudProjectsYet;

  /// No description provided for @aws.
  ///
  /// In en, this message translates to:
  /// **'AWS'**
  String get aws;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @firebase.
  ///
  /// In en, this message translates to:
  /// **'Firebase'**
  String get firebase;

  /// No description provided for @supabase.
  ///
  /// In en, this message translates to:
  /// **'Supabase'**
  String get supabase;

  /// No description provided for @mongoDbAtlas.
  ///
  /// In en, this message translates to:
  /// **'MongoDB Atlas'**
  String get mongoDbAtlas;

  /// No description provided for @manageAccountPreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage your account preferences and application settings'**
  String get manageAccountPreferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @customizeLookAndFeel.
  ///
  /// In en, this message translates to:
  /// **'Customize the look and feel of your application'**
  String get customizeLookAndFeel;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @switchBetweenThemes.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark themes'**
  String get switchBetweenThemes;

  /// No description provided for @themePreview.
  ///
  /// In en, this message translates to:
  /// **'Theme Preview'**
  String get themePreview;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @languageMode.
  ///
  /// In en, this message translates to:
  /// **'Language Mode'**
  String get languageMode;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgetPassword;

  /// No description provided for @yourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Your Language'**
  String get yourLanguage;

  /// No description provided for @backToProjects.
  ///
  /// In en, this message translates to:
  /// **'Back to Projects'**
  String get backToProjects;

  /// No description provided for @createNewProject.
  ///
  /// In en, this message translates to:
  /// **'Create a New Project'**
  String get createNewProject;

  /// No description provided for @setUpDatabaseProject.
  ///
  /// In en, this message translates to:
  /// **'Set up your database project in minutes'**
  String get setUpDatabaseProject;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @databaseType.
  ///
  /// In en, this message translates to:
  /// **'Database Type'**
  String get databaseType;

  /// No description provided for @cloudProvider.
  ///
  /// In en, this message translates to:
  /// **'Cloud Provider'**
  String get cloudProvider;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @updateInforamtions.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information and profile details'**
  String get updateInforamtions;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;
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
