import 'package:freezed_annotation/freezed_annotation.dart';

import 'filters_list.dart';

part 'search_type_state.freezed.dart';

@freezed
class SearchTypeState with _$SearchTypeState {
  const factory SearchTypeState.initial({
    required FiltersList filtersList,
    required String search,
  }) = SearchTypeStateInitial;

  const factory SearchTypeState.tag({
    required FiltersList filtersList,
    required String tag,
  }) = SearchTypeStateTag;

  const factory SearchTypeState.similar({
    required FiltersList filtersList,
    required String filename,
  }) = SearchTypeStateSimilar;
}

extension Extension on SearchTypeState {
  bool get isFiltersChosen =>
      filtersList.colors.filters.any((element) => element.checked) ||
      filtersList.season.filters.any((element) => element.checked) ||
      filtersList.dayTime.filters.any((element) => element.checked) ||
      filtersList.weather.filters.any((element) => element.checked) ||
      filtersList.atmosphere.filters.any((element) => element.checked) ||
      filtersList.persons.filters.any((element) => element.checked) ||
      filtersList.orientation.filters.any((element) => element.checked);
}

enum SearchTypeMode {
  initial,
  tag,
  similar,
}
