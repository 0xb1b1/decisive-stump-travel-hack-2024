// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_type_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchTypeState {
  FiltersList get filtersList => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FiltersList filtersList, String search) initial,
    required TResult Function(FiltersList filtersList, String tag) tag,
    required TResult Function(FiltersList filtersList, String filename) similar,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FiltersList filtersList, String search)? initial,
    TResult? Function(FiltersList filtersList, String tag)? tag,
    TResult? Function(FiltersList filtersList, String filename)? similar,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FiltersList filtersList, String search)? initial,
    TResult Function(FiltersList filtersList, String tag)? tag,
    TResult Function(FiltersList filtersList, String filename)? similar,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchTypeStateInitial value) initial,
    required TResult Function(SearchTypeStateTag value) tag,
    required TResult Function(SearchTypeStateSimilar value) similar,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchTypeStateInitial value)? initial,
    TResult? Function(SearchTypeStateTag value)? tag,
    TResult? Function(SearchTypeStateSimilar value)? similar,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchTypeStateInitial value)? initial,
    TResult Function(SearchTypeStateTag value)? tag,
    TResult Function(SearchTypeStateSimilar value)? similar,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchTypeStateCopyWith<SearchTypeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchTypeStateCopyWith<$Res> {
  factory $SearchTypeStateCopyWith(
          SearchTypeState value, $Res Function(SearchTypeState) then) =
      _$SearchTypeStateCopyWithImpl<$Res, SearchTypeState>;
  @useResult
  $Res call({FiltersList filtersList});

  $FiltersListCopyWith<$Res> get filtersList;
}

/// @nodoc
class _$SearchTypeStateCopyWithImpl<$Res, $Val extends SearchTypeState>
    implements $SearchTypeStateCopyWith<$Res> {
  _$SearchTypeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filtersList = null,
  }) {
    return _then(_value.copyWith(
      filtersList: null == filtersList
          ? _value.filtersList
          : filtersList // ignore: cast_nullable_to_non_nullable
              as FiltersList,
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
abstract class _$$SearchTypeStateInitialImplCopyWith<$Res>
    implements $SearchTypeStateCopyWith<$Res> {
  factory _$$SearchTypeStateInitialImplCopyWith(
          _$SearchTypeStateInitialImpl value,
          $Res Function(_$SearchTypeStateInitialImpl) then) =
      __$$SearchTypeStateInitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FiltersList filtersList, String search});

  @override
  $FiltersListCopyWith<$Res> get filtersList;
}

/// @nodoc
class __$$SearchTypeStateInitialImplCopyWithImpl<$Res>
    extends _$SearchTypeStateCopyWithImpl<$Res, _$SearchTypeStateInitialImpl>
    implements _$$SearchTypeStateInitialImplCopyWith<$Res> {
  __$$SearchTypeStateInitialImplCopyWithImpl(
      _$SearchTypeStateInitialImpl _value,
      $Res Function(_$SearchTypeStateInitialImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filtersList = null,
    Object? search = null,
  }) {
    return _then(_$SearchTypeStateInitialImpl(
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

class _$SearchTypeStateInitialImpl implements SearchTypeStateInitial {
  const _$SearchTypeStateInitialImpl(
      {required this.filtersList, required this.search});

  @override
  final FiltersList filtersList;
  @override
  final String search;

  @override
  String toString() {
    return 'SearchTypeState.initial(filtersList: $filtersList, search: $search)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchTypeStateInitialImpl &&
            (identical(other.filtersList, filtersList) ||
                other.filtersList == filtersList) &&
            (identical(other.search, search) || other.search == search));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filtersList, search);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchTypeStateInitialImplCopyWith<_$SearchTypeStateInitialImpl>
      get copyWith => __$$SearchTypeStateInitialImplCopyWithImpl<
          _$SearchTypeStateInitialImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FiltersList filtersList, String search) initial,
    required TResult Function(FiltersList filtersList, String tag) tag,
    required TResult Function(FiltersList filtersList, String filename) similar,
  }) {
    return initial(filtersList, search);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FiltersList filtersList, String search)? initial,
    TResult? Function(FiltersList filtersList, String tag)? tag,
    TResult? Function(FiltersList filtersList, String filename)? similar,
  }) {
    return initial?.call(filtersList, search);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FiltersList filtersList, String search)? initial,
    TResult Function(FiltersList filtersList, String tag)? tag,
    TResult Function(FiltersList filtersList, String filename)? similar,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(filtersList, search);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchTypeStateInitial value) initial,
    required TResult Function(SearchTypeStateTag value) tag,
    required TResult Function(SearchTypeStateSimilar value) similar,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchTypeStateInitial value)? initial,
    TResult? Function(SearchTypeStateTag value)? tag,
    TResult? Function(SearchTypeStateSimilar value)? similar,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchTypeStateInitial value)? initial,
    TResult Function(SearchTypeStateTag value)? tag,
    TResult Function(SearchTypeStateSimilar value)? similar,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SearchTypeStateInitial implements SearchTypeState {
  const factory SearchTypeStateInitial(
      {required final FiltersList filtersList,
      required final String search}) = _$SearchTypeStateInitialImpl;

  @override
  FiltersList get filtersList;
  String get search;
  @override
  @JsonKey(ignore: true)
  _$$SearchTypeStateInitialImplCopyWith<_$SearchTypeStateInitialImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchTypeStateTagImplCopyWith<$Res>
    implements $SearchTypeStateCopyWith<$Res> {
  factory _$$SearchTypeStateTagImplCopyWith(_$SearchTypeStateTagImpl value,
          $Res Function(_$SearchTypeStateTagImpl) then) =
      __$$SearchTypeStateTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FiltersList filtersList, String tag});

  @override
  $FiltersListCopyWith<$Res> get filtersList;
}

/// @nodoc
class __$$SearchTypeStateTagImplCopyWithImpl<$Res>
    extends _$SearchTypeStateCopyWithImpl<$Res, _$SearchTypeStateTagImpl>
    implements _$$SearchTypeStateTagImplCopyWith<$Res> {
  __$$SearchTypeStateTagImplCopyWithImpl(_$SearchTypeStateTagImpl _value,
      $Res Function(_$SearchTypeStateTagImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filtersList = null,
    Object? tag = null,
  }) {
    return _then(_$SearchTypeStateTagImpl(
      filtersList: null == filtersList
          ? _value.filtersList
          : filtersList // ignore: cast_nullable_to_non_nullable
              as FiltersList,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchTypeStateTagImpl implements SearchTypeStateTag {
  const _$SearchTypeStateTagImpl(
      {required this.filtersList, required this.tag});

  @override
  final FiltersList filtersList;
  @override
  final String tag;

  @override
  String toString() {
    return 'SearchTypeState.tag(filtersList: $filtersList, tag: $tag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchTypeStateTagImpl &&
            (identical(other.filtersList, filtersList) ||
                other.filtersList == filtersList) &&
            (identical(other.tag, tag) || other.tag == tag));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filtersList, tag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchTypeStateTagImplCopyWith<_$SearchTypeStateTagImpl> get copyWith =>
      __$$SearchTypeStateTagImplCopyWithImpl<_$SearchTypeStateTagImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FiltersList filtersList, String search) initial,
    required TResult Function(FiltersList filtersList, String tag) tag,
    required TResult Function(FiltersList filtersList, String filename) similar,
  }) {
    return tag(filtersList, this.tag);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FiltersList filtersList, String search)? initial,
    TResult? Function(FiltersList filtersList, String tag)? tag,
    TResult? Function(FiltersList filtersList, String filename)? similar,
  }) {
    return tag?.call(filtersList, this.tag);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FiltersList filtersList, String search)? initial,
    TResult Function(FiltersList filtersList, String tag)? tag,
    TResult Function(FiltersList filtersList, String filename)? similar,
    required TResult orElse(),
  }) {
    if (tag != null) {
      return tag(filtersList, this.tag);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchTypeStateInitial value) initial,
    required TResult Function(SearchTypeStateTag value) tag,
    required TResult Function(SearchTypeStateSimilar value) similar,
  }) {
    return tag(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchTypeStateInitial value)? initial,
    TResult? Function(SearchTypeStateTag value)? tag,
    TResult? Function(SearchTypeStateSimilar value)? similar,
  }) {
    return tag?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchTypeStateInitial value)? initial,
    TResult Function(SearchTypeStateTag value)? tag,
    TResult Function(SearchTypeStateSimilar value)? similar,
    required TResult orElse(),
  }) {
    if (tag != null) {
      return tag(this);
    }
    return orElse();
  }
}

abstract class SearchTypeStateTag implements SearchTypeState {
  const factory SearchTypeStateTag(
      {required final FiltersList filtersList,
      required final String tag}) = _$SearchTypeStateTagImpl;

  @override
  FiltersList get filtersList;
  String get tag;
  @override
  @JsonKey(ignore: true)
  _$$SearchTypeStateTagImplCopyWith<_$SearchTypeStateTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchTypeStateSimilarImplCopyWith<$Res>
    implements $SearchTypeStateCopyWith<$Res> {
  factory _$$SearchTypeStateSimilarImplCopyWith(
          _$SearchTypeStateSimilarImpl value,
          $Res Function(_$SearchTypeStateSimilarImpl) then) =
      __$$SearchTypeStateSimilarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FiltersList filtersList, String filename});

  @override
  $FiltersListCopyWith<$Res> get filtersList;
}

/// @nodoc
class __$$SearchTypeStateSimilarImplCopyWithImpl<$Res>
    extends _$SearchTypeStateCopyWithImpl<$Res, _$SearchTypeStateSimilarImpl>
    implements _$$SearchTypeStateSimilarImplCopyWith<$Res> {
  __$$SearchTypeStateSimilarImplCopyWithImpl(
      _$SearchTypeStateSimilarImpl _value,
      $Res Function(_$SearchTypeStateSimilarImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filtersList = null,
    Object? filename = null,
  }) {
    return _then(_$SearchTypeStateSimilarImpl(
      filtersList: null == filtersList
          ? _value.filtersList
          : filtersList // ignore: cast_nullable_to_non_nullable
              as FiltersList,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchTypeStateSimilarImpl implements SearchTypeStateSimilar {
  const _$SearchTypeStateSimilarImpl(
      {required this.filtersList, required this.filename});

  @override
  final FiltersList filtersList;
  @override
  final String filename;

  @override
  String toString() {
    return 'SearchTypeState.similar(filtersList: $filtersList, filename: $filename)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchTypeStateSimilarImpl &&
            (identical(other.filtersList, filtersList) ||
                other.filtersList == filtersList) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filtersList, filename);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchTypeStateSimilarImplCopyWith<_$SearchTypeStateSimilarImpl>
      get copyWith => __$$SearchTypeStateSimilarImplCopyWithImpl<
          _$SearchTypeStateSimilarImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FiltersList filtersList, String search) initial,
    required TResult Function(FiltersList filtersList, String tag) tag,
    required TResult Function(FiltersList filtersList, String filename) similar,
  }) {
    return similar(filtersList, filename);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FiltersList filtersList, String search)? initial,
    TResult? Function(FiltersList filtersList, String tag)? tag,
    TResult? Function(FiltersList filtersList, String filename)? similar,
  }) {
    return similar?.call(filtersList, filename);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FiltersList filtersList, String search)? initial,
    TResult Function(FiltersList filtersList, String tag)? tag,
    TResult Function(FiltersList filtersList, String filename)? similar,
    required TResult orElse(),
  }) {
    if (similar != null) {
      return similar(filtersList, filename);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchTypeStateInitial value) initial,
    required TResult Function(SearchTypeStateTag value) tag,
    required TResult Function(SearchTypeStateSimilar value) similar,
  }) {
    return similar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchTypeStateInitial value)? initial,
    TResult? Function(SearchTypeStateTag value)? tag,
    TResult? Function(SearchTypeStateSimilar value)? similar,
  }) {
    return similar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchTypeStateInitial value)? initial,
    TResult Function(SearchTypeStateTag value)? tag,
    TResult Function(SearchTypeStateSimilar value)? similar,
    required TResult orElse(),
  }) {
    if (similar != null) {
      return similar(this);
    }
    return orElse();
  }
}

abstract class SearchTypeStateSimilar implements SearchTypeState {
  const factory SearchTypeStateSimilar(
      {required final FiltersList filtersList,
      required final String filename}) = _$SearchTypeStateSimilarImpl;

  @override
  FiltersList get filtersList;
  String get filename;
  @override
  @JsonKey(ignore: true)
  _$$SearchTypeStateSimilarImplCopyWith<_$SearchTypeStateSimilarImpl>
      get copyWith => throw _privateConstructorUsedError;
}
