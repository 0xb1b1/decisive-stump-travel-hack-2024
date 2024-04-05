// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 's3_urls.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

S3Urls _$S3UrlsFromJson(Map<String, dynamic> json) {
  return _S3Urls.fromJson(json);
}

/// @nodoc
mixin _$S3Urls {
  String get normal => throw _privateConstructorUsedError;
  String get comp => throw _privateConstructorUsedError;
  String get thumb => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $S3UrlsCopyWith<S3Urls> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $S3UrlsCopyWith<$Res> {
  factory $S3UrlsCopyWith(S3Urls value, $Res Function(S3Urls) then) =
      _$S3UrlsCopyWithImpl<$Res, S3Urls>;
  @useResult
  $Res call({String normal, String comp, String thumb});
}

/// @nodoc
class _$S3UrlsCopyWithImpl<$Res, $Val extends S3Urls>
    implements $S3UrlsCopyWith<$Res> {
  _$S3UrlsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? normal = null,
    Object? comp = null,
    Object? thumb = null,
  }) {
    return _then(_value.copyWith(
      normal: null == normal
          ? _value.normal
          : normal // ignore: cast_nullable_to_non_nullable
              as String,
      comp: null == comp
          ? _value.comp
          : comp // ignore: cast_nullable_to_non_nullable
              as String,
      thumb: null == thumb
          ? _value.thumb
          : thumb // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$S3UrlsImplCopyWith<$Res> implements $S3UrlsCopyWith<$Res> {
  factory _$$S3UrlsImplCopyWith(
          _$S3UrlsImpl value, $Res Function(_$S3UrlsImpl) then) =
      __$$S3UrlsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String normal, String comp, String thumb});
}

/// @nodoc
class __$$S3UrlsImplCopyWithImpl<$Res>
    extends _$S3UrlsCopyWithImpl<$Res, _$S3UrlsImpl>
    implements _$$S3UrlsImplCopyWith<$Res> {
  __$$S3UrlsImplCopyWithImpl(
      _$S3UrlsImpl _value, $Res Function(_$S3UrlsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? normal = null,
    Object? comp = null,
    Object? thumb = null,
  }) {
    return _then(_$S3UrlsImpl(
      normal: null == normal
          ? _value.normal
          : normal // ignore: cast_nullable_to_non_nullable
              as String,
      comp: null == comp
          ? _value.comp
          : comp // ignore: cast_nullable_to_non_nullable
              as String,
      thumb: null == thumb
          ? _value.thumb
          : thumb // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$S3UrlsImpl implements _S3Urls {
  const _$S3UrlsImpl(
      {required this.normal, required this.comp, required this.thumb});

  factory _$S3UrlsImpl.fromJson(Map<String, dynamic> json) =>
      _$$S3UrlsImplFromJson(json);

  @override
  final String normal;
  @override
  final String comp;
  @override
  final String thumb;

  @override
  String toString() {
    return 'S3Urls(normal: $normal, comp: $comp, thumb: $thumb)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$S3UrlsImpl &&
            (identical(other.normal, normal) || other.normal == normal) &&
            (identical(other.comp, comp) || other.comp == comp) &&
            (identical(other.thumb, thumb) || other.thumb == thumb));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, normal, comp, thumb);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$S3UrlsImplCopyWith<_$S3UrlsImpl> get copyWith =>
      __$$S3UrlsImplCopyWithImpl<_$S3UrlsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$S3UrlsImplToJson(
      this,
    );
  }
}

abstract class _S3Urls implements S3Urls {
  const factory _S3Urls(
      {required final String normal,
      required final String comp,
      required final String thumb}) = _$S3UrlsImpl;

  factory _S3Urls.fromJson(Map<String, dynamic> json) = _$S3UrlsImpl.fromJson;

  @override
  String get normal;
  @override
  String get comp;
  @override
  String get thumb;
  @override
  @JsonKey(ignore: true)
  _$$S3UrlsImplCopyWith<_$S3UrlsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
