import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/core/base_view_model.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';
import 'package:travel_frontend/src/feature/search_page/models/search_view_state.dart';

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

  @override
  SearchViewState get initState => SearchViewState.data(
        images: List.generate(
          23,
          (index) => GalleryImage.mock(),
        ),
      );

  @override
  void init() {
    super.init();
  }

  void changeGallery() {
    final currentState = state;
    if (currentState is! SearchViewStateData) {
      return;
    }

    final targetState = currentState.copyWith(
      images: [GalleryImage.mock()],
    );
    emit(targetState);
  }

  void onImageTap(String uuid) =>
      _navigationService.pushNamed(Routes.imageStats, arguments: uuid);

  Future<void> pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
    }
  }
}
