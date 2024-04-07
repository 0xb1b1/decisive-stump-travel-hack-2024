// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'uploaded_file_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UploadedFileResponse _$UploadedFileResponseFromJson(Map<String, dynamic> json) {
  return _UploadedFileResponse.fromJson(json);
}

/// @nodoc
mixin _$UploadedFileResponse {
  List<GalleryImage> get images => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get filename => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UploadedFileResponseCopyWith<UploadedFileResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadedFileResponseCopyWith<$Res> {
  factory $UploadedFileResponseCopyWith(UploadedFileResponse value,
          $Res Function(UploadedFileResponse) then) =
      _$UploadedFileResponseCopyWithImpl<$Res, UploadedFileResponse>;
  @useResult
  $Res call({List<GalleryImage> images, List<String> tags, String filename});
}

/// @nodoc
class _$UploadedFileResponseCopyWithImpl<$Res,
        $Val extends UploadedFileResponse>
    implements $UploadedFileResponseCopyWith<$Res> {
  _$UploadedFileResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = null,
    Object? tags = null,
    Object? filename = null,
  }) {
    return _then(_value.copyWith(
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<GalleryImage>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadedFileResponseImplCopyWith<$Res>
    implements $UploadedFileResponseCopyWith<$Res> {
  factory _$$UploadedFileResponseImplCopyWith(_$UploadedFileResponseImpl value,
          $Res Function(_$UploadedFileResponseImpl) then) =
      __$$UploadedFileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<GalleryImage> images, List<String> tags, String filename});
}

/// @nodoc
class __$$UploadedFileResponseImplCopyWithImpl<$Res>
    extends _$UploadedFileResponseCopyWithImpl<$Res, _$UploadedFileResponseImpl>
    implements _$$UploadedFileResponseImplCopyWith<$Res> {
  __$$UploadedFileResponseImplCopyWithImpl(_$UploadedFileResponseImpl _value,
      $Res Function(_$UploadedFileResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = null,
    Object? tags = null,
    Object? filename = null,
  }) {
    return _then(_$UploadedFileResponseImpl(
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<GalleryImage>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadedFileResponseImpl implements _UploadedFileResponse {
  const _$UploadedFileResponseImpl(
      {required final List<GalleryImage> images,
      required final List<String> tags,
      required this.filename})
      : _images = images,
        _tags = tags;

  factory _$UploadedFileResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadedFileResponseImplFromJson(json);

  final List<GalleryImage> _images;
  @override
  List<GalleryImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String filename;

  @override
  String toString() {
    return 'UploadedFileResponse(images: $images, tags: $tags, filename: $filename)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadedFileResponseImpl &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_tags),
      filename);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadedFileResponseImplCopyWith<_$UploadedFileResponseImpl>
      get copyWith =>
          __$$UploadedFileResponseImplCopyWithImpl<_$UploadedFileResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadedFileResponseImplToJson(
      this,
    );
  }
}

abstract class _UploadedFileResponse implements UploadedFileResponse {
  const factory _UploadedFileResponse(
      {required final List<GalleryImage> images,
      required final List<String> tags,
      required final String filename}) = _$UploadedFileResponseImpl;

  factory _UploadedFileResponse.fromJson(Map<String, dynamic> json) =
      _$UploadedFileResponseImpl.fromJson;

  @override
  List<GalleryImage> get images;
  @override
  List<String> get tags;
  @override
  String get filename;
  @override
  @JsonKey(ignore: true)
  _$$UploadedFileResponseImplCopyWith<_$UploadedFileResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
