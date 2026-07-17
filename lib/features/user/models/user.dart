import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Immutable user profile from the merchant auth API.
///
/// Run codegen after changing this file:
/// `dart run build_runner build --delete-conflicting-outputs`
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'merchant_id') required String merchantId,
    @Default(<String>[]) List<String> roles,
    String? avatarUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserRoleAccess on User {
  static const cashierRole = 'cashier';
  static const operationalRole = 'operational';
  static const managerRole = 'manager';

  bool get hasCashierAccess => roles.contains(cashierRole);

  bool get hasOperationalAccess => roles.contains(operationalRole);

  bool get hasManagerAccess => roles.contains(managerRole);

  bool get canAccessPosApp =>
      hasCashierAccess || hasOperationalAccess || hasManagerAccess;
}
