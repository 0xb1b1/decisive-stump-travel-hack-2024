// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchViewStateDataImpl _$$SearchViewStateDataImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchViewStateDataImpl(
      images: (json['images'] as List<dynamic>)
          .map((e) => GalleryImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SearchViewStateDataImplToJson(
        _$SearchViewStateDataImpl instance) =>
    <String, dynamic>{
      'images': instance.images,
      'runtimeType': instance.$type,
    };

_$SearchViewStateDataLoadingImpl _$$SearchViewStateDataLoadingImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchViewStateDataLoadingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SearchViewStateDataLoadingImplToJson(
        _$SearchViewStateDataLoadingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$SearchViewStateErrorImpl _$$SearchViewStateErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchViewStateErrorImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SearchViewStateErrorImplToJson(
        _$SearchViewStateErrorImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };
