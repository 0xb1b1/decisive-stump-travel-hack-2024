// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GalleryImageImpl _$$GalleryImageImplFromJson(Map<String, dynamic> json) =>
    _$GalleryImageImpl(
      filename: json['filename'] as String,
      url: S3Urls.fromJson(json['s3_presigned_urls'] as Map<String, dynamic>),
      label: json['label'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$GalleryImageImplToJson(_$GalleryImageImpl instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      's3_presigned_urls': instance.url,
      'label': instance.label,
      'tags': instance.tags,
    };
