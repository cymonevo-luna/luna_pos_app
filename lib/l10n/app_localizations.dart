import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
    Locale('id'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Luna POS'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Tagline goes here'**
  String get appTagline;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Greeting on the home banner
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String greeting(String name);

  /// No description provided for @haveAGreatDay.
  ///
  /// In en, this message translates to:
  /// **'Have a great day!'**
  String get haveAGreatDay;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your account'**
  String get signInToContinue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signUpToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signUpToGetStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @activityHistory.
  ///
  /// In en, this message translates to:
  /// **'Activity History'**
  String get activityHistory;

  /// No description provided for @savedItems.
  ///
  /// In en, this message translates to:
  /// **'Saved Items'**
  String get savedItems;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @refreshMenu.
  ///
  /// In en, this message translates to:
  /// **'Refresh menu'**
  String get refreshMenu;

  /// No description provided for @noMenuItemsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No menu items available'**
  String get noMenuItemsAvailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Checkout screen title
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Payment screen title
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Confirm checkout and proceed to payment
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Complete payment button label
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// Total amount due on the payment screen
  ///
  /// In en, this message translates to:
  /// **'Amount due'**
  String get amountDue;

  /// Cash received input label
  ///
  /// In en, this message translates to:
  /// **'Cash received'**
  String get cashReceived;

  /// Change amount returned to customer
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Shown when cash received is less than amount due
  ///
  /// In en, this message translates to:
  /// **'Insufficient payment'**
  String get insufficientPayment;

  /// SnackBar shown after successful payment
  ///
  /// In en, this message translates to:
  /// **'Payment completed successfully'**
  String get paymentSuccess;

  /// Checkout order grand total label
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get grandTotal;

  /// Abbreviated quantity label on checkout line items
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quantityLabel;

  /// Note label on checkout line items
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// Unit price label on checkout line items
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get unitPrice;

  /// Line total label on checkout line items
  ///
  /// In en, this message translates to:
  /// **'Line total'**
  String get lineTotal;

  /// Placeholder when a cart line has no note
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get noNote;

  /// Printer settings section title
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get printer;

  /// Bluetooth status label in printer settings
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetoothStatus;

  /// Bluetooth enabled status
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get bluetoothOn;

  /// Bluetooth disabled status
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get bluetoothOff;

  /// Printer connection status label
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get printerConnectionStatus;

  /// Printer connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Printer disconnected status
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Printer connecting status
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// Button to refresh paired Bluetooth printers
  ///
  /// In en, this message translates to:
  /// **'Scan paired printers'**
  String get scanPairedPrinters;

  /// Placeholder when no paired printers are available
  ///
  /// In en, this message translates to:
  /// **'No paired printers found. Pair a printer in Android Bluetooth settings, then scan again.'**
  String get noPairedPrintersPlaceholder;

  /// Button to print a sample receipt
  ///
  /// In en, this message translates to:
  /// **'Test print'**
  String get testPrint;

  /// Cart screen title
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Add menu item to cart button label
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// Confirm adding an item from the menu bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Running order total on the menu page bottom bar
  ///
  /// In en, this message translates to:
  /// **'Order total'**
  String get orderTotal;

  /// Message shown when the cart has no items
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// Clear all items from the cart
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get clearCart;

  /// Remove a line from the cart
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Cart item count summary
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// Edit cart line note dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// Hint for optional cart line note input
  ///
  /// In en, this message translates to:
  /// **'Optional note (e.g. less ice)'**
  String get noteHint;

  /// Title shown after a successful offline sale
  ///
  /// In en, this message translates to:
  /// **'Sale complete'**
  String get saleComplete;

  /// Success message after completing an offline sale
  ///
  /// In en, this message translates to:
  /// **'Change due: {amount}'**
  String saleCompleteMessage(String amount);

  /// Success message after completing a QRIS sale
  ///
  /// In en, this message translates to:
  /// **'Payment received via QRIS.'**
  String get saleCompleteQrisMessage;

  /// Dismiss confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Order subtotal before discount
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Discount amount input label
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// Final total after discount
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Complete checkout
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// Checkbox label to print receipt after checkout
  ///
  /// In en, this message translates to:
  /// **'Print receipt'**
  String get printReceipt;

  /// Retry printing the receipt
  ///
  /// In en, this message translates to:
  /// **'Print again'**
  String get printAgain;

  /// Warning when sale succeeded but printing failed
  ///
  /// In en, this message translates to:
  /// **'Receipt could not be printed. You can retry or continue.'**
  String get printFailedWarning;

  /// Validation error for discount input
  ///
  /// In en, this message translates to:
  /// **'Discount cannot exceed subtotal'**
  String get invalidDiscount;

  /// Shows the created transaction id after checkout
  ///
  /// In en, this message translates to:
  /// **'Transaction ID: {id}'**
  String transactionIdLabel(String id);

  /// Transaction history bottom navigation label and screen title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get transactionHistory;

  /// Transaction detail screen title
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get transactionDetails;

  /// Empty state when the cashier has no transaction history
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// Payment method label on transaction rows
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentMethod;

  /// Display label for OFFLINE payment method
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodOffline;

  /// Display label for CASH payment method
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// Display label for QRIS payment method
  ///
  /// In en, this message translates to:
  /// **'QRIS'**
  String get paymentMethodQris;

  /// Cashier name label on transaction rows and detail
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get cashier;

  /// Opens the date range filter picker
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get filterByDate;

  /// Clears the active transaction date range filter
  ///
  /// In en, this message translates to:
  /// **'Clear date filter'**
  String get clearDateFilter;

  /// Title when transaction history returns HTTP 403
  ///
  /// In en, this message translates to:
  /// **'Not authorized'**
  String get notAuthorized;

  /// Message when transaction history returns HTTP 403
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view transactions. Please sign out and use a cashier account.'**
  String get notAuthorizedMessage;

  /// Stock management tab and screen title
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// Purchase orders tab and screen title
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// Create stock item screen title
  ///
  /// In en, this message translates to:
  /// **'New stock item'**
  String get stockNew;

  /// Edit stock item screen title
  ///
  /// In en, this message translates to:
  /// **'Edit stock item'**
  String get stockEdit;

  /// Create purchase order screen title
  ///
  /// In en, this message translates to:
  /// **'New purchase'**
  String get purchasesNew;

  /// Purchase order detail screen title
  ///
  /// In en, this message translates to:
  /// **'Purchase details'**
  String get purchaseDetail;

  /// Shown when login succeeds but the user lacks cashier and operational roles
  ///
  /// In en, this message translates to:
  /// **'This account does not have POS or operational access'**
  String get posAccessDenied;

  /// Shown when an authenticated user without operational role opens stock or purchases
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access procurement features.'**
  String get procurementAccessDenied;

  /// Empty state when there are no purchase requests
  ///
  /// In en, this message translates to:
  /// **'No purchase requests yet'**
  String get noPurchaseRequests;

  /// Purchase list filter showing all statuses
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get purchaseFilterAll;

  /// Purchase request status: pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get purchaseStatusPending;

  /// Purchase request status: requested
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get purchaseStatusRequested;

  /// Purchase request status: paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get purchaseStatusPaid;

  /// Purchase request status: delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get purchaseStatusDelivered;

  /// Label for purchase request creator username
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get purchaseCreatedBy;

  /// Number of items in a purchase request
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String purchaseItemCount(int count);

  /// Search field hint on stock list
  ///
  /// In en, this message translates to:
  /// **'Search supplies'**
  String get searchStock;

  /// FAB label to create a food supply
  ///
  /// In en, this message translates to:
  /// **'Add supply'**
  String get addSupply;

  /// Empty state on stock list
  ///
  /// In en, this message translates to:
  /// **'No supplies yet'**
  String get noStockItems;

  /// Food supply title field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get stockTitleLabel;

  /// Food supply description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get stockDescriptionLabel;

  /// Food supply quantity field label
  ///
  /// In en, this message translates to:
  /// **'Stock quantity'**
  String get stockQuantityLabel;

  /// Food supply unit dropdown label
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get stockUnitLabel;

  /// Save form button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Validation when food supply title is too short
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 2 characters'**
  String get stockTitleTooShort;

  /// Validation when food supply quantity is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity of 0 or more'**
  String get stockQuantityInvalid;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
