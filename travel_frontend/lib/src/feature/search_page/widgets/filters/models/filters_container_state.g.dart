// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filters_container_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FiltersContainerStateImpl _$$FiltersContainerStateImplFromJson(
        Map<String, dynamic> json) =>
    _$FiltersContainerStateImpl(
      filtersList:
          FiltersList.fromJson(json['filtersList'] as Map<String, dynamic>),
      search: json['search'] as String,
    );

Map<String, dynamic> _$$FiltersContainerStateImplToJson(
        _$FiltersContainerStateImpl instance) =>
    <String, dynamic>{
      'filtersList': instance.filtersList,
      'search': instance.search,
    };
