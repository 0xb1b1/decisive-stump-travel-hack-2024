import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/core/base_view_model.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';
import 'package:travel_frontend/src/feature/search_page/models/search_view_state.dart';

import '../../api/models/gallery.dart';
import '../../domain/search_repository.dart';
import '../../navigation/navigation_service.dart';
import '../../navigation/routes.dart';

class SearchPageViewModel extends BaseViewModel<SearchViewState> {
  final ImagePicker _imagePicker;
  final SearchRepository _searchRepository;
  final NavigationService _navigationService;

  SearchPageViewModel({
    required ImagePicker imagePicker,
    required SearchRepository searchRepository,
    required NavigationService navigationService,
  })  : _imagePicker = imagePicker,
        _searchRepository = searchRepository,
        _navigationService = navigationService;

  SearchViewState get loadingState => const SearchViewState.loading();

  SearchViewState get errorState => const SearchViewState.error();

  SearchViewState get emptyState => const SearchViewState.empty();

  @override
  SearchViewState get initState => const SearchViewState.loading();

  @override
  Future<void> init() async {
    super.init();
    try {
      final gallery = await _searchRepository.getGallery();
      emit(SearchViewState.data(images: gallery.images));
    } on Object catch (e, _) {
      emit(errorState);
    }
  }

  Future<void> onImageTap(String filename) async {
    final currentState = state;
    emit(loadingState);
    final image = await _searchRepository.getImage(filename);
    _navigationService.pushNamed(Routes.imageStats, arguments: image);
    emit(currentState);
  }

  Future<void> pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
    }
  }

  void search(ImageSearchQuery query) async {
    emit(loadingState);
    try {
      final result = await _searchRepository.search(query);
      print(query);

      if (result.images.isEmpty) {
        emit(emptyState);
      }
      emit(
        SearchViewState.data(
          images: result.images,
        ),
      );
    } on Object catch (e) {
      print('error');
      print(e);
      emit(errorState);
    }
  }
}
