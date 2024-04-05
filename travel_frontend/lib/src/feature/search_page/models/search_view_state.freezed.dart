// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchViewState _$SearchViewStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'data':
      return SearchViewStateData.fromJson(json);
    case 'loading':
      return SearchViewStateDataLoading.fromJson(json);
    case 'error':
      return SearchViewStateError.fromJson(json);
    case 'empty':
      return SearchViewStateEmpty.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'SearchViewState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$SearchViewState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<GalleryImage> images) data,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<GalleryImage> images)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<GalleryImage> images)? data,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? empty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchViewStateData value) data,
    required TResult Function(SearchViewStateDataLoading value) loading,
    required TResult Function(SearchViewStateError value) error,
    required TResult Function(SearchViewStateEmpty value) empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchViewStateData value)? data,
    TResult? Function(SearchViewStateDataLoading value)? loading,
    TResult? Function(SearchViewStateError value)? error,
    TResult? Function(SearchViewStateEmpty value)? empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchViewStateData value)? data,
    TResult Function(SearchViewStateDataLoading value)? loading,
    TResult Function(SearchViewStateError value)? error,
    TResult Function(SearchViewStateEmpty value)? empty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchViewStateCopyWith<$Res> {
  factory $SearchViewStateCopyWith(
          SearchViewState value, $Res Function(SearchViewState) then) =
      _$SearchViewStateCopyWithImpl<$Res, SearchViewState>;
}

/// @nodoc
class _$SearchViewStateCopyWithImpl<$Res, $Val extends SearchViewState>
    implements $SearchViewStateCopyWith<$Res> {
  _$SearchViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SearchViewStateDataImplCopyWith<$Res> {
  factory _$$SearchViewStateDataImplCopyWith(_$SearchViewStateDataImpl value,
          $Res Function(_$SearchViewStateDataImpl) then) =
      __$$SearchViewStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<GalleryImage> images});
}

/// @nodoc
class __$$SearchViewStateDataImplCopyWithImpl<$Res>
    extends _$SearchViewStateCopyWithImpl<$Res, _$SearchViewStateDataImpl>
    implements _$$SearchViewStateDataImplCopyWith<$Res> {
  __$$SearchViewStateDataImplCopyWithImpl(_$SearchViewStateDataImpl _value,
      $Res Function(_$SearchViewStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = null,
  }) {
    return _then(_$SearchViewStateDataImpl(
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<GalleryImage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchViewStateDataImpl implements SearchViewStateData {
  const _$SearchViewStateDataImpl(
      {required final List<GalleryImage> images, final String? $type})
      : _images = images,
        $type = $type ?? 'data';

  factory _$SearchViewStateDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchViewStateDataImplFromJson(json);

  final List<GalleryImage> _images;
  @override
  List<GalleryImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SearchViewState.data(images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchViewStateDataImpl &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_images));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchViewStateDataImplCopyWith<_$SearchViewStateDataImpl> get copyWith =>
      __$$SearchViewStateDataImplCopyWithImpl<_$SearchViewStateDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<GalleryImage> images) data,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() empty,
  }) {
    return data(images);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<GalleryImage> images)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? empty,
  }) {
    return data?.call(images);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<GalleryImage> images)? data,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(images);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchViewStateData value) data,
    required TResult Function(SearchViewStateDataLoading value) loading,
    required TResult Function(SearchViewStateError value) error,
    required TResult Function(SearchViewStateEmpty value) empty,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchViewStateData value)? data,
    TResult? Function(SearchViewStateDataLoading value)? loading,
    TResult? Function(SearchViewStateError value)? error,
    TResult? Function(SearchViewStateEmpty value)? empty,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchViewStateData value)? data,
    TResult Function(SearchViewStateDataLoading value)? loading,
    TResult Function(SearchViewStateError value)? error,
    TResult Function(SearchViewStateEmpty value)? empty,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchViewStateDataImplToJson(
      this,
    );
  }
}

abstract class SearchViewStateData implements SearchViewState {
  const factory SearchViewStateData(
      {required final List<GalleryImage> images}) = _$SearchViewStateDataImpl;

  factory SearchViewStateData.fromJson(Map<String, dynamic> json) =
      _$SearchViewStateDataImpl.fromJson;

  List<GalleryImage> get images;
  @JsonKey(ignore: true)
  _$$SearchViewStateDataImplCopyWith<_$SearchViewStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchViewStateDataLoadingImplCopyWith<$Res> {
  factory _$$SearchViewStateDataLoadingImplCopyWith(
          _$SearchViewStateDataLoadingImpl value,
          $Res Function(_$SearchViewStateDataLoadingImpl) then) =
      __$$SearchViewStateDataLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchViewStateDataLoadingImplCopyWithImpl<$Res>
    extends _$SearchViewStateCopyWithImpl<$Res,
        _$SearchViewStateDataLoadingImpl>
    implements _$$SearchViewStateDataLoadingImplCopyWith<$Res> {
  __$$SearchViewStateDataLoadingImplCopyWithImpl(
      _$SearchViewStateDataLoadingImpl _value,
      $Res Function(_$SearchViewStateDataLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$SearchViewStateDataLoadingImpl implements SearchViewStateDataLoading {
  const _$SearchViewStateDataLoadingImpl({final String? $type})
      : $type = $type ?? 'loading';

  factory _$SearchViewStateDataLoadingImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SearchViewStateDataLoadingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SearchViewState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchViewStateDataLoadingImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<GalleryImage> images) data,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() empty,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<GalleryImage> images)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? empty,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<GalleryImage> images)? data,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchViewStateData value) data,
    required TResult Function(SearchViewStateDataLoading value) loading,
    required TResult Function(SearchViewStateError value) error,
    required TResult Function(SearchViewStateEmpty value) empty,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchViewStateData value)? data,
    TResult? Function(SearchViewStateDataLoading value)? loading,
    TResult? Function(SearchViewStateError value)? error,
    TResult? Function(SearchViewStateEmpty value)? empty,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchViewStateData value)? data,
    TResult Function(SearchViewStateDataLoading value)? loading,
    TResult Function(SearchViewStateError value)? error,
    TResult Function(SearchViewStateEmpty value)? empty,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchViewStateDataLoadingImplToJson(
      this,
    );
  }
}

abstract class SearchViewStateDataLoading implements SearchViewState {
  const factory SearchViewStateDataLoading() = _$SearchViewStateDataLoadingImpl;

  factory SearchViewStateDataLoading.fromJson(Map<String, dynamic> json) =
      _$SearchViewStateDataLoadingImpl.fromJson;
}

/// @nodoc
abstract class _$$SearchViewStateErrorImplCopyWith<$Res> {
  factory _$$SearchViewStateErrorImplCopyWith(_$SearchViewStateErrorImpl value,
          $Res Function(_$SearchViewStateErrorImpl) then) =
      __$$SearchViewStateErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchViewStateErrorImplCopyWithImpl<$Res>
    extends _$SearchViewStateCopyWithImpl<$Res, _$SearchViewStateErrorImpl>
    implements _$$SearchViewStateErrorImplCopyWith<$Res> {
  __$$SearchViewStateErrorImplCopyWithImpl(_$SearchViewStateErrorImpl _value,
      $Res Function(_$SearchViewStateErrorImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$SearchViewStateErrorImpl implements SearchViewStateError {
  const _$SearchViewStateErrorImpl({final String? $type})
      : $type = $type ?? 'error';

  factory _$SearchViewStateErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchViewStateErrorImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SearchViewState.error()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchViewStateErrorImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<GalleryImage> images) data,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() empty,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<GalleryImage> images)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? empty,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<GalleryImage> images)? data,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchViewStateData value) data,
    required TResult Function(SearchViewStateDataLoading value) loading,
    required TResult Function(SearchViewStateError value) error,
    required TResult Function(SearchViewStateEmpty value) empty,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchViewStateData value)? data,
    TResult? Function(SearchViewStateDataLoading value)? loading,
    TResult? Function(SearchViewStateError value)? error,
    TResult? Function(SearchViewStateEmpty value)? empty,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchViewStateData value)? data,
    TResult Function(SearchViewStateDataLoading value)? loading,
    TResult Function(SearchViewStateError value)? error,
    TResult Function(SearchViewStateEmpty value)? empty,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchViewStateErrorImplToJson(
      this,
    );
  }
}

abstract class SearchViewStateError implements SearchViewState {
  const factory SearchViewStateError() = _$SearchViewStateErrorImpl;

  factory SearchViewStateError.fromJson(Map<String, dynamic> json) =
      _$SearchViewStateErrorImpl.fromJson;
}

/// @nodoc
abstract class _$$SearchViewStateEmptyImplCopyWith<$Res> {
  factory _$$SearchViewStateEmptyImplCopyWith(_$SearchViewStateEmptyImpl value,
          $Res Function(_$SearchViewStateEmptyImpl) then) =
      __$$SearchViewStateEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchViewStateEmptyImplCopyWithImpl<$Res>
    extends _$SearchViewStateCopyWithImpl<$Res, _$SearchViewStateEmptyImpl>
    implements _$$SearchViewStateEmptyImplCopyWith<$Res> {
  __$$SearchViewStateEmptyImplCopyWithImpl(_$SearchViewStateEmptyImpl _value,
      $Res Function(_$SearchViewStateEmptyImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$SearchViewStateEmptyImpl implements SearchViewStateEmpty {
  const _$SearchViewStateEmptyImpl({final String? $type})
      : $type = $type ?? 'empty';

  factory _$SearchViewStateEmptyImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchViewStateEmptyImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SearchViewState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchViewStateEmptyImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<GalleryImage> images) data,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() empty,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<GalleryImage> images)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? empty,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<GalleryImage> images)? data,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchViewStateData value) data,
    required TResult Function(SearchViewStateDataLoading value) loading,
    required TResult Function(SearchViewStateError value) error,
    required TResult Function(SearchViewStateEmpty value) empty,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchViewStateData value)? data,
    TResult? Function(SearchViewStateDataLoading value)? loading,
    TResult? Function(SearchViewStateError value)? error,
    TResult? Function(SearchViewStateEmpty value)? empty,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchViewStateData value)? data,
    TResult Function(SearchViewStateDataLoading value)? loading,
    TResult Function(SearchViewStateError value)? error,
    TResult Function(SearchViewStateEmpty value)? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchViewStateEmptyImplToJson(
      this,
    );
  }
}

abstract class SearchViewStateEmpty implements SearchViewState {
  const factory SearchViewStateEmpty() = _$SearchViewStateEmptyImpl;

  factory SearchViewStateEmpty.fromJson(Map<String, dynamic> json) =
      _$SearchViewStateEmptyImpl.fromJson;
}
