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

/// @nodoc
mixin _$FiltersSection<T> {
  String get title => throw _privateConstructorUsedError;
  List<T> get filters => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FiltersSectionCopyWith<T, FiltersSection<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FiltersSectionCopyWith<T, $Res> {
  factory $FiltersSectionCopyWith(
          FiltersSection<T> value, $Res Function(FiltersSection<T>) then) =
      _$FiltersSectionCopyWithImpl<T, $Res, FiltersSection<T>>;
  @useResult
  $Res call({String title, List<T> filters});
}

/// @nodoc
class _$FiltersSectionCopyWithImpl<T, $Res, $Val extends FiltersSection<T>>
    implements $FiltersSectionCopyWith<T, $Res> {
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
              as List<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FiltersSectionImplCopyWith<T, $Res>
    implements $FiltersSectionCopyWith<T, $Res> {
  factory _$$FiltersSectionImplCopyWith(_$FiltersSectionImpl<T> value,
          $Res Function(_$FiltersSectionImpl<T>) then) =
      __$$FiltersSectionImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String title, List<T> filters});
}

/// @nodoc
class __$$FiltersSectionImplCopyWithImpl<T, $Res>
    extends _$FiltersSectionCopyWithImpl<T, $Res, _$FiltersSectionImpl<T>>
    implements _$$FiltersSectionImplCopyWith<T, $Res> {
  __$$FiltersSectionImplCopyWithImpl(_$FiltersSectionImpl<T> _value,
      $Res Function(_$FiltersSectionImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? filters = null,
  }) {
    return _then(_$FiltersSectionImpl<T>(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$FiltersSectionImpl<T> implements _FiltersSection<T> {
  const _$FiltersSectionImpl(
      {required this.title, required final List<T> filters})
      : _filters = filters;

  @override
  final String title;
  final List<T> _filters;
  @override
  List<T> get filters {
    if (_filters is EqualUnmodifiableListView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filters);
  }

  @override
  String toString() {
    return 'FiltersSection<$T>(title: $title, filters: $filters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FiltersSectionImpl<T> &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._filters, _filters));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, const DeepCollectionEquality().hash(_filters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FiltersSectionImplCopyWith<T, _$FiltersSectionImpl<T>> get copyWith =>
      __$$FiltersSectionImplCopyWithImpl<T, _$FiltersSectionImpl<T>>(
          this, _$identity);
}

abstract class _FiltersSection<T> implements FiltersSection<T> {
  const factory _FiltersSection(
      {required final String title,
      required final List<T> filters}) = _$FiltersSectionImpl<T>;

  @override
  String get title;
  @override
  List<T> get filters;
  @override
  @JsonKey(ignore: true)
  _$$FiltersSectionImplCopyWith<T, _$FiltersSectionImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
