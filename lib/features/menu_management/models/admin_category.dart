import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_category.freezed.dart';
part 'admin_category.g.dart';

@freezed
abstract class AdminCategory with _$AdminCategory {
  const factory AdminCategory({
    required String id,
    required String name,
    int? priority,
  }) = _AdminCategory;

  factory AdminCategory.fromJson(Map<String, dynamic> json) =>
      _$AdminCategoryFromJson(json);
}
