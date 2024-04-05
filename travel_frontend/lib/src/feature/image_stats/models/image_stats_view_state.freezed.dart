// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_stats_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImageStatsViewState _$ImageStatsViewStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'data':
      return ImageStatsViewStateData.fromJson(json);
    case 'loading':
      return ImageStatsViewStateLoading.fromJson(json);
    case 'error':
      return ImageStatsViewStateError.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'ImageStatsViewState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ImageStatsViewState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FullImage image, Gallery similarImages) data,
    required TResult Function() loading,
    required TResult Function() error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FullImage image, Gallery similarImages)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FullImage image, Gallery similarImages)? data,
    TResult Function()? loading,
    TResult Function()? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageStatsViewStateData value) data,
    required TResult Function(ImageStatsViewStateLoading value) loading,
    required TResult Function(ImageStatsViewStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageStatsViewStateData value)? data,
    TResult? Function(ImageStatsViewStateLoading value)? loading,
    TResult? Function(ImageStatsViewStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageStatsViewStateData value)? data,
    TResult Function(ImageStatsViewStateLoading value)? loading,
    TResult Function(ImageStatsViewStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageStatsViewStateCopyWith<$Res> {
  factory $ImageStatsViewStateCopyWith(
          ImageStatsViewState value, $Res Function(ImageStatsViewState) then) =
      _$ImageStatsViewStateCopyWithImpl<$Res, ImageStatsViewState>;
}

/// @nodoc
class _$ImageStatsViewStateCopyWithImpl<$Res, $Val extends ImageStatsViewState>
    implements $ImageStatsViewStateCopyWith<$Res> {
  _$ImageStatsViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ImageStatsViewStateDataImplCopyWith<$Res> {
  factory _$$ImageStatsViewStateDataImplCopyWith(
          _$ImageStatsViewStateDataImpl value,
          $Res Function(_$ImageStatsViewStateDataImpl) then) =
      __$$ImageStatsViewStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({FullImage image, Gallery similarImages});

  $FullImageCopyWith<$Res> get image;
  $GalleryCopyWith<$Res> get similarImages;
}

/// @nodoc
class __$$ImageStatsViewStateDataImplCopyWithImpl<$Res>
    extends _$ImageStatsViewStateCopyWithImpl<$Res,
        _$ImageStatsViewStateDataImpl>
    implements _$$ImageStatsViewStateDataImplCopyWith<$Res> {
  __$$ImageStatsViewStateDataImplCopyWithImpl(
      _$ImageStatsViewStateDataImpl _value,
      $Res Function(_$ImageStatsViewStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? similarImages = null,
  }) {
    return _then(_$ImageStatsViewStateDataImpl(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as FullImage,
      similarImages: null == similarImages
          ? _value.similarImages
          : similarImages // ignore: cast_nullable_to_non_nullable
              as Gallery,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $FullImageCopyWith<$Res> get image {
    return $FullImageCopyWith<$Res>(_value.image, (value) {
      return _then(_value.copyWith(image: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GalleryCopyWith<$Res> get similarImages {
    return $GalleryCopyWith<$Res>(_value.similarImages, (value) {
      return _then(_value.copyWith(similarImages: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageStatsViewStateDataImpl implements ImageStatsViewStateData {
  const _$ImageStatsViewStateDataImpl(
      {required this.image, required this.similarImages, final String? $type})
      : $type = $type ?? 'data';

  factory _$ImageStatsViewStateDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageStatsViewStateDataImplFromJson(json);

  @override
  final FullImage image;
  @override
  final Gallery similarImages;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ImageStatsViewState.data(image: $image, similarImages: $similarImages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageStatsViewStateDataImpl &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.similarImages, similarImages) ||
                other.similarImages == similarImages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, image, similarImages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageStatsViewStateDataImplCopyWith<_$ImageStatsViewStateDataImpl>
      get copyWith => __$$ImageStatsViewStateDataImplCopyWithImpl<
          _$ImageStatsViewStateDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FullImage image, Gallery similarImages) data,
    required TResult Function() loading,
    required TResult Function() error,
  }) {
    return data(image, similarImages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FullImage image, Gallery similarImages)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
  }) {
    return data?.call(image, similarImages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FullImage image, Gallery similarImages)? data,
    TResult Function()? loading,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(image, similarImages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageStatsViewStateData value) data,
    required TResult Function(ImageStatsViewStateLoading value) loading,
    required TResult Function(ImageStatsViewStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageStatsViewStateData value)? data,
    TResult? Function(ImageStatsViewStateLoading value)? loading,
    TResult? Function(ImageStatsViewStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageStatsViewStateData value)? data,
    TResult Function(ImageStatsViewStateLoading value)? loading,
    TResult Function(ImageStatsViewStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageStatsViewStateDataImplToJson(
      this,
    );
  }
}

abstract class ImageStatsViewStateData implements ImageStatsViewState {
  const factory ImageStatsViewStateData(
      {required final FullImage image,
      required final Gallery similarImages}) = _$ImageStatsViewStateDataImpl;

  factory ImageStatsViewStateData.fromJson(Map<String, dynamic> json) =
      _$ImageStatsViewStateDataImpl.fromJson;

  FullImage get image;
  Gallery get similarImages;
  @JsonKey(ignore: true)
  _$$ImageStatsViewStateDataImplCopyWith<_$ImageStatsViewStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ImageStatsViewStateLoadingImplCopyWith<$Res> {
  factory _$$ImageStatsViewStateLoadingImplCopyWith(
          _$ImageStatsViewStateLoadingImpl value,
          $Res Function(_$ImageStatsViewStateLoadingImpl) then) =
      __$$ImageStatsViewStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ImageStatsViewStateLoadingImplCopyWithImpl<$Res>
    extends _$ImageStatsViewStateCopyWithImpl<$Res,
        _$ImageStatsViewStateLoadingImpl>
    implements _$$ImageStatsViewStateLoadingImplCopyWith<$Res> {
  __$$ImageStatsViewStateLoadingImplCopyWithImpl(
      _$ImageStatsViewStateLoadingImpl _value,
      $Res Function(_$ImageStatsViewStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$ImageStatsViewStateLoadingImpl implements ImageStatsViewStateLoading {
  const _$ImageStatsViewStateLoadingImpl({final String? $type})
      : $type = $type ?? 'loading';

  factory _$ImageStatsViewStateLoadingImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ImageStatsViewStateLoadingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ImageStatsViewState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageStatsViewStateLoadingImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FullImage image, Gallery similarImages) data,
    required TResult Function() loading,
    required TResult Function() error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FullImage image, Gallery similarImages)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FullImage image, Gallery similarImages)? data,
    TResult Function()? loading,
    TResult Function()? error,
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
    required TResult Function(ImageStatsViewStateData value) data,
    required TResult Function(ImageStatsViewStateLoading value) loading,
    required TResult Function(ImageStatsViewStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageStatsViewStateData value)? data,
    TResult? Function(ImageStatsViewStateLoading value)? loading,
    TResult? Function(ImageStatsViewStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageStatsViewStateData value)? data,
    TResult Function(ImageStatsViewStateLoading value)? loading,
    TResult Function(ImageStatsViewStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageStatsViewStateLoadingImplToJson(
      this,
    );
  }
}

abstract class ImageStatsViewStateLoading implements ImageStatsViewState {
  const factory ImageStatsViewStateLoading() = _$ImageStatsViewStateLoadingImpl;

  factory ImageStatsViewStateLoading.fromJson(Map<String, dynamic> json) =
      _$ImageStatsViewStateLoadingImpl.fromJson;
}

/// @nodoc
abstract class _$$ImageStatsViewStateErrorImplCopyWith<$Res> {
  factory _$$ImageStatsViewStateErrorImplCopyWith(
          _$ImageStatsViewStateErrorImpl value,
          $Res Function(_$ImageStatsViewStateErrorImpl) then) =
      __$$ImageStatsViewStateErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ImageStatsViewStateErrorImplCopyWithImpl<$Res>
    extends _$ImageStatsViewStateCopyWithImpl<$Res,
        _$ImageStatsViewStateErrorImpl>
    implements _$$ImageStatsViewStateErrorImplCopyWith<$Res> {
  __$$ImageStatsViewStateErrorImplCopyWithImpl(
      _$ImageStatsViewStateErrorImpl _value,
      $Res Function(_$ImageStatsViewStateErrorImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$ImageStatsViewStateErrorImpl implements ImageStatsViewStateError {
  const _$ImageStatsViewStateErrorImpl({final String? $type})
      : $type = $type ?? 'error';

  factory _$ImageStatsViewStateErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageStatsViewStateErrorImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ImageStatsViewState.error()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageStatsViewStateErrorImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FullImage image, Gallery similarImages) data,
    required TResult Function() loading,
    required TResult Function() error,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FullImage image, Gallery similarImages)? data,
    TResult? Function()? loading,
    TResult? Function()? error,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FullImage image, Gallery similarImages)? data,
    TResult Function()? loading,
    TResult Function()? error,
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
    required TResult Function(ImageStatsViewStateData value) data,
    required TResult Function(ImageStatsViewStateLoading value) loading,
    required TResult Function(ImageStatsViewStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageStatsViewStateData value)? data,
    TResult? Function(ImageStatsViewStateLoading value)? loading,
    TResult? Function(ImageStatsViewStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageStatsViewStateData value)? data,
    TResult Function(ImageStatsViewStateLoading value)? loading,
    TResult Function(ImageStatsViewStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageStatsViewStateErrorImplToJson(
      this,
    );
  }
}

abstract class ImageStatsViewStateError implements ImageStatsViewState {
  const factory ImageStatsViewStateError() = _$ImageStatsViewStateErrorImpl;

  factory ImageStatsViewStateError.fromJson(Map<String, dynamic> json) =
      _$ImageStatsViewStateErrorImpl.fromJson;
}
