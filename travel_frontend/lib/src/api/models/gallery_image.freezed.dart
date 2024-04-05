// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GalleryImage _$GalleryImageFromJson(Map<String, dynamic> json) {
  return _GalleryImage.fromJson(json);
}

/// @nodoc
mixin _$GalleryImage {
  String get filename => throw _privateConstructorUsedError;
  @JsonKey(name: 's3_presigned_urls')
  S3Urls get url => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GalleryImageCopyWith<GalleryImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryImageCopyWith<$Res> {
  factory $GalleryImageCopyWith(
          GalleryImage value, $Res Function(GalleryImage) then) =
      _$GalleryImageCopyWithImpl<$Res, GalleryImage>;
  @useResult
  $Res call(
      {String filename,
      @JsonKey(name: 's3_presigned_urls') S3Urls url,
      String label,
      List<String> tags});

  $S3UrlsCopyWith<$Res> get url;
}

/// @nodoc
class _$GalleryImageCopyWithImpl<$Res, $Val extends GalleryImage>
    implements $GalleryImageCopyWith<$Res> {
  _$GalleryImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filename = null,
    Object? url = null,
    Object? label = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as S3Urls,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $S3UrlsCopyWith<$Res> get url {
    return $S3UrlsCopyWith<$Res>(_value.url, (value) {
      return _then(_value.copyWith(url: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GalleryImageImplCopyWith<$Res>
    implements $GalleryImageCopyWith<$Res> {
  factory _$$GalleryImageImplCopyWith(
          _$GalleryImageImpl value, $Res Function(_$GalleryImageImpl) then) =
      __$$GalleryImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String filename,
      @JsonKey(name: 's3_presigned_urls') S3Urls url,
      String label,
      List<String> tags});

  @override
  $S3UrlsCopyWith<$Res> get url;
}

/// @nodoc
class __$$GalleryImageImplCopyWithImpl<$Res>
    extends _$GalleryImageCopyWithImpl<$Res, _$GalleryImageImpl>
    implements _$$GalleryImageImplCopyWith<$Res> {
  __$$GalleryImageImplCopyWithImpl(
      _$GalleryImageImpl _value, $Res Function(_$GalleryImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filename = null,
    Object? url = null,
    Object? label = null,
    Object? tags = null,
  }) {
    return _then(_$GalleryImageImpl(
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as S3Urls,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GalleryImageImpl implements _GalleryImage {
  const _$GalleryImageImpl(
      {required this.filename,
      @JsonKey(name: 's3_presigned_urls') required this.url,
      required this.label,
      required final List<String> tags})
      : _tags = tags;

  factory _$GalleryImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$GalleryImageImplFromJson(json);

  @override
  final String filename;
  @override
  @JsonKey(name: 's3_presigned_urls')
  final S3Urls url;
  @override
  final String label;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'GalleryImage(filename: $filename, url: $url, label: $label, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GalleryImageImpl &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, filename, url, label,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GalleryImageImplCopyWith<_$GalleryImageImpl> get copyWith =>
      __$$GalleryImageImplCopyWithImpl<_$GalleryImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GalleryImageImplToJson(
      this,
    );
  }
}

abstract class _GalleryImage implements GalleryImage {
  const factory _GalleryImage(
      {required final String filename,
      @JsonKey(name: 's3_presigned_urls') required final S3Urls url,
      required final String label,
      required final List<String> tags}) = _$GalleryImageImpl;

  factory _GalleryImage.fromJson(Map<String, dynamic> json) =
      _$GalleryImageImpl.fromJson;

  @override
  String get filename;
  @override
  @JsonKey(name: 's3_presigned_urls')
  S3Urls get url;
  @override
  String get label;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$GalleryImageImplCopyWith<_$GalleryImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
