import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filter.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_section.dart';
import 'color_filter.dart';

part 'filters_list.freezed.dart';

@freezed
class FiltersList with _$FiltersList {
  const factory FiltersList({
    required FiltersSection<Filter> dayTime,
    required FiltersSection<Filter> season,
    required FiltersSection<Filter> weather,
    required FiltersSection<Filter> atmosphere,
    required FiltersSection<Filter> persons,
    required FiltersSection<Filter> orientation,
    required FiltersSection<ColorsFilter> colors,
  }) = _FiltersList;
}
