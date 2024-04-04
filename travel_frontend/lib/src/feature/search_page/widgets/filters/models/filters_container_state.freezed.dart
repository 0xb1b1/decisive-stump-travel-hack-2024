// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filters_container_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FiltersContainerState {
  FiltersList get filtersList => throw _privateConstructorUsedError;
  String get search => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FiltersContainerStateCopyWith<FiltersContainerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FiltersContainerStateCopyWith<$Res> {
  factory $FiltersContainerStateCopyWith(FiltersContainerState value,
          $Res Function(FiltersContainerState) then) =
      _$FiltersContainerStateCopyWithImpl<$Res, FiltersContainerState>;
  @useResult
  $Res call({FiltersList filtersList, String search});

  $FiltersListCopyWith<$Res> get filtersList;
}

/// @nodoc
class _$FiltersContainerStateCopyWithImpl<$Res,
        $Val extends FiltersContainerState>
    implements $FiltersContainerStateCopyWith<$Res> {
  _$FiltersContainerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filtersList = null,
    Object? search = null,
  }) {
    return _then(_value.copyWith(
      filtersList: null == filtersList
          ? _value.filtersList
          : filtersList // ignore: cast_nullable_to_non_nullable
              as FiltersList,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FiltersListCopyWith<$Res> get filtersList {
    return $FiltersListCopyWith<$Res>(_value.filtersList, (value) {
      return _then(_value.copyWith(filtersList: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FiltersContainerStateImplCopyWith<$Res>
    implements $FiltersContainerStateCopyWith<$Res> {
  factory _$$FiltersContainerStateImplCopyWith(
          _$FiltersContainerStateImpl value,
          $Res Function(_$FiltersContainerStateImpl) then) =
      __$$FiltersContainerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FiltersList filtersList, String search});

  @override
  $FiltersListCopyWith<$Res> get filtersList;
}

/// @nodoc
class __$$FiltersContainerStateImplCopyWithImpl<$Res>
    extends _$FiltersContainerStateCopyWithImpl<$Res,
        _$FiltersContainerStateImpl>
    implements _$$FiltersContainerStateImplCopyWith<$Res> {
  __$$FiltersContainerStateImplCopyWithImpl(_$FiltersContainerStateImpl _value,
      $Res Function(_$FiltersContainerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filtersList = null,
    Object? search = null,
  }) {
    return _then(_$FiltersContainerStateImpl(
      filtersList: null == filtersList
          ? _value.filtersList
          : filtersList // ignore: cast_nullable_to_non_nullable
              as FiltersList,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FiltersContainerStateImpl implements _FiltersContainerState {
  const _$FiltersContainerStateImpl(
      {required this.filtersList, required this.search});

  @override
  final FiltersList filtersList;
  @override
  final String search;

  @override
  String toString() {
    return 'FiltersContainerState(filtersList: $filtersList, search: $search)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FiltersContainerStateImpl &&
            (identical(other.filtersList, filtersList) ||
                other.filtersList == filtersList) &&
            (identical(other.search, search) || other.search == search));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filtersList, search);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FiltersContainerStateImplCopyWith<_$FiltersContainerStateImpl>
      get copyWith => __$$FiltersContainerStateImplCopyWithImpl<
          _$FiltersContainerStateImpl>(this, _$identity);
}

abstract class _FiltersContainerState implements FiltersContainerState {
  const factory _FiltersContainerState(
      {required final FiltersList filtersList,
      required final String search}) = _$FiltersContainerStateImpl;

  @override
  FiltersList get filtersList;
  @override
  String get search;
  @override
  @JsonKey(ignore: true)
  _$$FiltersContainerStateImplCopyWith<_$FiltersContainerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
