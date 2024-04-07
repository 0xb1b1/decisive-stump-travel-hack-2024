import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/src/api/models/full_image.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';

import '../api/api.dart';
import '../api/models/gallery.dart';
import '../api/models/uploaded_file_response.dart';

class SearchRepository {
  final AppApi _api;

  SearchRepository({required AppApi api}) : _api = api;

  Future<Gallery> getGallery() async {
    print('gallery');
    final result = await _api.getGallery();
    return result;
  }

  Future<Gallery> getNeighbors(
    String filename,
    ImageSearchQuery? query,
    int imagesCount,
  ) async {
    print('neigbors');
    final result = await _api.getNeighbors(filename, query, imagesCount);
    return result;
  }

  Future<UploadedFileResponse> uploadImage(XFile image) async {
    final result = await _api.uploadImage(image);
    return result;
  }

  Future<Gallery> search(ImageSearchQuery query, int imagesCount) async {
    print('search');
    final result = await _api.search(query, imagesCount);
    return result;
  }

  Future<FullImage> getImage(String filename) async {
    final result = await _api.getImage(filename);
    return result;
  }
}
