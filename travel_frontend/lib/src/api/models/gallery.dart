import 'package:freezed_annotation/freezed_annotation.dart';

import 'gallery_image.dart';

part 'gallery.freezed.dart';

part 'gallery.g.dart';

@freezed
class Gallery with _$Gallery {
  const factory Gallery({
    required List<GalleryImage> images,
    String? error,
  }) = _Gallery;

  factory Gallery.fromJson(Map<String, Object?> json) =>
      _$GalleryFromJson(json);
}
