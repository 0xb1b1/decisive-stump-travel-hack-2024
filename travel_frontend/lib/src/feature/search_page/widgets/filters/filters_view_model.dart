import 'package:travel_frontend/core/base_view_model.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_container_state.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_list.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_section.dart';

import 'models/filter.dart';

class FiltersViewModel extends BaseViewModel<FiltersContainerState> {
  @override
  FiltersContainerState get initState => FiltersContainerState(
        filtersList: FiltersList(
          atmosphere: FiltersSection.atmosphere(),
          persons: FiltersSection.persons(),
          dayTime: FiltersSection.dayTime(),
          season: FiltersSection.season(),
          weather: FiltersSection.weather(),
          orientation: FiltersSection.orientation(),
        ),
        search: '',
      );

  @override
  Future<void> init() async {
    super.init();
  }

  void checkDayTime(String title) {
    final currentDayTime = state.filtersList.dayTime.filters;
    final targetDayTime = _invertCheckedValue(currentDayTime, title);

    final targetFiltersSection =
        state.filtersList.dayTime.copyWith(filters: targetDayTime);

    final currentSearch = state.search;
    final targetFilters =
        state.filtersList.copyWith(dayTime: targetFiltersSection);
    emit(state.copyWith(search: currentSearch, filtersList: targetFilters));
  }

  List<Filter> _invertCheckedValue(List<Filter> filters, String title) =>
      filters
          .map((filter) => filter.title == title
              ? filter.copyWith(checked: !filter.checked)
              : filter)
          .toList();
}
