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

  /// Manage menu tab and screen title
  ///
  /// In en, this message translates to:
  /// **'Manage Menu'**
  String get manageMenus;

  /// Create menu form title and FAB label
  ///
  /// In en, this message translates to:
  /// **'New menu'**
  String get manageMenusNew;

  /// Edit menu form title
  ///
  /// In en, this message translates to:
  /// **'Edit menu'**
  String get manageMenusEdit;

  /// Search field hint on manage menu list
  ///
  /// In en, this message translates to:
  /// **'Search menus'**
  String get manageMenusSearch;

  /// Empty state on manage menu list
  ///
  /// In en, this message translates to:
  /// **'No menus yet'**
  String get noManageMenus;

  /// Category dropdown label on menu form
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get manageMenusCategoryLabel;

  /// Validation when category is not selected
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get manageMenusCategoryRequired;

  /// Stock field label on menu form
  ///
  /// In en, this message translates to:
  /// **'Available stock'**
  String get manageMenusStockLabel;

  /// Validation when stock is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a stock amount of 0 or more'**
  String get manageMenusStockInvalid;

  /// Sell price field label on menu form
  ///
  /// In en, this message translates to:
  /// **'Sell price'**
  String get manageMenusSellPriceLabel;

  /// Validation when sell price is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a price greater than 0'**
  String get manageMenusSellPriceInvalid;

  /// Button to pick a menu photo from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get manageMenusPickPhoto;

  /// Shown when menu photo upload fails
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photo'**
  String get manageMenusPhotoUploadFailed;

  /// SnackBar after successful menu save
  ///
  /// In en, this message translates to:
  /// **'Menu saved'**
  String get manageMenusSaved;

  /// SnackBar after successful menu delete
  ///
  /// In en, this message translates to:
  /// **'Menu deleted'**
  String get manageMenusDeleted;

  /// Title for delete menu confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete menu'**
  String get deleteManageMenu;

  /// Message for delete menu confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"? This cannot be undone.'**
  String deleteManageMenuConfirm(String title);

  /// SnackBar when menu delete fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete menu'**
  String get deleteManageMenuFailed;

  /// Sort dropdown label on manage menu list
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get manageMenusSortLabel;

  /// Sort menus by title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get manageMenusSortTitle;

  /// Sort menus by stock
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get manageMenusSortStock;

  /// Ascending sort order tooltip
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get manageMenusSortAscending;

  /// Descending sort order tooltip
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get manageMenusSortDescending;

  /// Tooltip for menu layout toggle in the app bar
  ///
  /// In en, this message translates to:
  /// **'Menu layout'**
  String get menuLayout;

  /// No description provided for @menuLayoutGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get menuLayoutGrid;

  /// No description provided for @menuLayoutList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get menuLayoutList;

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

  /// Search field hint on menu page
  ///
  /// In en, this message translates to:
  /// **'Search menu'**
  String get searchMenu;

  /// Empty state when menu search has no matches
  ///
  /// In en, this message translates to:
  /// **'No menu items match your search'**
  String get noMenuSearchResults;

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

  /// Reset all banknote denomination counts to zero
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearBanknotes;

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

  /// Label for dine-in / take-away order option selector on checkout
  ///
  /// In en, this message translates to:
  /// **'Order Type'**
  String get orderType;

  /// Blocking message when merchant has no order options
  ///
  /// In en, this message translates to:
  /// **'No order options configured. Contact manager.'**
  String get noOrderOptionsConfigured;

  /// Shows selected order option on sale complete dialog
  ///
  /// In en, this message translates to:
  /// **'Order type: {name}'**
  String orderOptionLabel(String name);

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

  /// Confirmation when a receipt was printed successfully
  ///
  /// In en, this message translates to:
  /// **'Receipt printed'**
  String get receiptPrinted;

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

  /// Order option selector label on checkout
  ///
  /// In en, this message translates to:
  /// **'Order option'**
  String get orderOption;

  /// Shown when the merchant has zero POS order options
  ///
  /// In en, this message translates to:
  /// **'No order options configured. Ask an admin to create one before completing sales.'**
  String get noOrderOptions;

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

  /// Label for supplier selector on purchase create form
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get purchaseSupplierLabel;

  /// Placeholder and sheet title for supplier picker
  ///
  /// In en, this message translates to:
  /// **'Select supplier'**
  String get purchaseSelectSupplier;

  /// Search hint in supplier picker
  ///
  /// In en, this message translates to:
  /// **'Search suppliers'**
  String get purchaseSearchSuppliers;

  /// Section title for purchase line items
  ///
  /// In en, this message translates to:
  /// **'Line items'**
  String get purchaseLineItems;

  /// Button to add a catalog line item
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get purchaseAddItem;

  /// Shown when supplier has no price quotes
  ///
  /// In en, this message translates to:
  /// **'This supplier has no catalog prices yet.'**
  String get purchaseEmptyCatalog;

  /// Hint for purchase request notes field
  ///
  /// In en, this message translates to:
  /// **'Optional notes (max 2000 characters)'**
  String get purchaseNotesHint;

  /// Sticky footer label for purchase total
  ///
  /// In en, this message translates to:
  /// **'Estimated total'**
  String get purchaseEstimatedTotal;

  /// Estimated total for one purchase line
  ///
  /// In en, this message translates to:
  /// **'Line total'**
  String get purchaseLineTotal;

  /// Submit purchase request button
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get purchaseSubmit;

  /// Validation when supplier is missing
  ///
  /// In en, this message translates to:
  /// **'Select a supplier'**
  String get purchaseSupplierRequired;

  /// Validation when no line items
  ///
  /// In en, this message translates to:
  /// **'Add at least one line item'**
  String get purchaseAtLeastOneItem;

  /// Validation when duplicate food supplies in request
  ///
  /// In en, this message translates to:
  /// **'Each supply can only appear once'**
  String get purchaseDuplicateItemError;

  /// Validation when line quantity is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity greater than 0'**
  String get purchaseQuantityRequired;

  /// Optional actual line total input on purchase create
  ///
  /// In en, this message translates to:
  /// **'Actual price (Rp)'**
  String get purchaseActualPriceLabel;

  /// Switch to update supplier catalog price on purchase create
  ///
  /// In en, this message translates to:
  /// **'Update supplier catalog price'**
  String get purchaseUpdateCatalogPrice;

  /// Editable catalog price amount when updating supplier price
  ///
  /// In en, this message translates to:
  /// **'Catalog price amount'**
  String get purchaseCatalogPriceAmount;

  /// Editable catalog price quantity when updating supplier price
  ///
  /// In en, this message translates to:
  /// **'Catalog price quantity'**
  String get purchaseCatalogPriceQuantity;

  /// Sticky footer label for actual purchase total
  ///
  /// In en, this message translates to:
  /// **'Actual total'**
  String get purchaseActualTotal;

  /// Validation when actual line price is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter an actual price greater than 0'**
  String get purchaseActualPriceRequired;

  /// Validation when catalog price amount is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a catalog price amount greater than 0'**
  String get purchaseCatalogPriceAmountRequired;

  /// Validation when catalog price quantity is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a catalog price quantity greater than 0'**
  String get purchaseCatalogPriceQuantityRequired;

  /// Title for catalog item picker sheet
  ///
  /// In en, this message translates to:
  /// **'Select catalog item'**
  String get purchaseSelectCatalogItem;

  /// Label for purchase status dropdown on detail screen
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get purchaseUpdateStatus;

  /// Action to capture proof photo with camera
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get purchaseTakePhoto;

  /// Action to pick proof photo from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get purchaseChooseGallery;

  /// Section title for uploaded proof thumbnails
  ///
  /// In en, this message translates to:
  /// **'Proof photos'**
  String get purchaseProofPhotos;

  /// Label for paid proof thumbnail
  ///
  /// In en, this message translates to:
  /// **'Payment proof'**
  String get purchaseProofPaid;

  /// Label for delivered proof thumbnail
  ///
  /// In en, this message translates to:
  /// **'Delivery proof'**
  String get purchaseProofDelivered;

  /// Button to open WhatsApp chat with supplier
  ///
  /// In en, this message translates to:
  /// **'Contact supplier'**
  String get purchaseContactSupplier;

  /// Label for purchase request creation timestamp
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get purchaseCreatedAt;

  /// Title for smart supplier purchase request flow
  ///
  /// In en, this message translates to:
  /// **'Smart Request'**
  String get smartPurchaseTitle;

  /// Wizard step label for ingredient selection
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get smartPurchaseStepIngredients;

  /// Wizard step label for supplier review
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get smartPurchaseStepReview;

  /// Wizard step label for final confirmation
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get smartPurchaseStepConfirm;

  /// Section title for ingredient list in smart request
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get smartPurchaseIngredients;

  /// Title for food supply picker sheet
  ///
  /// In en, this message translates to:
  /// **'Select ingredient'**
  String get smartPurchaseSelectIngredient;

  /// Search hint for food supply picker
  ///
  /// In en, this message translates to:
  /// **'Search ingredients'**
  String get smartPurchaseSearchIngredients;

  /// Empty state for food supply picker
  ///
  /// In en, this message translates to:
  /// **'No ingredients found'**
  String get smartPurchaseNoIngredients;

  /// Back button in smart request wizard
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get smartPurchaseBack;

  /// Next button in smart request wizard
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get smartPurchaseNext;

  /// Proceed to review step button
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get smartPurchaseReviewAction;

  /// Section title for supplier groups on review step
  ///
  /// In en, this message translates to:
  /// **'Grouped by supplier'**
  String get smartPurchaseGroupedBySupplier;

  /// Section title for unmatched items
  ///
  /// In en, this message translates to:
  /// **'Items needing supplier'**
  String get smartPurchaseUnmatchedItems;

  /// Warning banner for unmatched items
  ///
  /// In en, this message translates to:
  /// **'Some items have no supplier price. Select a supplier before continuing.'**
  String get smartPurchaseUnmatchedWarning;

  /// Error when trying to continue with unmatched items
  ///
  /// In en, this message translates to:
  /// **'Select a supplier for every item before continuing.'**
  String get smartPurchaseUnmatchedBlocked;

  /// Button to open manual supplier picker
  ///
  /// In en, this message translates to:
  /// **'Select supplier'**
  String get smartPurchaseSelectSupplierManually;

  /// Error when supplier-prices endpoint returns empty
  ///
  /// In en, this message translates to:
  /// **'No supplier prices available for this item.'**
  String get smartPurchaseNoSupplierPrices;

  /// Empty state when no supplier groups exist
  ///
  /// In en, this message translates to:
  /// **'No supplier groups yet. Select suppliers for all items.'**
  String get smartPurchaseNoGroups;

  /// Title on confirm step
  ///
  /// In en, this message translates to:
  /// **'Review and submit'**
  String get smartPurchaseConfirmSummary;

  /// Generic error when suggest API fails
  ///
  /// In en, this message translates to:
  /// **'Could not load supplier suggestions. Try again.'**
  String get smartPurchaseSuggestFailed;

  /// Generic error when batch API fails
  ///
  /// In en, this message translates to:
  /// **'Could not submit smart request. Try again.'**
  String get smartPurchaseSubmitFailed;

  /// Snack bar after successful batch submit
  ///
  /// In en, this message translates to:
  /// **'Purchase requests created'**
  String get smartPurchaseSubmitSuccess;

  /// Label for optional actual line amount on smart purchase review
  ///
  /// In en, this message translates to:
  /// **'Actual price (optional)'**
  String get smartPurchaseActualPriceLabel;

  /// Switch label to submit supplier price update with batch
  ///
  /// In en, this message translates to:
  /// **'Update supplier catalog price'**
  String get smartPurchaseCatalogUpdateLabel;

  /// Label for catalog update price amount field
  ///
  /// In en, this message translates to:
  /// **'Catalog price amount'**
  String get smartPurchaseCatalogPriceAmount;

  /// Label for catalog update price quantity field
  ///
  /// In en, this message translates to:
  /// **'Catalog price quantity'**
  String get smartPurchaseCatalogPriceQuantity;

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

  /// Section title for manual food supply quantity edit history
  ///
  /// In en, this message translates to:
  /// **'Manual edit history'**
  String get stockManualEditHistory;

  /// Empty state when a food supply has no manual quantity edits
  ///
  /// In en, this message translates to:
  /// **'No manual quantity edits yet'**
  String get stockNoManualEdits;

  /// Production bottom navigation label
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get deliveries;

  /// Production inbox screen title
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get productionDeliveries;

  /// Production delivery detail screen title
  ///
  /// In en, this message translates to:
  /// **'Delivery details'**
  String get productionDeliveryDetail;

  /// Empty state when there are no READY_TO_PICK production requests
  ///
  /// In en, this message translates to:
  /// **'No deliveries pending'**
  String get noDeliveriesPending;

  /// Button to mark a production request as delivered
  ///
  /// In en, this message translates to:
  /// **'Confirm delivery'**
  String get confirmDelivery;

  /// SnackBar shown after cashier confirms production delivery
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed'**
  String get deliveryConfirmed;

  /// Section header for production request line items
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get productionDeliveryItems;

  /// Fallback summary when list rows have no embedded items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String productionItemCount(int count);

  /// Recurring expenses tab and screen title
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurringExpensesTitle;

  /// Create recurring expense screen title and FAB label
  ///
  /// In en, this message translates to:
  /// **'New recurring expense'**
  String get createRecurringExpense;

  /// Edit recurring expense screen title
  ///
  /// In en, this message translates to:
  /// **'Edit recurring expense'**
  String get editRecurringExpense;

  /// Search field hint on recurring expense list
  ///
  /// In en, this message translates to:
  /// **'Search recurring expenses'**
  String get searchRecurringExpenses;

  /// Empty state on recurring expense list
  ///
  /// In en, this message translates to:
  /// **'No recurring expenses yet'**
  String get noRecurringExpenses;

  /// Recurring schedule interval: every day
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get intervalDaily;

  /// Recurring schedule interval: specific weekday
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get intervalDay;

  /// Recurring schedule interval: day of month
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get intervalDate;

  /// Label for monthly recurring day-of-month field
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get dayOfMonth;

  /// Label for weekly recurring weekday field
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get weekday;

  /// Label for next scheduled run timestamp
  ///
  /// In en, this message translates to:
  /// **'Next run'**
  String get nextRunAt;

  /// Active status label for recurring expense
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Inactive status label for recurring expense
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Amount field label on recurring expense form
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get recurringExpenseAmountLabel;

  /// Interval dropdown label on recurring expense form
  ///
  /// In en, this message translates to:
  /// **'Schedule interval'**
  String get recurringExpenseIntervalLabel;

  /// Time picker section label on recurring expense form
  ///
  /// In en, this message translates to:
  /// **'Run time'**
  String get recurringExpenseTimeLabel;

  /// Hour picker label
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hourLabel;

  /// Minute picker label
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minuteLabel;

  /// Second picker label
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get secondLabel;

  /// Validation when recurring expense title is too short
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 2 characters'**
  String get recurringExpenseTitleTooShort;

  /// Validation when recurring expense amount is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than 0'**
  String get recurringExpenseAmountInvalid;

  /// Validation when day of month is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a day between 1 and 31'**
  String get recurringExpenseDayOfMonthInvalid;

  /// Validation when weekday value is invalid
  ///
  /// In en, this message translates to:
  /// **'Select a weekday between 1 and 7'**
  String get recurringExpenseWeekdayInvalid;

  /// Schedule summary for daily recurring expense
  ///
  /// In en, this message translates to:
  /// **'Every day at {time}'**
  String recurringScheduleDaily(String time);

  /// Schedule summary for monthly recurring expense
  ///
  /// In en, this message translates to:
  /// **'Day {day} of month at {time}'**
  String recurringScheduleDate(int day, String time);

  /// Schedule summary for weekly recurring expense
  ///
  /// In en, this message translates to:
  /// **'Every {weekday} at {time}'**
  String recurringScheduleDay(String weekday, String time);

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// Title for delete recurring expense confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete recurring expense'**
  String get deleteRecurringExpense;

  /// Message for delete recurring expense confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"? This cannot be undone.'**
  String deleteRecurringExpenseConfirm(String title);

  /// SnackBar when delete recurring expense fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete recurring expense'**
  String get deleteRecurringExpenseFailed;

  /// Badge label for recurring expenses linked to staff salary
  ///
  /// In en, this message translates to:
  /// **'Staff salary'**
  String get recurringExpenseStaffSalaryBadge;

  /// Error when update/delete is rejected because expense is staff-managed
  ///
  /// In en, this message translates to:
  /// **'This recurring expense is managed by staff salary.'**
  String get recurringExpenseManagedByStaffSalary;

  /// Expenses tab and screen title
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// Create expense screen title and FAB label
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get createExpense;

  /// Edit expense screen title
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpense;

  /// Search field hint on expense list
  ///
  /// In en, this message translates to:
  /// **'Search expenses'**
  String get searchExpenses;

  /// Empty state on expense list
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpenses;

  /// Amount field label on expense form
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmountLabel;

  /// Validation when expense title is too short
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 2 characters'**
  String get expenseTitleTooShort;

  /// Validation when expense amount is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than 0'**
  String get expenseAmountInvalid;

  /// Source of fund dropdown label on expense form
  ///
  /// In en, this message translates to:
  /// **'Source of fund'**
  String get expenseSourceOfFundLabel;

  /// Cashier source of fund option
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get expenseSourceCashier;

  /// Personal money source of fund option
  ///
  /// In en, this message translates to:
  /// **'Personal money'**
  String get expenseSourcePersonalMoney;

  /// Admin-only reporting date field label on expense edit form
  ///
  /// In en, this message translates to:
  /// **'Reporting date'**
  String get expenseReportingDateLabel;

  /// Generic error when expense save fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save expense'**
  String get expenseSaveFailed;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Title for the cashier balance screen and tab
  ///
  /// In en, this message translates to:
  /// **'Cashier Balance'**
  String get cashierBalanceTitle;

  /// Label for the current cashier balance card
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get cashierBalanceCurrent;

  /// Section title for cashier balance ledger history
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get cashierBalanceHistory;

  /// Action to add funds to cashier balance
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get cashierBalanceAdd;

  /// Action to deduct funds from cashier balance
  ///
  /// In en, this message translates to:
  /// **'Deduct'**
  String get cashierBalanceDeduct;

  /// Amount field label on cashier balance adjustment form
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get cashierBalanceAmountLabel;

  /// Purpose field label on cashier balance adjustment form
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get cashierBalancePurposeLabel;

  /// Validation when cashier balance adjustment amount is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than 0'**
  String get cashierBalanceAmountInvalid;

  /// SnackBar when cashier balance adjustment succeeds
  ///
  /// In en, this message translates to:
  /// **'Cashier balance updated'**
  String get cashierBalanceAdjustSuccess;

  /// SnackBar when cashier balance adjustment fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update cashier balance'**
  String get cashierBalanceAdjustFailed;

  /// Empty state when cashier balance history has no entries
  ///
  /// In en, this message translates to:
  /// **'No balance entries yet'**
  String get cashierBalanceNoEntries;

  /// Label prefix for the user who requested a balance entry
  ///
  /// In en, this message translates to:
  /// **'Requested by'**
  String get cashierBalanceRequestedBy;

  /// Label prefix for linked transaction id on a balance entry
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get cashierBalanceTransaction;

  /// Forbidden message when user lacks cashier balance feature
  ///
  /// In en, this message translates to:
  /// **'You do not have access to cashier balance.'**
  String get cashierBalanceAccessDenied;

  /// Screen title and tooltip for today's per-menu sales summary
  ///
  /// In en, this message translates to:
  /// **'Daily Menu Summary'**
  String get dailyMenuSummaryTitle;

  /// Total quantity sold today on the daily menu summary card
  ///
  /// In en, this message translates to:
  /// **'Items sold'**
  String get dailyMenuSummaryTotalItems;

  /// Total revenue today on the daily menu summary card
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get dailyMenuSummaryTotalRevenue;

  /// Empty state when no menus were sold today
  ///
  /// In en, this message translates to:
  /// **'No menu sales today'**
  String get dailyMenuSummaryNoSales;

  /// Title for dispose food screen and navigation tab
  ///
  /// In en, this message translates to:
  /// **'Dispose Food'**
  String get disposeFoodTitle;

  /// Instruction shown on dispose food menu selection step
  ///
  /// In en, this message translates to:
  /// **'Select a menu item to dispose'**
  String get disposeFoodSelectMenu;

  /// Action to clear selected menu on dispose food screen
  ///
  /// In en, this message translates to:
  /// **'Change menu'**
  String get disposeFoodChangeMenu;

  /// Quantity field label on dispose food form
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get disposeFoodQuantity;

  /// Hint for optional dispose food note field
  ///
  /// In en, this message translates to:
  /// **'Optional reason for disposal (max 500 characters)'**
  String get disposeFoodNoteHint;

  /// Summary card title on dispose food form
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get disposeFoodSummary;

  /// Label for pre-submit estimated loss amount
  ///
  /// In en, this message translates to:
  /// **'Estimated loss'**
  String get disposeFoodEstimatedLoss;

  /// Subtitle explaining loss is finalized on submit
  ///
  /// In en, this message translates to:
  /// **'Final loss is calculated when you submit'**
  String get disposeFoodLossCalculatedOnSubmit;

  /// Submit button on dispose food form
  ///
  /// In en, this message translates to:
  /// **'Confirm disposal'**
  String get disposeFoodConfirm;

  /// SnackBar after successful menu disposal
  ///
  /// In en, this message translates to:
  /// **'Disposed {menuTitle} x{quantity}. Loss: {lossAmount}'**
  String disposeFoodSuccess(String menuTitle, int quantity, String lossAmount);

  /// Label for menu item available stock count
  ///
  /// In en, this message translates to:
  /// **'Available stock'**
  String get availableStock;
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
