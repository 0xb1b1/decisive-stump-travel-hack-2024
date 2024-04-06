import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/core/base_view_model.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';
import 'package:travel_frontend/src/feature/search_page/models/search_view_state.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filter.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/search_type_state.dart';

import '../../api/models/gallery.dart';
import '../../domain/search_repository.dart';
import '../../navigation/navigation_service.dart';
import '../../navigation/routes.dart';

class SearchPageViewModel extends BaseViewModel<SearchViewState> {
  final ImagePicker _imagePicker;
  final SearchRepository _searchRepository;
  final NavigationService _navigationService;
  final ImageSearchQuery? _initialSearch;

  SearchPageViewModel({
    required ImagePicker imagePicker,
    required SearchRepository searchRepository,
    required NavigationService navigationService,
    required ImageSearchQuery? initialSearch,
  })  : _imagePicker = imagePicker,
        _searchRepository = searchRepository,
        _navigationService = navigationService,
        _initialSearch = initialSearch;

  SearchViewState get loadingState => const SearchViewState.loading();

  SearchViewState get errorState => const SearchViewState.error();

  SearchViewState get emptyState => const SearchViewState.empty();

  @override
  SearchViewState get initState => const SearchViewState.loading();

  @override
  Future<void> init() async {
    super.init();

    if (_initialSearch != null) {
      try {
        final gallery = await _searchRepository.search(_initialSearch, 20);
        if (gallery.images.isEmpty) {
          emit(emptyState);
          return;
        }
        emit(SearchViewState.data(images: gallery.images));
      } on Object catch (e, _) {
        emit(errorState);
      }
      return;
    }

    try {
      final gallery = await _searchRepository.getGallery();
      if (gallery.images.isEmpty) {
        emit(emptyState);
        return;
      }
      emit(SearchViewState.data(images: gallery.images));
    } on Object catch (e, _) {
      emit(errorState);
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  void onImageTap(String filename) {
    _navigationService.pushNamed(
      Routes.imageStats,
      arguments: {
        RoutesArgs.filename: filename,
      },
    );
    // dispose();
  }

  Future<void> _searchTag(ImageSearchQuery query) async {
    try {
      final result = await _searchRepository.search(query, 20);

      if (result.images.isEmpty) {
        emit(emptyState);
        return;
      }
      emit(
        SearchViewState.data(
          images: result.images,
        ),
      );
    } on Object catch (e) {
      emit(errorState);
    }
  }

  Future<void> _searchInitial(ImageSearchQuery query) async {
    try {
      final result = await _searchRepository.getGallery();

      if (result.images.isEmpty) {
        emit(emptyState);
        return;
      }
      emit(
        SearchViewState.data(
          images: result.images,
        ),
      );
    } on Object catch (e) {
      emit(errorState);
    }
  }

  Future<void> _searchSimilar(
    String filename,
    ImageSearchQuery query,
    int imagesCount,
  ) async {
    try {
      final result =
          await _searchRepository.getNeighbors(filename, query, imagesCount);

      if (result.images.isEmpty) {
        emit(emptyState);
        return;
      }
      emit(
        SearchViewState.data(
          images: result.images,
        ),
      );
    } on Object catch (e) {
      emit(errorState);
    }
  }

  void search(SearchTypeState search) async {
    emit(loadingState);

    final currentState = search;

    if (currentState is SearchTypeStateInitial) {
      print('search');
      final query = _makeInitialQuery(currentState);
      await _searchInitial(query);
      return;
    }

    if (currentState is SearchTypeStateTag) {
      final query = _makeTagQuery(currentState);
      await _searchTag(query);
      return;
    }

    if (currentState is SearchTypeStateSimilar) {
      final query = _makeQueryWithFilters(currentState);
      await _searchSimilar(currentState.filename, query, 30);
      return;
    }
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

  ImageSearchQuery _makeQueryWithFilters(SearchTypeState state) {
    final currentFiltersList = state.filtersList;

    final dayTime = currentFiltersList.dayTime.filters;
    final season = currentFiltersList.season.filters;
    final orientation = currentFiltersList.orientation.filters;
    final weather = currentFiltersList.weather.filters;
    final persons = currentFiltersList.persons.filters;
    final atmosphere = currentFiltersList.atmosphere.filters;
    final colors = currentFiltersList.colors.filters;

    final result = ImageSearchQuery(
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
    );

    return result;
  }

  ImageSearchQuery _makeInitialQuery(SearchTypeStateInitial state) {
    final filtersQuery = _makeQueryWithFilters(state);

    return filtersQuery.copyWith(text: state.search);
  }

  ImageSearchQuery _makeTagQuery(SearchTypeStateTag state) {
    final filtersQuery = _makeQueryWithFilters(state);

    return filtersQuery.copyWith(tags: [state.tag]);
  }
}
