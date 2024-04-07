import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';

part 'image_uploaded_view_state.freezed.dart';

part 'image_uploaded_view_state.g.dart';

@freezed
class ImageUploadedViewState with _$ImageUploadedViewState {
  const factory ImageUploadedViewState.data({
    required List<String> possibleTags,
    required Gallery similarImages,
  }) = ImageUploadedViewStateData;

  const factory ImageUploadedViewState.loading() =
      ImageUploadedViewStateLoading;

  const factory ImageUploadedViewState.error() = ImageUploadedViewStateError;

  factory ImageUploadedViewState.fromJson(Map<String, Object?> json) =>
      _$ImageUploadedViewStateFromJson(json);
}
