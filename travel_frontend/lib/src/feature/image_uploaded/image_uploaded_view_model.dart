// import 'dart:io';
// import 'package:travel_frontend/core/base_view_model.dart';
// import 'package:travel_frontend/src/api/models/gallery.dart';
// import 'package:travel_frontend/src/feature/image_uploaded/models/image_uploaded_view_state.dart';
// import 'package:travel_frontend/src/navigation/navigation_service.dart';
//
// import '../../domain/search_repository.dart';
//
// class ImageUploadedViewModel extends BaseViewModel<ImageUploadedViewState> {
//   final NavigationService _navigationService;
//   final SearchRepository _searchRepository;
//   final File _uploadedFile;
//
//
//   ImageUploadedViewModel({required NavigationService navigationService, required SearchRepository });
//
//   @override
//   ImageUploadedViewState get initState => const ImageUploadedViewState.data(
//         possibleTags: ['Лето', 'Cолнце', 'Жара'],
//         similarImages: Gallery(
//           images: [],
//         ),
//       );
//
//   Future<void> init() {
//
//   }
// }
