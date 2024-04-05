import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_frontend/src/domain/search_repository_providers.dart';
import 'package:travel_frontend/src/feature/image_stats/image_stats_view_model.dart';

final imageStatsViewModelProvider =
    Provider.autoDispose.family<ImageStatsViewModel, String>(
  (ref, filename) => ImageStatsViewModel(
    filename: filename,
    searchRepository: ref.watch(searchRepositoryProvider),
  ),
);
