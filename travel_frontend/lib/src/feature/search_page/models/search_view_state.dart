import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';

part 'search_view_state.freezed.dart';

part 'search_view_state.g.dart';

@freezed
class SearchViewState with _$SearchViewState {
  const factory SearchViewState.data({
    required List<GalleryImage> images,
  }) = SearchViewStateData;

  const factory SearchViewState.loading() = SearchViewStateDataLoading;

  const factory SearchViewState.error() = SearchViewStateError;

  factory SearchViewState.fromJson(Map<String, Object?> json) =>
      _$SearchViewStateFromJson(json);
}
