// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'full_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FullImage _$FullImageFromJson(Map<String, dynamic> json) {
  return _FullImage.fromJson(json);
}

/// @nodoc
mixin _$FullImage {
  String get filename => throw _privateConstructorUsedError;
  @JsonKey(name: 's3_presigned_urls')
  S3Urls get url => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'view_count')
  int? get viewsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'download_count')
  int? get downloadsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FullImageCopyWith<FullImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FullImageCopyWith<$Res> {
  factory $FullImageCopyWith(FullImage value, $Res Function(FullImage) then) =
      _$FullImageCopyWithImpl<$Res, FullImage>;
  @useResult
  $Res call(
      {String filename,
      @JsonKey(name: 's3_presigned_urls') S3Urls url,
      String label,
      List<String> tags,
      @JsonKey(name: 'view_count') int? viewsCount,
      @JsonKey(name: 'download_count') int? downloadsCount});

  $S3UrlsCopyWith<$Res> get url;
}

/// @nodoc
class _$FullImageCopyWithImpl<$Res, $Val extends FullImage>
    implements $FullImageCopyWith<$Res> {
  _$FullImageCopyWithImpl(this._value, this._then);

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
    Object? viewsCount = freezed,
    Object? downloadsCount = freezed,
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
      viewsCount: freezed == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      downloadsCount: freezed == downloadsCount
          ? _value.downloadsCount
          : downloadsCount // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$FullImageImplCopyWith<$Res>
    implements $FullImageCopyWith<$Res> {
  factory _$$FullImageImplCopyWith(
          _$FullImageImpl value, $Res Function(_$FullImageImpl) then) =
      __$$FullImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String filename,
      @JsonKey(name: 's3_presigned_urls') S3Urls url,
      String label,
      List<String> tags,
      @JsonKey(name: 'view_count') int? viewsCount,
      @JsonKey(name: 'download_count') int? downloadsCount});

  @override
  $S3UrlsCopyWith<$Res> get url;
}

/// @nodoc
class __$$FullImageImplCopyWithImpl<$Res>
    extends _$FullImageCopyWithImpl<$Res, _$FullImageImpl>
    implements _$$FullImageImplCopyWith<$Res> {
  __$$FullImageImplCopyWithImpl(
      _$FullImageImpl _value, $Res Function(_$FullImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filename = null,
    Object? url = null,
    Object? label = null,
    Object? tags = null,
    Object? viewsCount = freezed,
    Object? downloadsCount = freezed,
  }) {
    return _then(_$FullImageImpl(
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
      viewsCount: freezed == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      downloadsCount: freezed == downloadsCount
          ? _value.downloadsCount
          : downloadsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FullImageImpl implements _FullImage {
  const _$FullImageImpl(
      {required this.filename,
      @JsonKey(name: 's3_presigned_urls') required this.url,
      required this.label,
      required final List<String> tags,
      @JsonKey(name: 'view_count') this.viewsCount,
      @JsonKey(name: 'download_count') this.downloadsCount})
      : _tags = tags;

  factory _$FullImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$FullImageImplFromJson(json);

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
  @JsonKey(name: 'view_count')
  final int? viewsCount;
  @override
  @JsonKey(name: 'download_count')
  final int? downloadsCount;

  @override
  String toString() {
    return 'FullImage(filename: $filename, url: $url, label: $label, tags: $tags, viewsCount: $viewsCount, downloadsCount: $downloadsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FullImageImpl &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.downloadsCount, downloadsCount) ||
                other.downloadsCount == downloadsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, filename, url, label,
      const DeepCollectionEquality().hash(_tags), viewsCount, downloadsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FullImageImplCopyWith<_$FullImageImpl> get copyWith =>
      __$$FullImageImplCopyWithImpl<_$FullImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FullImageImplToJson(
      this,
    );
  }
}

abstract class _FullImage implements FullImage {
  const factory _FullImage(
          {required final String filename,
          @JsonKey(name: 's3_presigned_urls') required final S3Urls url,
          required final String label,
          required final List<String> tags,
          @JsonKey(name: 'view_count') final int? viewsCount,
          @JsonKey(name: 'download_count') final int? downloadsCount}) =
      _$FullImageImpl;

  factory _FullImage.fromJson(Map<String, dynamic> json) =
      _$FullImageImpl.fromJson;

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
  @JsonKey(name: 'view_count')
  int? get viewsCount;
  @override
  @JsonKey(name: 'download_count')
  int? get downloadsCount;
  @override
  @JsonKey(ignore: true)
  _$$FullImageImplCopyWith<_$FullImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
