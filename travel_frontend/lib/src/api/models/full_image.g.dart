// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FullImageImpl _$$FullImageImplFromJson(Map<String, dynamic> json) =>
    _$FullImageImpl(
      filename: json['filename'] as String,
      url: S3Urls.fromJson(json['s3_presigned_urls'] as Map<String, dynamic>),
      label: json['label'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      viewsCount: json['view_count'] as int?,
      downloadsCount: json['download_count'] as int?,
    );

Map<String, dynamic> _$$FullImageImplToJson(_$FullImageImpl instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      's3_presigned_urls': instance.url,
      'label': instance.label,
      'tags': instance.tags,
      'view_count': instance.viewsCount,
      'download_count': instance.downloadsCount,
    };
