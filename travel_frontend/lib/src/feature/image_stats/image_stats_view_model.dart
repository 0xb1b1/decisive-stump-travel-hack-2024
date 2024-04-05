import 'package:travel_frontend/core/base_view_model.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';
import 'package:travel_frontend/src/domain/search_repository.dart';
import 'package:travel_frontend/src/feature/image_stats/models/image_stats_view_state.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class ImageStatsViewModel extends BaseViewModel<ImageStatsViewState> {
  final String _filename;
  final SearchRepository _searchRepository;

  ImageStatsViewModel({
    required String filename,
    required SearchRepository searchRepository,
  })  : _filename = filename,
        _searchRepository = searchRepository;

  @override
  ImageStatsViewState get initState => const ImageStatsViewState.loading();

  ImageStatsViewState get errorState => const ImageStatsViewState.error();

  ImageStatsViewState get loadingState => const ImageStatsViewState.loading();

  @override
  Future<void> init() async {
    super.init();
    _getImage(_filename);
  }

  void onImageTap(String filename) {
    _getImage(filename);
  }

  Future<void> _getImage(String filename) async {
    emit(loadingState);
    try {
      final image = await _searchRepository.getImage(filename);
      // final similar = await _searchRepository.getSimilar(filename);

      emit(
        ImageStatsViewState.data(
          image: image,
          similarImages: Gallery(images: []),
        ),
      );
    } on Object catch (_) {
      emit(errorState);
    }
  }

  Future<void> onDownloadTap(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Create a blob from the image data
        final blob = html.Blob([response.bodyBytes]);
        // Create a URL for the blob
        final url = html.Url.createObjectUrlFromBlob(blob);
        // Create an anchor element (<a>) and set its href to the blob URL
        final anchor = html.AnchorElement(href: url)
          ..setAttribute(
              "download", "downloadedImage.png") // Set the download filename
          ..click(); // Programmatically click the anchor to trigger the download
        // Cleanup the blob URL
        html.Url.revokeObjectUrl(url);
      } else {
        emit(errorState);
      }
    } catch (e) {
      emit(errorState);
    }
  }
}
