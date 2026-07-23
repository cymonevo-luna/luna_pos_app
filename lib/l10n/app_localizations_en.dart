// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Luna POS';

  @override
  String get appTagline => 'Tagline goes here';

  @override
  String get home => 'Home';

  @override
  String get tasks => 'Tasks';

  @override
  String get calendar => 'Calendar';

  @override
  String get messages => 'Messages';

  @override
  String get profile => 'Profile';

  @override
  String get overview => 'Overview';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get viewAll => 'View all';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get language => 'Language';

  @override
  String greeting(String name) {
    return 'Good morning, $name';
  }

  @override
  String get haveAGreatDay => 'Have a great day!';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue to your account';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get login => 'Login';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signUpToGetStarted => 'Sign up to get started';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signIn => 'Sign In';

  @override
  String get settings => 'Settings';

  @override
  String get myProfile => 'My Profile';

  @override
  String get achievements => 'Achievements';

  @override
  String get activityHistory => 'Activity History';

  @override
  String get savedItems => 'Saved Items';

  @override
  String get projects => 'Projects';

  @override
  String get completed => 'Completed';

  @override
  String get account => 'Account';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get security => 'Security';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get preferences => 'Preferences';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get about => 'About';

  @override
  String get logout => 'Log out';

  @override
  String get english => 'English';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get menu => 'Menu';

  @override
  String get refreshMenu => 'Refresh menu';

  @override
  String get noMenuItemsAvailable => 'No menu items available';

  @override
  String get searchMenu => 'Search menu';

  @override
  String get noMenuSearchResults => 'No menu items match your search';

  @override
  String get retry => 'Retry';

  @override
  String get checkout => 'Checkout';

  @override
  String get payment => 'Payment';

  @override
  String get confirm => 'Confirm';

  @override
  String get complete => 'Complete';

  @override
  String get amountDue => 'Amount due';

  @override
  String get cashReceived => 'Cash received';

  @override
  String get change => 'Change';

  @override
  String get insufficientPayment => 'Insufficient payment';

  @override
  String get paymentSuccess => 'Payment completed successfully';

  @override
  String get grandTotal => 'Grand total';

  @override
  String get quantityLabel => 'Qty';

  @override
  String get noteLabel => 'Note';

  @override
  String get unitPrice => 'Unit price';

  @override
  String get lineTotal => 'Line total';

  @override
  String get noNote => '—';

  @override
  String get printer => 'Printer';

  @override
  String get bluetoothStatus => 'Bluetooth';

  @override
  String get bluetoothOn => 'On';

  @override
  String get bluetoothOff => 'Off';

  @override
  String get printerConnectionStatus => 'Printer';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get connecting => 'Connecting…';

  @override
  String get scanPairedPrinters => 'Scan paired printers';

  @override
  String get noPairedPrintersPlaceholder =>
      'No paired printers found. Pair a printer in Android Bluetooth settings, then scan again.';

  @override
  String get testPrint => 'Test print';

  @override
  String get cart => 'Cart';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get add => 'Add';

  @override
  String get orderTotal => 'Order total';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get clearCart => 'Clear cart';

  @override
  String get remove => 'Remove';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get editNote => 'Edit note';

  @override
  String get noteHint => 'Optional note (e.g. less ice)';

  @override
  String get saleComplete => 'Sale complete';

  @override
  String saleCompleteMessage(String amount) {
    return 'Change due: $amount';
  }

  @override
  String get saleCompleteQrisMessage => 'Payment received via QRIS.';

  @override
  String get ok => 'OK';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get total => 'Total';

  @override
  String get proceed => 'Proceed';

  @override
  String get orderType => 'Order Type';

  @override
  String get noOrderOptionsConfigured =>
      'No order options configured. Contact manager.';

  @override
  String orderOptionLabel(String name) {
    return 'Order type: $name';
  }

  @override
  String get printReceipt => 'Print receipt';

  @override
  String get printAgain => 'Print again';

  @override
  String get printFailedWarning =>
      'Receipt could not be printed. You can retry or continue.';

  @override
  String get receiptPrinted => 'Receipt printed';

  @override
  String get invalidDiscount => 'Discount cannot exceed subtotal';

  @override
  String transactionIdLabel(String id) {
    return 'Transaction ID: $id';
  }

  @override
  String get transactionHistory => 'History';

  @override
  String get transactionDetails => 'Transaction details';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get paymentMethod => 'Payment';

  @override
  String get paymentMethodOffline => 'Cash';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodQris => 'QRIS';

  @override
  String get orderOption => 'Order option';

  @override
  String get noOrderOptions =>
      'No order options configured. Ask an admin to create one before completing sales.';

  @override
  String get cashier => 'Cashier';

  @override
  String get filterByDate => 'Filter by date';

  @override
  String get clearDateFilter => 'Clear date filter';

  @override
  String get notAuthorized => 'Not authorized';

  @override
  String get notAuthorizedMessage =>
      'You do not have permission to view transactions. Please sign out and use a cashier account.';

  @override
  String get stock => 'Stock';

  @override
  String get purchases => 'Purchases';

  @override
  String get stockNew => 'New stock item';

  @override
  String get stockEdit => 'Edit stock item';

  @override
  String get purchasesNew => 'New purchase';

  @override
  String get purchaseDetail => 'Purchase details';

  @override
  String get posAccessDenied =>
      'This account does not have POS or operational access';

  @override
  String get procurementAccessDenied =>
      'You do not have permission to access procurement features.';

  @override
  String get noPurchaseRequests => 'No purchase requests yet';

  @override
  String get purchaseFilterAll => 'All';

  @override
  String get purchaseStatusPending => 'Pending';

  @override
  String get purchaseStatusRequested => 'Requested';

  @override
  String get purchaseStatusPaid => 'Paid';

  @override
  String get purchaseStatusDelivered => 'Delivered';

  @override
  String get purchaseCreatedBy => 'Created by';

  @override
  String purchaseItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get purchaseSupplierLabel => 'Supplier';

  @override
  String get purchaseSelectSupplier => 'Select supplier';

  @override
  String get purchaseSearchSuppliers => 'Search suppliers';

  @override
  String get purchaseLineItems => 'Line items';

  @override
  String get purchaseAddItem => 'Add item';

  @override
  String get purchaseEmptyCatalog => 'This supplier has no catalog prices yet.';

  @override
  String get purchaseNotesHint => 'Optional notes (max 2000 characters)';

  @override
  String get purchaseEstimatedTotal => 'Estimated total';

  @override
  String get purchaseLineTotal => 'Line total';

  @override
  String get purchaseSubmit => 'Submit request';

  @override
  String get purchaseSupplierRequired => 'Select a supplier';

  @override
  String get purchaseAtLeastOneItem => 'Add at least one line item';

  @override
  String get purchaseDuplicateItemError => 'Each supply can only appear once';

  @override
  String get purchaseQuantityRequired => 'Enter a quantity greater than 0';

  @override
  String get purchaseSelectCatalogItem => 'Select catalog item';

  @override
  String get purchaseUpdateStatus => 'Update status';

  @override
  String get purchaseTakePhoto => 'Take photo';

  @override
  String get purchaseChooseGallery => 'Choose from gallery';

  @override
  String get purchaseProofPhotos => 'Proof photos';

  @override
  String get purchaseProofPaid => 'Payment proof';

  @override
  String get purchaseProofDelivered => 'Delivery proof';

  @override
  String get purchaseContactSupplier => 'Contact supplier';

  @override
  String get purchaseCreatedAt => 'Created at';

  @override
  String get smartPurchaseTitle => 'Smart Request';

  @override
  String get smartPurchaseStepIngredients => 'Ingredients';

  @override
  String get smartPurchaseStepReview => 'Review';

  @override
  String get smartPurchaseStepConfirm => 'Confirm';

  @override
  String get smartPurchaseIngredients => 'Ingredients';

  @override
  String get smartPurchaseSelectIngredient => 'Select ingredient';

  @override
  String get smartPurchaseSearchIngredients => 'Search ingredients';

  @override
  String get smartPurchaseNoIngredients => 'No ingredients found';

  @override
  String get smartPurchaseBack => 'Back';

  @override
  String get smartPurchaseNext => 'Next';

  @override
  String get smartPurchaseReviewAction => 'Review';

  @override
  String get smartPurchaseGroupedBySupplier => 'Grouped by supplier';

  @override
  String get smartPurchaseUnmatchedItems => 'Items needing supplier';

  @override
  String get smartPurchaseUnmatchedWarning =>
      'Some items have no supplier price. Select a supplier before continuing.';

  @override
  String get smartPurchaseUnmatchedBlocked =>
      'Select a supplier for every item before continuing.';

  @override
  String get smartPurchaseSelectSupplierManually => 'Select supplier';

  @override
  String get smartPurchaseNoSupplierPrices =>
      'No supplier prices available for this item.';

  @override
  String get smartPurchaseNoGroups =>
      'No supplier groups yet. Select suppliers for all items.';

  @override
  String get smartPurchaseConfirmSummary => 'Review and submit';

  @override
  String get smartPurchaseSuggestFailed =>
      'Could not load supplier suggestions. Try again.';

  @override
  String get smartPurchaseSubmitFailed =>
      'Could not submit smart request. Try again.';

  @override
  String get smartPurchaseSubmitSuccess => 'Purchase requests created';

  @override
  String get smartPurchaseActualPriceLabel => 'Actual price (optional)';

  @override
  String get smartPurchaseCatalogUpdateLabel => 'Update supplier catalog price';

  @override
  String get smartPurchaseCatalogPriceAmount => 'Catalog price amount';

  @override
  String get smartPurchaseCatalogPriceQuantity => 'Catalog price quantity';

  @override
  String get searchStock => 'Search supplies';

  @override
  String get addSupply => 'Add supply';

  @override
  String get noStockItems => 'No supplies yet';

  @override
  String get stockTitleLabel => 'Title';

  @override
  String get stockDescriptionLabel => 'Description';

  @override
  String get stockQuantityLabel => 'Stock quantity';

  @override
  String get stockUnitLabel => 'Unit';

  @override
  String get save => 'Save';

  @override
  String get stockTitleTooShort => 'Title must be at least 2 characters';

  @override
  String get stockQuantityInvalid => 'Enter a quantity of 0 or more';

  @override
  String get stockManualEditHistory => 'Manual edit history';

  @override
  String get stockNoManualEdits => 'No manual quantity edits yet';

  @override
  String get deliveries => 'Production';

  @override
  String get productionDeliveries => 'Production';

  @override
  String get productionDeliveryDetail => 'Delivery details';

  @override
  String get noDeliveriesPending => 'No deliveries pending';

  @override
  String get confirmDelivery => 'Confirm delivery';

  @override
  String get deliveryConfirmed => 'Delivery confirmed';

  @override
  String get productionDeliveryItems => 'Items';

  @override
  String productionItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get recurringExpensesTitle => 'Recurring';

  @override
  String get createRecurringExpense => 'New recurring expense';

  @override
  String get editRecurringExpense => 'Edit recurring expense';

  @override
  String get searchRecurringExpenses => 'Search recurring expenses';

  @override
  String get noRecurringExpenses => 'No recurring expenses yet';

  @override
  String get intervalDaily => 'Daily';

  @override
  String get intervalDay => 'Weekly';

  @override
  String get intervalDate => 'Monthly';

  @override
  String get dayOfMonth => 'Day of month';

  @override
  String get weekday => 'Weekday';

  @override
  String get nextRunAt => 'Next run';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get recurringExpenseAmountLabel => 'Amount';

  @override
  String get recurringExpenseIntervalLabel => 'Schedule interval';

  @override
  String get recurringExpenseTimeLabel => 'Run time';

  @override
  String get hourLabel => 'Hour';

  @override
  String get minuteLabel => 'Minute';

  @override
  String get secondLabel => 'Second';

  @override
  String get recurringExpenseTitleTooShort =>
      'Title must be at least 2 characters';

  @override
  String get recurringExpenseAmountInvalid => 'Enter an amount greater than 0';

  @override
  String get recurringExpenseDayOfMonthInvalid =>
      'Enter a day between 1 and 31';

  @override
  String get recurringExpenseWeekdayInvalid =>
      'Select a weekday between 1 and 7';

  @override
  String recurringScheduleDaily(String time) {
    return 'Every day at $time';
  }

  @override
  String recurringScheduleDate(int day, String time) {
    return 'Day $day of month at $time';
  }

  @override
  String recurringScheduleDay(String weekday, String time) {
    return 'Every $weekday at $time';
  }

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get deleteRecurringExpense => 'Delete recurring expense';

  @override
  String deleteRecurringExpenseConfirm(String title) {
    return 'Delete \"$title\"? This cannot be undone.';
  }

  @override
  String get deleteRecurringExpenseFailed =>
      'Failed to delete recurring expense';

  @override
  String get recurringExpenseStaffSalaryBadge => 'Staff salary';

  @override
  String get recurringExpenseManagedByStaffSalary =>
      'This recurring expense is managed by staff salary.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get cashierBalanceTitle => 'Cashier Balance';

  @override
  String get cashierBalanceCurrent => 'Current balance';

  @override
  String get cashierBalanceHistory => 'History';

  @override
  String get cashierBalanceAdd => 'Add';

  @override
  String get cashierBalanceDeduct => 'Deduct';

  @override
  String get cashierBalanceAmountLabel => 'Amount';

  @override
  String get cashierBalancePurposeLabel => 'Purpose';

  @override
  String get cashierBalanceAmountInvalid => 'Enter an amount greater than 0';

  @override
  String get cashierBalanceAdjustSuccess => 'Cashier balance updated';

  @override
  String get cashierBalanceAdjustFailed => 'Failed to update cashier balance';

  @override
  String get cashierBalanceNoEntries => 'No balance entries yet';

  @override
  String get cashierBalanceRequestedBy => 'Requested by';

  @override
  String get cashierBalanceTransaction => 'Transaction';

  @override
  String get cashierBalanceAccessDenied =>
      'You do not have access to cashier balance.';
}
