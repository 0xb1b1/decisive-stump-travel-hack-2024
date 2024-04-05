import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';

import '../../../api/models/full_image.dart';

part 'image_stats_view_state.freezed.dart';

part 'image_stats_view_state.g.dart';

@freezed
class ImageStatsViewState with _$ImageStatsViewState {
  const factory ImageStatsViewState.data({
    required FullImage image,
    required Gallery similarImages,
  }) = ImageStatsViewStateData;

  const factory ImageStatsViewState.loading() = ImageStatsViewStateLoading;

  const factory ImageStatsViewState.error() = ImageStatsViewStateError;

  factory ImageStatsViewState.fromJson(Map<String, Object?> json) =>
      _$ImageStatsViewStateFromJson(json);
}
