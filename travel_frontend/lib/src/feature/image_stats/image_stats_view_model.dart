import 'package:flutter/cupertino.dart';
import 'package:travel_frontend/core/base_view_model.dart';

import 'package:travel_frontend/src/domain/search_repository.dart';
import 'package:travel_frontend/src/feature/image_stats/models/image_stats_view_state.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_providers.dart';
import 'package:travel_frontend/src/feature/search_page/search_page_providers.dart';

import '../../navigation/navigation_service.dart';
import '../../navigation/routes.dart';

class ImageStatsViewModel extends BaseViewModel<ImageStatsViewState> {
  final String _filename;
  final SearchRepository _searchRepository;
  final NavigationService _navigation;
  final Ref _ref;

  ImageStatsViewModel({
    required String filename,
    required SearchRepository searchRepository,
    required NavigationService navigation,
    required Ref ref,
  })  : _filename = filename,
        _searchRepository = searchRepository,
        _navigation = navigation,
        _ref = ref;

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
      final similar = await _searchRepository.getNeighbors(
        filename,
        null,
        16,
      );

      emit(
        ImageStatsViewState.data(
          image: image,
          similarImages: similar,
        ),
      );
    } on Object catch (_) {
      emit(errorState);
    }
  }

  void searchTag(String tag) {
    final filtersVm = _ref.watch(filtersViewModelProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      filtersVm.changeModeTag(tag);
    });

    _navigation.pushNamed(
      Routes.search,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ref.watch(searchViewModelProvider).search(filtersVm.state);
    });
  }

  Future<void> onDownloadTap(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);

        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        emit(errorState);
      }
    } catch (e) {
      emit(errorState);
    }
  }
}
