import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';
import 'package:travel_frontend/src/domain/search_repository_providers.dart';
import 'package:travel_frontend/src/feature/image_uploaded/image_uploaded_view_model.dart';
import 'package:travel_frontend/src/navigation/navigation_providers.dart';

final imageUploadedViewModelProvider =
    Provider.autoDispose.family<ImageUploadedViewModel, XFile>(
  (ref, file) => ImageUploadedViewModel(
    navigationService: ref.watch(navigationProvider),
    searchRepository: ref.watch(searchRepositoryProvider),
    uploadedFile: file,
  ),
);
