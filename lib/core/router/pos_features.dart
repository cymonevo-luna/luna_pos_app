/// POS feature keys returned by the auth and user profile APIs.
///
/// Keys must match the backend privilege registry exactly.
abstract final class PosFeatures {
  static const menu = 'pos.menu';
  static const transactions = 'pos.transactions';
  static const productionRequests = 'pos.production_requests';
  static const stock = 'pos.stock';
  static const purchases = 'pos.purchases';
  static const recurringExpenses = 'pos.recurring_expenses';
  static const cashierBalance = 'pos.cashier_balance';
  static const menusManage = 'pos.menus.manage';
}
