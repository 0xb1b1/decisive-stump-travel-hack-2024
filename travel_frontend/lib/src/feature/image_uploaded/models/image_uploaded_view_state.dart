import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_frontend/src/api/models/gallery.dart';
import 'package:travel_frontend/src/api/models/gallery_image.dart';

part 'image_uploaded_view_state.freezed.dart';

@freezed
class ImageUploadedViewState with _$ImageUploadedViewState {
  const factory ImageUploadedViewState.data({
    required XFile file,
    required List<String> possibleTags,
    required List<GalleryImage> similarImages,
  }) = ImageUploadedViewStateData;

  const factory ImageUploadedViewState.loading() =
      ImageUploadedViewStateLoading;

  const factory ImageUploadedViewState.error() = ImageUploadedViewStateError;
}
