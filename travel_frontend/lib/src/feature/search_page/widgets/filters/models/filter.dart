import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter.freezed.dart';

part 'filter.g.dart';

@freezed
class Filter with _$Filter {
  const factory Filter({
    required bool checked,
    required String title,
  }) = _Filter;

  factory Filter.initial({required String title}) => Filter(
        checked: false,
        title: title,
      );

  factory Filter.fromJson(Map<String, Object?> json) => _$FilterFromJson(json);
}
