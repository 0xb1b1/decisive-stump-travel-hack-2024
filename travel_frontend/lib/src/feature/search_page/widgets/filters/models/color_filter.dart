import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_filter.freezed.dart';

@freezed
class ColorsFilter with _$ColorsFilter {
  const factory ColorsFilter({
    required bool checked,
    required String title,
    required Color color,
  }) = _ColorsFilter;
}
