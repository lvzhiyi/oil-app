// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_config_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HttpConfigType _$HttpConfigTypeFromJson(Map<String, dynamic> json) {
  return _HttpConfigType.fromJson(json);
}

/// @nodoc
mixin _$HttpConfigType {
  /// 0关 1开
  int? get canVisit => throw _privateConstructorUsedError;
  String? get endTime => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get tip => throw _privateConstructorUsedError;

  /// Serializes this HttpConfigType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HttpConfigType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HttpConfigTypeCopyWith<HttpConfigType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HttpConfigTypeCopyWith<$Res> {
  factory $HttpConfigTypeCopyWith(
          HttpConfigType value, $Res Function(HttpConfigType) then) =
      _$HttpConfigTypeCopyWithImpl<$Res, HttpConfigType>;
  @useResult
  $Res call({int? canVisit, String? endTime, String? startTime, String? tip});
}

/// @nodoc
class _$HttpConfigTypeCopyWithImpl<$Res, $Val extends HttpConfigType>
    implements $HttpConfigTypeCopyWith<$Res> {
  _$HttpConfigTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HttpConfigType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canVisit = freezed,
    Object? endTime = freezed,
    Object? startTime = freezed,
    Object? tip = freezed,
  }) {
    return _then(_value.copyWith(
      canVisit: freezed == canVisit
          ? _value.canVisit
          : canVisit // ignore: cast_nullable_to_non_nullable
              as int?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      tip: freezed == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HttpConfigTypeImplCopyWith<$Res>
    implements $HttpConfigTypeCopyWith<$Res> {
  factory _$$HttpConfigTypeImplCopyWith(_$HttpConfigTypeImpl value,
          $Res Function(_$HttpConfigTypeImpl) then) =
      __$$HttpConfigTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? canVisit, String? endTime, String? startTime, String? tip});
}

/// @nodoc
class __$$HttpConfigTypeImplCopyWithImpl<$Res>
    extends _$HttpConfigTypeCopyWithImpl<$Res, _$HttpConfigTypeImpl>
    implements _$$HttpConfigTypeImplCopyWith<$Res> {
  __$$HttpConfigTypeImplCopyWithImpl(
      _$HttpConfigTypeImpl _value, $Res Function(_$HttpConfigTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of HttpConfigType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canVisit = freezed,
    Object? endTime = freezed,
    Object? startTime = freezed,
    Object? tip = freezed,
  }) {
    return _then(_$HttpConfigTypeImpl(
      canVisit: freezed == canVisit
          ? _value.canVisit
          : canVisit // ignore: cast_nullable_to_non_nullable
              as int?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      tip: freezed == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HttpConfigTypeImpl
    with DiagnosticableTreeMixin
    implements _HttpConfigType {
  _$HttpConfigTypeImpl({this.canVisit, this.endTime, this.startTime, this.tip});

  factory _$HttpConfigTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$HttpConfigTypeImplFromJson(json);

  /// 0关 1开
  @override
  final int? canVisit;
  @override
  final String? endTime;
  @override
  final String? startTime;
  @override
  final String? tip;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HttpConfigType(canVisit: $canVisit, endTime: $endTime, startTime: $startTime, tip: $tip)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HttpConfigType'))
      ..add(DiagnosticsProperty('canVisit', canVisit))
      ..add(DiagnosticsProperty('endTime', endTime))
      ..add(DiagnosticsProperty('startTime', startTime))
      ..add(DiagnosticsProperty('tip', tip));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpConfigTypeImpl &&
            (identical(other.canVisit, canVisit) ||
                other.canVisit == canVisit) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.tip, tip) || other.tip == tip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, canVisit, endTime, startTime, tip);

  /// Create a copy of HttpConfigType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpConfigTypeImplCopyWith<_$HttpConfigTypeImpl> get copyWith =>
      __$$HttpConfigTypeImplCopyWithImpl<_$HttpConfigTypeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HttpConfigTypeImplToJson(
      this,
    );
  }
}

abstract class _HttpConfigType implements HttpConfigType {
  factory _HttpConfigType(
      {final int? canVisit,
      final String? endTime,
      final String? startTime,
      final String? tip}) = _$HttpConfigTypeImpl;

  factory _HttpConfigType.fromJson(Map<String, dynamic> json) =
      _$HttpConfigTypeImpl.fromJson;

  /// 0关 1开
  @override
  int? get canVisit;
  @override
  String? get endTime;
  @override
  String? get startTime;
  @override
  String? get tip;

  /// Create a copy of HttpConfigType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HttpConfigTypeImplCopyWith<_$HttpConfigTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
