// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filters_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FiltersSection _$FiltersSectionFromJson(Map<String, dynamic> json) {
  return _FiltersSection.fromJson(json);
}

/// @nodoc
mixin _$FiltersSection {
  String get title => throw _privateConstructorUsedError;

  List<Filter> get filters => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FiltersSectionCopyWith<FiltersSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FiltersSectionCopyWith<$Res> {
  factory $FiltersSectionCopyWith(
          FiltersSection value, $Res Function(FiltersSection) then) =
      _$FiltersSectionCopyWithImpl<$Res, FiltersSection>;

  @useResult
  $Res call({String title, List<Filter> filters});
}

/// @nodoc
class _$FiltersSectionCopyWithImpl<$Res, $Val extends FiltersSection>
    implements $FiltersSectionCopyWith<$Res> {
  _$FiltersSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? filters = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<Filter>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FiltersSectionImplCopyWith<$Res>
    implements $FiltersSectionCopyWith<$Res> {
  factory _$$FiltersSectionImplCopyWith(_$FiltersSectionImpl value,
          $Res Function(_$FiltersSectionImpl) then) =
      __$$FiltersSectionImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({String title, List<Filter> filters});
}

/// @nodoc
class __$$FiltersSectionImplCopyWithImpl<$Res>
    extends _$FiltersSectionCopyWithImpl<$Res, _$FiltersSectionImpl>
    implements _$$FiltersSectionImplCopyWith<$Res> {
  __$$FiltersSectionImplCopyWithImpl(
      _$FiltersSectionImpl _value, $Res Function(_$FiltersSectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? filters = null,
  }) {
    return _then(_$FiltersSectionImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<Filter>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FiltersSectionImpl implements _FiltersSection {
  const _$FiltersSectionImpl(
      {required this.title, required final List<Filter> filters})
      : _filters = filters;

  factory _$FiltersSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FiltersSectionImplFromJson(json);

  @override
  final String title;
  final List<Filter> _filters;

  @override
  List<Filter> get filters {
    if (_filters is EqualUnmodifiableListView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filters);
  }

  @override
  String toString() {
    return 'FiltersSection(title: $title, filters: $filters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FiltersSectionImpl &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._filters, _filters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, const DeepCollectionEquality().hash(_filters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FiltersSectionImplCopyWith<_$FiltersSectionImpl> get copyWith =>
      __$$FiltersSectionImplCopyWithImpl<_$FiltersSectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FiltersSectionImplToJson(
      this,
    );
  }
}

abstract class _FiltersSection implements FiltersSection {
  const factory _FiltersSection({
    required final String title,
    required final List<Filter> filters,
  }) = _$FiltersSectionImpl;

  factory _FiltersSection.fromJson(Map<String, dynamic> json) =
      _$FiltersSectionImpl.fromJson;

  @override
  String get title;

  @override
  List<Filter> get filters;

  @override
  @JsonKey(ignore: true)
  _$$FiltersSectionImplCopyWith<_$FiltersSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
