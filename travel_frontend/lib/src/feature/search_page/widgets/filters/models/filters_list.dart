import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_section.dart';

part 'filters_list.freezed.dart';

part 'filters_list.g.dart';

@freezed
class FiltersList with _$FiltersList {
  const factory FiltersList({
    required FiltersSection dayTime,
    required FiltersSection season,
    required FiltersSection weather,
    required FiltersSection atmosphere,
    required FiltersSection persons,
    required FiltersSection orientation,
  }) = _FiltersList;

  factory FiltersList.fromJson(Map<String, Object?> json) =>
      _$FiltersListFromJson(json);
}
