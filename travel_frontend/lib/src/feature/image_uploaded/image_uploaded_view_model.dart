import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/core/base_view_model.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';
import 'package:travel_frontend/src/feature/image_uploaded/models/image_uploaded_view_state.dart';
import 'package:travel_frontend/src/navigation/navigation_service.dart';
import 'package:travel_frontend/src/navigation/routes.dart';

import '../../domain/search_repository.dart';

class ImageUploadedViewModel extends BaseViewModel<ImageUploadedViewState> {
  final NavigationService _navigationService;
  final SearchRepository _searchRepository;
  final XFile _uploadedFile;

  ImageUploadedViewModel({
    required NavigationService navigationService,
    required SearchRepository searchRepository,
    required XFile uploadedFile,
  })  : _navigationService = navigationService,
        _searchRepository = searchRepository,
        _uploadedFile = uploadedFile;

  @override
  ImageUploadedViewState get initState =>
      const ImageUploadedViewState.loading();

  @override
  Future<void> init() async {
    super.init();

    try {
      final result = await _searchRepository.uploadImage(_uploadedFile);

      emit(
        ImageUploadedViewState.data(
          file: _uploadedFile,
          possibleTags: result.tags,
          similarImages: result.images,
        ),
      );
    } on Object catch (_) {
      emit(
        const ImageUploadedViewState.error(),
      );
    }
  }

  void onImageTap(String filename) =>
      _navigationService.pushNamed(Routes.imageStats, arguments: {
        RoutesArgs.filename: filename,
      });
}
