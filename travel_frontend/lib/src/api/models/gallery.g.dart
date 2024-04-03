// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GalleryImpl _$$GalleryImplFromJson(Map<String, dynamic> json) =>
    _$GalleryImpl(
      images: (json['images'] as List<dynamic>)
          .map((e) => GalleryImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$GalleryImplToJson(_$GalleryImpl instance) =>
    <String, dynamic>{
      'images': instance.images,
      'error': instance.error,
    };
