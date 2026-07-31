import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ru'),
    Locale('tk')
  ];

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @aLongTimeAgo.
  ///
  /// In en, this message translates to:
  /// **'A long time ago'**
  String get aLongTimeAgo;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncome;

  /// No description provided for @addFriendsFromContact.
  ///
  /// In en, this message translates to:
  /// **'Let\'s add friends from your contacts'**
  String get addFriendsFromContact;

  /// No description provided for @addNotification.
  ///
  /// In en, this message translates to:
  /// **'Add notification'**
  String get addNotification;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @alreadyExposed.
  ///
  /// In en, this message translates to:
  /// **'Not recommended'**
  String get alreadyExposed;

  /// No description provided for @areSureToQuitBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to login to your account to continue your progress.'**
  String get areSureToQuitBody;

  /// No description provided for @areSureToQuitTitle.
  ///
  /// In en, this message translates to:
  /// **'Are your sure to logout?'**
  String get areSureToQuitTitle;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @audioMessage.
  ///
  /// In en, this message translates to:
  /// **'Audio message'**
  String get audioMessage;

  /// No description provided for @authorization.
  ///
  /// In en, this message translates to:
  /// **'Authorization'**
  String get authorization;

  /// No description provided for @avatarWasUploaded.
  ///
  /// In en, this message translates to:
  /// **'A new avatar has been uploaded successfully'**
  String get avatarWasUploaded;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @backUp.
  ///
  /// In en, this message translates to:
  /// **'Back up'**
  String get backUp;

  /// No description provided for @backend_code.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get backend_code;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'I am ...'**
  String get bio;

  /// No description provided for @bioBody.
  ///
  /// In en, this message translates to:
  /// **'What makes you special? Don\'t think too much, just have fun with it.'**
  String get bioBody;

  /// No description provided for @bioTitle.
  ///
  /// In en, this message translates to:
  /// **'Write about yourself'**
  String get bioTitle;

  /// No description provided for @birthdayBody.
  ///
  /// In en, this message translates to:
  /// **'Use your birthday even if the account is for a business, pet, or anything else. No one will see it unless you choose to share it.'**
  String get birthdayBody;

  /// No description provided for @birthdayHint.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get birthdayHint;

  /// No description provided for @birthdayTitle.
  ///
  /// In en, this message translates to:
  /// **'When is your birthday?'**
  String get birthdayTitle;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @candleChart.
  ///
  /// In en, this message translates to:
  /// **'Candle chart'**
  String get candleChart;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @changeBanner.
  ///
  /// In en, this message translates to:
  /// **'Change banner'**
  String get changeBanner;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changeImage;

  /// No description provided for @charts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get charts;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get choosePhoto;

  /// No description provided for @chooseProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo'**
  String get chooseProfilePhoto;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @confirmationCode.
  ///
  /// In en, this message translates to:
  /// **'Confirmation code'**
  String get confirmationCode;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get connecting;

  /// No description provided for @connectionErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Connection can\'t be established'**
  String get connectionErrorOccurred;

  /// No description provided for @contactPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You have not given permission for reading contacts, press again to retry'**
  String get contactPermissionDenied;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @continueT.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueT;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Text was copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @counter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counter;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Currency symbol'**
  String get currencySymbol;

  /// No description provided for @currencyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. \$, €, TMT, m'**
  String get currencyHint;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @enableReminders.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get enableReminders;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get maybeLater;

  /// No description provided for @onbWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Gapjyk'**
  String get onbWelcomeTitle;

  /// No description provided for @onbWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Track your income and expenses with ease. Start by choosing your language.'**
  String get onbWelcomeBody;

  /// No description provided for @onbCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your currency'**
  String get onbCurrencyTitle;

  /// No description provided for @onbCurrencyBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the symbol shown next to every amount. You can change it anytime in Settings.'**
  String get onbCurrencyBody;

  /// No description provided for @onbAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add income & expenses'**
  String get onbAddTitle;

  /// No description provided for @onbAddBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to record income and the − button for an expense, then enter an amount and pick a category.'**
  String get onbAddBody;

  /// No description provided for @onbCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Organize with categories'**
  String get onbCategoriesTitle;

  /// No description provided for @onbCategoriesBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ve added a starter set of categories. Create, edit, or remove them anytime from Settings.'**
  String get onbCategoriesBody;

  /// No description provided for @onbRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on track'**
  String get onbRemindersTitle;

  /// No description provided for @onbRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders so you never forget to record your spending. You can manage them later.'**
  String get onbRemindersBody;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Partner name
  ///
  /// In en, this message translates to:
  /// **'Also delete for {name}'**
  String deleteForAll(String name);

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get deleteMessage;

  /// No description provided for @deleteMessageContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get deleteMessageContent;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete'**
  String get deleteTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @emailShort.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailShort;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// A message for showing for need to OTP code for number
  ///
  /// In en, this message translates to:
  /// **'Enter the 5-digit code sent to the \n{number}'**
  String enterConfirmationCode(String number);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please, try again.'**
  String get errorOccurred;

  /// No description provided for @fileMessageType.
  ///
  /// In en, this message translates to:
  /// **'File message'**
  String get fileMessageType;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgetPassword;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @haveNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get haveNotRegistered;

  /// No description provided for @haveRegistered.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveRegistered;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @imageMessage.
  ///
  /// In en, this message translates to:
  /// **'Image message'**
  String get imageMessage;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @inputAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to all the terms and conditions'**
  String get inputAgreeTerms;

  /// No description provided for @inputEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get inputEmail;

  /// No description provided for @inputEmailInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get inputEmailInstruction;

  /// No description provided for @inputEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get inputEmailInvalid;

  /// No description provided for @inputEmptyInvalid.
  ///
  /// In en, this message translates to:
  /// **'The field must not be empty'**
  String get inputEmptyInvalid;

  /// No description provided for @inputFamilyName.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get inputFamilyName;

  /// No description provided for @inputFamilyNameInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your Family name'**
  String get inputFamilyNameInstruction;

  /// No description provided for @inputName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inputName;

  /// No description provided for @inputNameInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get inputNameInstruction;

  /// No description provided for @inputNick.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get inputNick;

  /// No description provided for @inputNickInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your nickname'**
  String get inputNickInstruction;

  /// No description provided for @inputPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get inputPhone;

  /// No description provided for @inputPhoneInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get inputPhoneInstruction;

  /// No description provided for @inputPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone format'**
  String get inputPhoneInvalid;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get label;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationMessage.
  ///
  /// In en, this message translates to:
  /// **'Location message'**
  String get locationMessage;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number and password you used to register'**
  String get loginBody;

  /// No description provided for @logoutProfile.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutProfile;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get moreDetails;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @nameBody.
  ///
  /// In en, this message translates to:
  /// **'You can always change your name later'**
  String get nameBody;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name and surname'**
  String get nameHint;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your name?'**
  String get nameTitle;

  /// No description provided for @nickBody.
  ///
  /// In en, this message translates to:
  /// **'For unique way to find your account, you can always change this later'**
  String get nickBody;

  /// No description provided for @nickHint.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get nickHint;

  /// No description provided for @nickTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a unique username'**
  String get nickTitle;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @notificationBody.
  ///
  /// In en, this message translates to:
  /// **'Notification body'**
  String get notificationBody;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification title'**
  String get notificationTitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get online;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get pass;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation'**
  String get passwordConfirmation;

  /// No description provided for @passwordConfirmationInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your password confirmation'**
  String get passwordConfirmationInstruction;

  /// No description provided for @passwordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordInstruction;

  /// No description provided for @passwordNotSame.
  ///
  /// In en, this message translates to:
  /// **'Password and it\'s confirmation must be same and don\'t forget your password'**
  String get passwordNotSame;

  /// No description provided for @passwordTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get passwordTitle;

  /// No description provided for @phoneShort.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneShort;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @photoBody.
  ///
  /// In en, this message translates to:
  /// **'Add a photo so your friends can recognize you'**
  String get photoBody;

  /// No description provided for @photoTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get photoTitle;

  /// No description provided for @poster.
  ///
  /// In en, this message translates to:
  /// **'Poster'**
  String get poster;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileWasUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your profile information has been updated successfully'**
  String get profileWasUpdated;

  /// No description provided for @radialChart.
  ///
  /// In en, this message translates to:
  /// **'Radial chart'**
  String get radialChart;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateApp;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying the app? Let us know with a review'**
  String get rateAppSubtitle;

  /// No description provided for @rateAppFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the store. Please try again later.'**
  String get rateAppFailed;

  /// No description provided for @reacted.
  ///
  /// In en, this message translates to:
  /// **'Reacted to message'**
  String get reacted;

  /// No description provided for @refreshError.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshError;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerBody.
  ///
  /// In en, this message translates to:
  /// **'To register, you must enter a phone number'**
  String get registerBody;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend a code'**
  String get resendOtp;

  /// A message for showing resend otp time
  ///
  /// In en, this message translates to:
  /// **'Resend a code after {time}'**
  String resendOtpAfter(String time);

  /// No description provided for @restore_backUp.
  ///
  /// In en, this message translates to:
  /// **'Restore back up'**
  String get restore_backUp;

  /// No description provided for @restorePreUpdate.
  ///
  /// In en, this message translates to:
  /// **'Restore data from before update'**
  String get restorePreUpdate;

  /// No description provided for @restorePreUpdateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recover entries as they were before the last app update'**
  String get restorePreUpdateSubtitle;

  /// No description provided for @restorePreUpdateConfirm.
  ///
  /// In en, this message translates to:
  /// **'This replaces your current entries with the snapshot saved before the last app update. Continue?'**
  String get restorePreUpdateConfirm;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored'**
  String get restoreSuccess;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read that backup file'**
  String get restoreFailed;

  /// No description provided for @restoreCurrencyPrompt.
  ///
  /// In en, this message translates to:
  /// **'This backup uses the currency \"{symbol}\". Switch to it?'**
  String restoreCurrencyPrompt(String symbol);

  /// No description provided for @restoreCurrencyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get restoreCurrencyConfirm;

  /// No description provided for @restoreLatest.
  ///
  /// In en, this message translates to:
  /// **'Restore latest automatic backup'**
  String get restoreLatest;

  /// No description provided for @autoBackup.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup'**
  String get autoBackup;

  /// No description provided for @autoBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save a dated copy when you open and close the app'**
  String get autoBackupSubtitle;

  /// No description provided for @autoBackupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {when}'**
  String autoBackupLast(String when);

  /// No description provided for @autoBackupEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup is on'**
  String get autoBackupEnabledMessage;

  /// No description provided for @onbBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Never lose your data'**
  String get onbBackupTitle;

  /// No description provided for @onbBackupBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on automatic backups. A dated copy is saved to your Downloads every time you open and close the app.'**
  String get onbBackupBody;

  /// No description provided for @enableAutoBackup.
  ///
  /// In en, this message translates to:
  /// **'Enable automatic backup'**
  String get enableAutoBackup;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @save_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully saved:'**
  String get save_success;

  /// No description provided for @scanBetaBadge.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get scanBetaBadge;

  /// No description provided for @scanBetaNotice.
  ///
  /// In en, this message translates to:
  /// **'Receipt scanning is in beta. Results can vary, so please double-check the amount and description before saving.'**
  String get scanBetaNotice;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read the receipt. Try a clearer photo.'**
  String get scanFailed;

  /// No description provided for @scanInfo.
  ///
  /// In en, this message translates to:
  /// **'About receipt scanning'**
  String get scanInfo;

  /// No description provided for @scanTip1.
  ///
  /// In en, this message translates to:
  /// **'Use bright, even lighting and avoid glare or shadows.'**
  String get scanTip1;

  /// No description provided for @scanTip2.
  ///
  /// In en, this message translates to:
  /// **'Lay the receipt flat on a contrasting surface.'**
  String get scanTip2;

  /// No description provided for @scanTip3.
  ///
  /// In en, this message translates to:
  /// **'Fill the frame with the receipt and keep it straight.'**
  String get scanTip3;

  /// No description provided for @scanTip4.
  ///
  /// In en, this message translates to:
  /// **'Hold steady so the text stays sharp and in focus.'**
  String get scanTip4;

  /// No description provided for @scanTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips for a good scan'**
  String get scanTipsTitle;

  /// No description provided for @scanFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get scanFromCamera;

  /// No description provided for @scanFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get scanFromGallery;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get scanReceipt;

  /// No description provided for @scanningReceipt.
  ///
  /// In en, this message translates to:
  /// **'Reading receipt…'**
  String get scanningReceipt;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No matching transactions'**
  String get noSearchResults;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get second;

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get secure;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @select_output_file.
  ///
  /// In en, this message translates to:
  /// **'Please select an output file:'**
  String get select_output_file;

  /// No description provided for @sendLocation.
  ///
  /// In en, this message translates to:
  /// **'Send location'**
  String get sendLocation;

  /// No description provided for @sendLocationOnline.
  ///
  /// In en, this message translates to:
  /// **'Send live location'**
  String get sendLocationOnline;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendOtp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @strong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strong;

  /// No description provided for @subscribeToFriends.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to friends'**
  String get subscribeToFriends;

  /// No description provided for @subscribers.
  ///
  /// In en, this message translates to:
  /// **'Subscribers'**
  String get subscribers;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @unsupportedMessageType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported message type'**
  String get unsupportedMessageType;

  /// No description provided for @urls.
  ///
  /// In en, this message translates to:
  /// **'Urls'**
  String get urls;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'User agreement'**
  String get userAgreement;

  /// A message for showing status of user, is available or how long before friend was online
  ///
  /// In en, this message translates to:
  /// **'was online {time}'**
  String userTimeStatus(String time);

  /// No description provided for @verifyPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify phone number'**
  String get verifyPhoneNumber;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @videoCall.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get videoCall;

  /// No description provided for @videoMessage.
  ///
  /// In en, this message translates to:
  /// **'Video message'**
  String get videoMessage;

  /// No description provided for @weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Sync your contacts to add friends and view their stories.'**
  String get welcomeBody;

  /// No description provided for @welcomeInfo.
  ///
  /// In en, this message translates to:
  /// **'Your contacts and related information will be sent to Alaja to improve your experience and allow you and others to find friends. Find out more in our '**
  String get welcomeInfo;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @withoutCategory.
  ///
  /// In en, this message translates to:
  /// **'Without category'**
  String get withoutCategory;

  /// No description provided for @writeMessage.
  ///
  /// In en, this message translates to:
  /// **'Write message'**
  String get writeMessage;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @budgetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set monthly spending limits per category'**
  String get budgetsSubtitle;

  /// No description provided for @monthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit'**
  String get monthlyLimit;

  /// No description provided for @setLimit.
  ///
  /// In en, this message translates to:
  /// **'Set limit'**
  String get setLimit;

  /// No description provided for @noLimitSet.
  ///
  /// In en, this message translates to:
  /// **'No limit set'**
  String get noLimitSet;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @removeBudget.
  ///
  /// In en, this message translates to:
  /// **'Remove budget'**
  String get removeBudget;

  /// No description provided for @budgetsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add an expense category first to start budgeting.'**
  String get budgetsEmpty;

  /// No description provided for @budgetChartUnassignedNotice.
  ///
  /// In en, this message translates to:
  /// **'These categories aren\'t assigned a budget. Please add a budget for them.'**
  String get budgetChartUnassignedNotice;

  /// No description provided for @budgetSpentOfLimit.
  ///
  /// In en, this message translates to:
  /// **'{spent} of {limit}'**
  String budgetSpentOfLimit(String spent, String limit);

  /// No description provided for @budgetRemainingAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String budgetRemainingAmount(String amount);

  /// No description provided for @budgetOverAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} over'**
  String budgetOverAmount(String amount);

  /// No description provided for @budgetAlertOverTitle.
  ///
  /// In en, this message translates to:
  /// **'{category} budget reached'**
  String budgetAlertOverTitle(String category);

  /// No description provided for @budgetAlertOverBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached your {category} budget of {limit}.'**
  String budgetAlertOverBody(String category, String limit);

  /// No description provided for @budgetAlertWarnTitle.
  ///
  /// In en, this message translates to:
  /// **'{category} budget alert'**
  String budgetAlertWarnTitle(String category);

  /// No description provided for @budgetAlertWarnBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used {spent} of your {limit} {category} budget.'**
  String budgetAlertWarnBody(String category, String spent, String limit);
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
      <String>['en', 'ru', 'tk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'tk':
      return AppLocalizationsTk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
