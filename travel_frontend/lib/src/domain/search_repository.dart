import 'package:travel_frontend/src/api/models/full_image.dart';
import 'package:travel_frontend/src/api/models/image_search_query.dart';

import '../api/api.dart';
import '../api/models/gallery.dart';

class SearchRepository {
  final AppApi _api;

  SearchRepository({required AppApi api}) : _api = api;

  Future<Gallery> getGallery() async {
    final result = await _api.getGallery();
    return result;
  }

  Future<Gallery> getNeighbors(
    String filename,
    ImageSearchQuery? query,
    int imagesCount,
  ) async {
    final result = await _api.getNeighbors(filename, query, imagesCount);
    return result;
  }

  Future<void> searchFromUploaded() async {}

  Future<Gallery> search(ImageSearchQuery query) async {
    final result = await _api.search(query);
    return result;
  }

  Future<FullImage> getImage(String filename) async {
    final result = await _api.getImage(filename);
    return result;
  }
}
