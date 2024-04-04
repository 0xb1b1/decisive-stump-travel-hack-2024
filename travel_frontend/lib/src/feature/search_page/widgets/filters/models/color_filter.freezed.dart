// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ColorsFilter {
  bool get checked => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ColorsFilterCopyWith<ColorsFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColorsFilterCopyWith<$Res> {
  factory $ColorsFilterCopyWith(
          ColorsFilter value, $Res Function(ColorsFilter) then) =
      _$ColorsFilterCopyWithImpl<$Res, ColorsFilter>;
  @useResult
  $Res call({bool checked, String title, Color color});
}

/// @nodoc
class _$ColorsFilterCopyWithImpl<$Res, $Val extends ColorsFilter>
    implements $ColorsFilterCopyWith<$Res> {
  _$ColorsFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checked = null,
    Object? title = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      checked: null == checked
          ? _value.checked
          : checked // ignore: cast_nullable_to_non_nullable
              as bool,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ColorsFilterImplCopyWith<$Res>
    implements $ColorsFilterCopyWith<$Res> {
  factory _$$ColorsFilterImplCopyWith(
          _$ColorsFilterImpl value, $Res Function(_$ColorsFilterImpl) then) =
      __$$ColorsFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool checked, String title, Color color});
}

/// @nodoc
class __$$ColorsFilterImplCopyWithImpl<$Res>
    extends _$ColorsFilterCopyWithImpl<$Res, _$ColorsFilterImpl>
    implements _$$ColorsFilterImplCopyWith<$Res> {
  __$$ColorsFilterImplCopyWithImpl(
      _$ColorsFilterImpl _value, $Res Function(_$ColorsFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checked = null,
    Object? title = null,
    Object? color = null,
  }) {
    return _then(_$ColorsFilterImpl(
      checked: null == checked
          ? _value.checked
          : checked // ignore: cast_nullable_to_non_nullable
              as bool,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$ColorsFilterImpl implements _ColorsFilter {
  const _$ColorsFilterImpl(
      {required this.checked, required this.title, required this.color});

  @override
  final bool checked;
  @override
  final String title;
  @override
  final Color color;

  @override
  String toString() {
    return 'ColorsFilter(checked: $checked, title: $title, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColorsFilterImpl &&
            (identical(other.checked, checked) || other.checked == checked) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode => Object.hash(runtimeType, checked, title, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ColorsFilterImplCopyWith<_$ColorsFilterImpl> get copyWith =>
      __$$ColorsFilterImplCopyWithImpl<_$ColorsFilterImpl>(this, _$identity);
}

abstract class _ColorsFilter implements ColorsFilter {
  const factory _ColorsFilter(
      {required final bool checked,
      required final String title,
      required final Color color}) = _$ColorsFilterImpl;

  @override
  bool get checked;
  @override
  String get title;
  @override
  Color get color;
  @override
  @JsonKey(ignore: true)
  _$$ColorsFilterImplCopyWith<_$ColorsFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
