import 'package:riverpod/riverpod.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';
import 'package:travel_frontend/src/domain/search_repository_providers.dart';
import 'package:travel_frontend/src/feature/search_page/search_page_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/src/navigation/navigation_providers.dart';

final searchViewModelProvider =
    Provider.autoDispose.family<SearchPageViewModel, ImageSearchQuery?>(
  (ref, query) => SearchPageViewModel(
    imagePicker: ref.watch(imagePickerProvider),
    searchRepository: ref.watch(searchRepositoryProvider),
    navigationService: ref.watch(navigationProvider),
    initialSearch: query,
  ),
);

final imagePickerProvider = Provider(
  (ref) => ImagePicker(),
);
