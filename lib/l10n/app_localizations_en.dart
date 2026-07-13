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
  String get printReceipt => 'Print receipt';

  @override
  String get printAgain => 'Print again';

  @override
  String get printFailedWarning =>
      'Receipt could not be printed. You can retry or continue.';

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
}
