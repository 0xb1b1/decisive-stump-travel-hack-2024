import '../api/api.dart';
import '../api/models/gallery.dart';

class SearchRepository {
  final AppApi _api;

  SearchRepository({required AppApi api}) : _api = api;

  Future<Gallery> getGallery() async {
    try {
      final result = await _api.getGallery();
      return result;
    } on Object catch (_) {
      return const Gallery(images: []);
    }
  }
}
