import 'dart:developer' as developer;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/router/pos_features.dart';

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
    @Default(<String>[]) List<String> features,
    String? avatarUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserRoleAccess on User {
  static const cashierRole = 'cashier';
  static const operationalRole = 'operational';
  static const managerRole = 'manager';
  static const cookRole = 'cook';

  bool hasFeature(String key) => _effectiveFeatures.contains(key);

  bool get canAccessPosApp =>
      _effectiveFeatures.any((feature) => feature.startsWith('pos.'));

  List<String> get _effectiveFeatures {
    if (features.isNotEmpty) return features;
    if (roles.isEmpty) return const [];

    developer.log(
      'User $id has roles but no features; using legacy role mapping',
      name: 'UserRoleAccess',
    );
    return _legacyFeaturesFromRoles();
  }

  List<String> _legacyFeaturesFromRoles() {
    final granted = <String>{};
    if (roles.contains(cashierRole)) {
      granted.addAll([
        PosFeatures.menu,
        PosFeatures.transactions,
        PosFeatures.productionRequests,
      ]);
    }
    if (roles.contains(operationalRole)) {
      granted.addAll([
        PosFeatures.stock,
        PosFeatures.purchases,
        PosFeatures.recurringExpenses,
      ]);
    }
    if (roles.contains(managerRole)) {
      granted.add(PosFeatures.recurringExpenses);
    }
    if (roles.contains(cookRole)) {
      // No default features — privileges come from API features[].
    }
    return granted.toList();
  }

  @Deprecated('Use hasFeature with PosFeatures keys instead')
  bool get hasCashierAccess =>
      hasFeature(PosFeatures.menu) ||
      hasFeature(PosFeatures.transactions) ||
      hasFeature(PosFeatures.productionRequests);

  @Deprecated('Use hasFeature with PosFeatures keys instead')
  bool get hasOperationalAccess =>
      hasFeature(PosFeatures.stock) || hasFeature(PosFeatures.purchases);

  @Deprecated('Use hasFeature with PosFeatures keys instead')
  bool get hasManagerAccess => hasFeature(PosFeatures.recurringExpenses) &&
      !hasFeature(PosFeatures.stock) &&
      !hasFeature(PosFeatures.purchases);
}
