import '../order/models/order_line_item.dart';
import 'models/transaction.dart';

List<TransactionItemRequest> buildTransactionItems(List<OrderLineItem> lines) {
  return lines
      .map(
        (line) => TransactionItemRequest(
          menuId: line.menuId,
          title: line.title,
          quantity: line.quantity,
          unitPrice: line.sellPrice,
          lineTotal: line.lineTotal,
          note: line.note.trim().isEmpty ? null : line.note.trim(),
        ),
      )
      .toList();
}
