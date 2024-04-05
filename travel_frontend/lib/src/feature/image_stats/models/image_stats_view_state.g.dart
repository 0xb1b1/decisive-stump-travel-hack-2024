// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_stats_view_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageStatsViewStateDataImpl _$$ImageStatsViewStateDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageStatsViewStateDataImpl(
      image: FullImage.fromJson(json['image'] as Map<String, dynamic>),
      similarImages:
          Gallery.fromJson(json['similarImages'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ImageStatsViewStateDataImplToJson(
        _$ImageStatsViewStateDataImpl instance) =>
    <String, dynamic>{
      'image': instance.image,
      'similarImages': instance.similarImages,
      'runtimeType': instance.$type,
    };

_$ImageStatsViewStateLoadingImpl _$$ImageStatsViewStateLoadingImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageStatsViewStateLoadingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ImageStatsViewStateLoadingImplToJson(
        _$ImageStatsViewStateLoadingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$ImageStatsViewStateErrorImpl _$$ImageStatsViewStateErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageStatsViewStateErrorImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ImageStatsViewStateErrorImplToJson(
        _$ImageStatsViewStateErrorImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };
