import 'package:travel_frontend/core/base_view_model.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/color_filter.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_container_state.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_list.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_section.dart';

import 'models/filter.dart';

class FiltersViewModel extends BaseViewModel<FiltersContainerState> {
  @override
  FiltersContainerState get initState => FiltersContainerState(
        filtersList: FiltersList(
          atmosphere: FiltersSection.atmosphere,
          persons: FiltersSection.persons,
          dayTime: FiltersSection.dayTime,
          season: FiltersSection.season,
          weather: FiltersSection.weather,
          orientation: FiltersSection.orientation,
          colors: FiltersSection.colors,
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

  void checkSeason(String title) {
    final currentSeasons = state.filtersList.season.filters;

    final targetSeasons = _invertCheckedValue(currentSeasons, title);
    final targetFiltersSection =
        state.filtersList.season.copyWith(filters: targetSeasons);

    final currentSearch = state.search;

    final targetFilters =
        state.filtersList.copyWith(season: targetFiltersSection);

    emit(state.copyWith(search: currentSearch, filtersList: targetFilters));
  }

  void checkWeather(String title) {
    final currentWeather = state.filtersList.weather.filters;

    final targetWeather = _invertCheckedValue(currentWeather, title);
    final targetFiltersSection =
        state.filtersList.weather.copyWith(filters: targetWeather);

    final currentSearch = state.search;

    final targetFilters =
        state.filtersList.copyWith(weather: targetFiltersSection);

    emit(state.copyWith(search: currentSearch, filtersList: targetFilters));
  }

  void checkAtmosphere(String title) {
    final currentAtm = state.filtersList.atmosphere.filters;

    final targetSeasons = _invertCheckedValue(currentAtm, title);
    final targetFiltersSection =
        state.filtersList.atmosphere.copyWith(filters: targetSeasons);

    final currentSearch = state.search;

    final targetFilters =
        state.filtersList.copyWith(atmosphere: targetFiltersSection);

    emit(state.copyWith(search: currentSearch, filtersList: targetFilters));
  }

  void checkPersons(String title) {
    final currentPersons = state.filtersList.persons.filters;

    final targetPersons = _invertCheckedValue(currentPersons, title);
    final targetFiltersSection =
        state.filtersList.persons.copyWith(filters: targetPersons);

    final currentSearch = state.search;

    final targetFilters =
        state.filtersList.copyWith(persons: targetFiltersSection);

    emit(state.copyWith(search: currentSearch, filtersList: targetFilters));
  }

  void checkOrientation(String title) {
    final currentOrientation = state.filtersList.orientation.filters;

    final targetOrientation = _invertCheckedValue(currentOrientation, title);
    final targetFiltersSection =
        state.filtersList.orientation.copyWith(filters: targetOrientation);

    final currentSearch = state.search;

    final targetFilters =
        state.filtersList.copyWith(orientation: targetFiltersSection);

    emit(state.copyWith(search: currentSearch, filtersList: targetFilters));
  }

  void checkColor(String title) {
    final currentColors = state.filtersList.colors.filters;

    final targetColors = _invertCheckedValueColor(currentColors, title);
    final targetFiltersSection =
        state.filtersList.colors.copyWith(filters: targetColors);

    final currentSearch = state.search;

    final targetFilters =
        state.filtersList.copyWith(colors: targetFiltersSection);

    emit(state.copyWith(search: currentSearch, filtersList: targetFilters));
  }

  ImageSearchQuery makeSearchQuery(String controllerText) {
    _changeSearch(controllerText);
    final currentFiltersList = state.filtersList;

    final dayTime = currentFiltersList.dayTime.filters;
    final season = currentFiltersList.season.filters;
    final orientation = currentFiltersList.orientation.filters;
    final weather = currentFiltersList.weather.filters;
    final persons = currentFiltersList.persons.filters;
    final atmosphere = currentFiltersList.atmosphere.filters;
    final colors = currentFiltersList.colors.filters;

    final result = ImageSearchQuery(
      text: state.search,
      dayTime: dayTime.where((el) => el.checked).map((e) => e.title).toList(),
      weather: weather.where((el) => el.checked).map((e) => e.title).toList(),
      season: season.where((el) => el.checked).map((e) => e.title).toList(),
      atmosphere:
          atmosphere.where((el) => el.checked).map((e) => e.title).toList(),
      colors: colors.where((el) => el.checked).map((e) => e.title).toList(),
      persons: persons
          .where((el) => el.checked)
          .map(
            (e) => _mapNumber(e),
          )
          .toList(),
      orientation:
          orientation.where((el) => el.checked).map((e) => e.title).toList(),
      tags: [],
    );

    return result;
  }

  //TODO: fix
  int _mapNumber(Filter filter) {
    if (filter.title == 'Без людей') {
      return 0;
    }
    if (filter.title == 'От 1 до 5') {
      return 1;
    }
    if (filter.title == 'От 5 до 15') {
      return 2;
    }
    if (filter.title == 'От 15') {
      return 3;
    }
    return 0;
  }

  bool get isFiltersChosen {
    return state.filtersList.colors.filters.any((element) => element.checked) ||
        state.filtersList.season.filters.any((element) => element.checked) ||
        state.filtersList.dayTime.filters.any((element) => element.checked) ||
        state.filtersList.weather.filters.any((element) => element.checked) ||
        state.filtersList.atmosphere.filters
            .any((element) => element.checked) ||
        state.filtersList.persons.filters.any((element) => element.checked) ||
        state.filtersList.orientation.filters.any((element) => element.checked);
  }

  List<Filter> _invertCheckedValue(List<Filter> filters, String title) =>
      filters
          .map((filter) => filter.title == title
              ? filter.copyWith(checked: !filter.checked)
              : filter)
          .toList();

  List<ColorsFilter> _invertCheckedValueColor(
          List<ColorsFilter> filters, String title) =>
      filters
          .map((filter) => filter.title == title
              ? filter.copyWith(checked: !filter.checked)
              : filter)
          .toList();

  void _changeSearch(String text) {
    emit(state.copyWith(search: text));
  }
}
