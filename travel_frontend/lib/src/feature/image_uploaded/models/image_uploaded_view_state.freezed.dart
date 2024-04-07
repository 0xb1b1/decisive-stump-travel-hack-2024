// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_uploaded_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImageUploadedViewState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)
        data,
    required TResult Function() loading,
    required TResult Function() error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)?
        data,
    TResult? Function()? loading,
    TResult? Function()? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)?
        data,
    TResult Function()? loading,
    TResult Function()? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageUploadedViewStateData value) data,
    required TResult Function(ImageUploadedViewStateLoading value) loading,
    required TResult Function(ImageUploadedViewStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageUploadedViewStateData value)? data,
    TResult? Function(ImageUploadedViewStateLoading value)? loading,
    TResult? Function(ImageUploadedViewStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageUploadedViewStateData value)? data,
    TResult Function(ImageUploadedViewStateLoading value)? loading,
    TResult Function(ImageUploadedViewStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageUploadedViewStateCopyWith<$Res> {
  factory $ImageUploadedViewStateCopyWith(ImageUploadedViewState value,
          $Res Function(ImageUploadedViewState) then) =
      _$ImageUploadedViewStateCopyWithImpl<$Res, ImageUploadedViewState>;
}

/// @nodoc
class _$ImageUploadedViewStateCopyWithImpl<$Res,
        $Val extends ImageUploadedViewState>
    implements $ImageUploadedViewStateCopyWith<$Res> {
  _$ImageUploadedViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ImageUploadedViewStateDataImplCopyWith<$Res> {
  factory _$$ImageUploadedViewStateDataImplCopyWith(
          _$ImageUploadedViewStateDataImpl value,
          $Res Function(_$ImageUploadedViewStateDataImpl) then) =
      __$$ImageUploadedViewStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {XFile file,
      List<String> possibleTags,
      List<GalleryImage> similarImages});
}

/// @nodoc
class __$$ImageUploadedViewStateDataImplCopyWithImpl<$Res>
    extends _$ImageUploadedViewStateCopyWithImpl<$Res,
        _$ImageUploadedViewStateDataImpl>
    implements _$$ImageUploadedViewStateDataImplCopyWith<$Res> {
  __$$ImageUploadedViewStateDataImplCopyWithImpl(
      _$ImageUploadedViewStateDataImpl _value,
      $Res Function(_$ImageUploadedViewStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? file = null,
    Object? possibleTags = null,
    Object? similarImages = null,
  }) {
    return _then(_$ImageUploadedViewStateDataImpl(
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as XFile,
      possibleTags: null == possibleTags
          ? _value._possibleTags
          : possibleTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      similarImages: null == similarImages
          ? _value._similarImages
          : similarImages // ignore: cast_nullable_to_non_nullable
              as List<GalleryImage>,
    ));
  }
}

/// @nodoc

class _$ImageUploadedViewStateDataImpl implements ImageUploadedViewStateData {
  const _$ImageUploadedViewStateDataImpl(
      {required this.file,
      required final List<String> possibleTags,
      required final List<GalleryImage> similarImages})
      : _possibleTags = possibleTags,
        _similarImages = similarImages;

  @override
  final XFile file;
  final List<String> _possibleTags;
  @override
  List<String> get possibleTags {
    if (_possibleTags is EqualUnmodifiableListView) return _possibleTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_possibleTags);
  }

  final List<GalleryImage> _similarImages;
  @override
  List<GalleryImage> get similarImages {
    if (_similarImages is EqualUnmodifiableListView) return _similarImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_similarImages);
  }

  @override
  String toString() {
    return 'ImageUploadedViewState.data(file: $file, possibleTags: $possibleTags, similarImages: $similarImages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageUploadedViewStateDataImpl &&
            (identical(other.file, file) || other.file == file) &&
            const DeepCollectionEquality()
                .equals(other._possibleTags, _possibleTags) &&
            const DeepCollectionEquality()
                .equals(other._similarImages, _similarImages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      file,
      const DeepCollectionEquality().hash(_possibleTags),
      const DeepCollectionEquality().hash(_similarImages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageUploadedViewStateDataImplCopyWith<_$ImageUploadedViewStateDataImpl>
      get copyWith => __$$ImageUploadedViewStateDataImplCopyWithImpl<
          _$ImageUploadedViewStateDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)
        data,
    required TResult Function() loading,
    required TResult Function() error,
  }) {
    return data(file, possibleTags, similarImages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)?
        data,
    TResult? Function()? loading,
    TResult? Function()? error,
  }) {
    return data?.call(file, possibleTags, similarImages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)?
        data,
    TResult Function()? loading,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(file, possibleTags, similarImages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageUploadedViewStateData value) data,
    required TResult Function(ImageUploadedViewStateLoading value) loading,
    required TResult Function(ImageUploadedViewStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageUploadedViewStateData value)? data,
    TResult? Function(ImageUploadedViewStateLoading value)? loading,
    TResult? Function(ImageUploadedViewStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageUploadedViewStateData value)? data,
    TResult Function(ImageUploadedViewStateLoading value)? loading,
    TResult Function(ImageUploadedViewStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class ImageUploadedViewStateData implements ImageUploadedViewState {
  const factory ImageUploadedViewStateData(
          {required final XFile file,
          required final List<String> possibleTags,
          required final List<GalleryImage> similarImages}) =
      _$ImageUploadedViewStateDataImpl;

  XFile get file;
  List<String> get possibleTags;
  List<GalleryImage> get similarImages;
  @JsonKey(ignore: true)
  _$$ImageUploadedViewStateDataImplCopyWith<_$ImageUploadedViewStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ImageUploadedViewStateLoadingImplCopyWith<$Res> {
  factory _$$ImageUploadedViewStateLoadingImplCopyWith(
          _$ImageUploadedViewStateLoadingImpl value,
          $Res Function(_$ImageUploadedViewStateLoadingImpl) then) =
      __$$ImageUploadedViewStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ImageUploadedViewStateLoadingImplCopyWithImpl<$Res>
    extends _$ImageUploadedViewStateCopyWithImpl<$Res,
        _$ImageUploadedViewStateLoadingImpl>
    implements _$$ImageUploadedViewStateLoadingImplCopyWith<$Res> {
  __$$ImageUploadedViewStateLoadingImplCopyWithImpl(
      _$ImageUploadedViewStateLoadingImpl _value,
      $Res Function(_$ImageUploadedViewStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ImageUploadedViewStateLoadingImpl
    implements ImageUploadedViewStateLoading {
  const _$ImageUploadedViewStateLoadingImpl();

  @override
  String toString() {
    return 'ImageUploadedViewState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageUploadedViewStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)
        data,
    required TResult Function() loading,
    required TResult Function() error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)?
        data,
    TResult? Function()? loading,
    TResult? Function()? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)?
        data,
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
    required TResult Function(ImageUploadedViewStateData value) data,
    required TResult Function(ImageUploadedViewStateLoading value) loading,
    required TResult Function(ImageUploadedViewStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageUploadedViewStateData value)? data,
    TResult? Function(ImageUploadedViewStateLoading value)? loading,
    TResult? Function(ImageUploadedViewStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageUploadedViewStateData value)? data,
    TResult Function(ImageUploadedViewStateLoading value)? loading,
    TResult Function(ImageUploadedViewStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ImageUploadedViewStateLoading implements ImageUploadedViewState {
  const factory ImageUploadedViewStateLoading() =
      _$ImageUploadedViewStateLoadingImpl;
}

/// @nodoc
abstract class _$$ImageUploadedViewStateErrorImplCopyWith<$Res> {
  factory _$$ImageUploadedViewStateErrorImplCopyWith(
          _$ImageUploadedViewStateErrorImpl value,
          $Res Function(_$ImageUploadedViewStateErrorImpl) then) =
      __$$ImageUploadedViewStateErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ImageUploadedViewStateErrorImplCopyWithImpl<$Res>
    extends _$ImageUploadedViewStateCopyWithImpl<$Res,
        _$ImageUploadedViewStateErrorImpl>
    implements _$$ImageUploadedViewStateErrorImplCopyWith<$Res> {
  __$$ImageUploadedViewStateErrorImplCopyWithImpl(
      _$ImageUploadedViewStateErrorImpl _value,
      $Res Function(_$ImageUploadedViewStateErrorImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ImageUploadedViewStateErrorImpl implements ImageUploadedViewStateError {
  const _$ImageUploadedViewStateErrorImpl();

  @override
  String toString() {
    return 'ImageUploadedViewState.error()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageUploadedViewStateErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)
        data,
    required TResult Function() loading,
    required TResult Function() error,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)?
        data,
    TResult? Function()? loading,
    TResult? Function()? error,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(XFile file, List<String> possibleTags,
            List<GalleryImage> similarImages)?
        data,
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
    required TResult Function(ImageUploadedViewStateData value) data,
    required TResult Function(ImageUploadedViewStateLoading value) loading,
    required TResult Function(ImageUploadedViewStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageUploadedViewStateData value)? data,
    TResult? Function(ImageUploadedViewStateLoading value)? loading,
    TResult? Function(ImageUploadedViewStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageUploadedViewStateData value)? data,
    TResult Function(ImageUploadedViewStateLoading value)? loading,
    TResult Function(ImageUploadedViewStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ImageUploadedViewStateError implements ImageUploadedViewState {
  const factory ImageUploadedViewStateError() =
      _$ImageUploadedViewStateErrorImpl;
}
