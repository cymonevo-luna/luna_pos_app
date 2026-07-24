class MenuDisposal {
  const MenuDisposal({
    required this.id,
    required this.menuTitle,
    required this.quantity,
    required this.lossAmount,
    required this.disposedAt,
  });

  final String id;
  final String menuTitle;
  final int quantity;
  final int lossAmount;
  final DateTime disposedAt;

  factory MenuDisposal.fromJson(Map<String, dynamic> json) {
    return MenuDisposal(
      id: json['id'] as String,
      menuTitle: json['menu_title'] as String,
      quantity: (json['quantity'] as num).toInt(),
      lossAmount: _amountFromJson(json['loss_amount']),
      disposedAt: DateTime.parse(json['disposed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'menu_title': menuTitle,
        'quantity': quantity,
        'loss_amount': lossAmount,
        'disposed_at': disposedAt.toIso8601String(),
      };
}

class CreateMenuDisposalInput {
  const CreateMenuDisposalInput({
    required this.menuId,
    required this.quantity,
    this.note,
  });

  final String menuId;
  final int quantity;
  final String? note;

  factory CreateMenuDisposalInput.fromJson(Map<String, dynamic> json) {
    return CreateMenuDisposalInput(
      menuId: json['menu_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'menu_id': menuId,
      'quantity': quantity,
    };
    if (note != null) {
      json['note'] = note;
    }
    return json;
  }
}

class MenuDisposalListItem {
  const MenuDisposalListItem({
    required this.id,
    required this.menuTitle,
    required this.quantity,
    required this.lossAmount,
    required this.disposedAt,
    this.disposedByUsername,
    this.note,
  });

  final String id;
  final String menuTitle;
  final int quantity;
  final int lossAmount;
  final DateTime disposedAt;
  final String? disposedByUsername;
  final String? note;

  factory MenuDisposalListItem.fromJson(Map<String, dynamic> json) {
    return MenuDisposalListItem(
      id: json['id'] as String,
      menuTitle: json['menu_title'] as String,
      quantity: (json['quantity'] as num).toInt(),
      lossAmount: _amountFromJson(json['loss_amount']),
      disposedAt: DateTime.parse(json['disposed_at'] as String),
      disposedByUsername: json['disposed_by_username'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'menu_title': menuTitle,
        'quantity': quantity,
        'loss_amount': lossAmount,
        'disposed_at': disposedAt.toIso8601String(),
        'disposed_by_username': disposedByUsername,
        'note': note,
      };
}

int _amountFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid amount: $value');
}
