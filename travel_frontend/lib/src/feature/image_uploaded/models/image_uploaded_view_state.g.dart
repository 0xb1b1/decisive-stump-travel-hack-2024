// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_uploaded_view_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageUploadedViewStateDataImpl _$$ImageUploadedViewStateDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageUploadedViewStateDataImpl(
      possibleTags: (json['possibleTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      similarImages:
          Gallery.fromJson(json['similarImages'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ImageUploadedViewStateDataImplToJson(
        _$ImageUploadedViewStateDataImpl instance) =>
    <String, dynamic>{
      'possibleTags': instance.possibleTags,
      'similarImages': instance.similarImages,
      'runtimeType': instance.$type,
    };

_$ImageUploadedViewStateLoadingImpl
    _$$ImageUploadedViewStateLoadingImplFromJson(Map<String, dynamic> json) =>
        _$ImageUploadedViewStateLoadingImpl(
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$ImageUploadedViewStateLoadingImplToJson(
        _$ImageUploadedViewStateLoadingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$ImageUploadedViewStateErrorImpl _$$ImageUploadedViewStateErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageUploadedViewStateErrorImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ImageUploadedViewStateErrorImplToJson(
        _$ImageUploadedViewStateErrorImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };
