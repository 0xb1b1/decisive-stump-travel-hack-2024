import 'package:travel_frontend/core/base_view_model.dart';

import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/color_filter.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_list.dart';

import 'models/filter.dart';
import 'models/search_type_state.dart';

class FiltersViewModel extends BaseViewModel<SearchTypeState> {
  @override
  SearchTypeState get initState => SearchTypeState.initial(
        filtersList: FiltersList.initial(),
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

    final targetFilters =
        state.filtersList.copyWith(dayTime: targetFiltersSection);

    emit(state.copyWith(filtersList: targetFilters));
  }

  void checkSeason(String title) {
    final currentSeasons = state.filtersList.season.filters;

    final targetSeasons = _invertCheckedValue(currentSeasons, title);
    final targetFiltersSection =
        state.filtersList.season.copyWith(filters: targetSeasons);

    final targetFilters =
        state.filtersList.copyWith(season: targetFiltersSection);

    emit(state.copyWith(filtersList: targetFilters));
  }

  void checkWeather(String title) {
    final currentWeather = state.filtersList.weather.filters;

    final targetWeather = _invertCheckedValue(currentWeather, title);
    final targetFiltersSection =
        state.filtersList.weather.copyWith(filters: targetWeather);

    final targetFilters =
        state.filtersList.copyWith(weather: targetFiltersSection);

    emit(state.copyWith(filtersList: targetFilters));
  }

  void checkAtmosphere(String title) {
    final currentAtm = state.filtersList.atmosphere.filters;

    final targetSeasons = _invertCheckedValue(currentAtm, title);
    final targetFiltersSection =
        state.filtersList.atmosphere.copyWith(filters: targetSeasons);

    final targetFilters =
        state.filtersList.copyWith(atmosphere: targetFiltersSection);

    emit(state.copyWith(filtersList: targetFilters));
  }

  void checkPersons(String title) {
    final currentPersons = state.filtersList.persons.filters;

    final targetPersons = _invertCheckedValue(currentPersons, title);
    final targetFiltersSection =
        state.filtersList.persons.copyWith(filters: targetPersons);

    final targetFilters =
        state.filtersList.copyWith(persons: targetFiltersSection);

    emit(state.copyWith(filtersList: targetFilters));
  }

  void checkOrientation(String title) {
    final currentOrientation = state.filtersList.orientation.filters;

    final targetOrientation = _invertCheckedValue(currentOrientation, title);
    final targetFiltersSection =
        state.filtersList.orientation.copyWith(filters: targetOrientation);

    final targetFilters =
        state.filtersList.copyWith(orientation: targetFiltersSection);

    emit(state.copyWith(filtersList: targetFilters));
  }

  void checkColor(String title) {
    final currentColors = state.filtersList.colors.filters;

    final targetColors = _invertCheckedValueColor(currentColors, title);
    final targetFiltersSection =
        state.filtersList.colors.copyWith(filters: targetColors);

    final targetFilters =
        state.filtersList.copyWith(colors: targetFiltersSection);

    emit(state.copyWith(filtersList: targetFilters));
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

  void _resetFilters() => emit(
        state.copyWith(
          filtersList: FiltersList.initial(),
        ),
      );

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

  void changeModeSimilar(String filename) {
    if (isFiltersChosen) {
      _resetFilters();
    }
    emit(
      SearchTypeState.similar(
        filtersList: state.filtersList,
        filename: filename,
      ),
    );
  }

  void changeSearchInitial(String controllerText) {
    final currentState = state;
    if (currentState is SearchTypeStateInitial) {
      emit(currentState.copyWith(search: controllerText));
    }
  }

  void changeModeTag(String tag) {
    if (isFiltersChosen) {
      _resetFilters();
    }

    emit(
      SearchTypeState.tag(
        filtersList: state.filtersList,
        tag: tag,
      ),
    );
  }

  void onCrossTap() {
    emit(
      SearchTypeState.initial(
        filtersList: FiltersList.initial(),
        search: '',
      ),
    );
  }
}
