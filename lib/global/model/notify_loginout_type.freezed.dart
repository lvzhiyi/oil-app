// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notify_loginout_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotifyLoginoutType _$NotifyLoginoutTypeFromJson(Map<String, dynamic> json) {
  return _NotifyLoginoutModel.fromJson(json);
}

/// @nodoc
mixin _$NotifyLoginoutType {
  String? get playerId => throw _privateConstructorUsedError;
  String? get playerObjId => throw _privateConstructorUsedError;
  String? get serviceName => throw _privateConstructorUsedError;
  String? get messageType => throw _privateConstructorUsedError;

  /// 是否为黑名单
  bool? get isBlacklisted => throw _privateConstructorUsedError;

  /// Serializes this NotifyLoginoutType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotifyLoginoutType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotifyLoginoutTypeCopyWith<NotifyLoginoutType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotifyLoginoutTypeCopyWith<$Res> {
  factory $NotifyLoginoutTypeCopyWith(
          NotifyLoginoutType value, $Res Function(NotifyLoginoutType) then) =
      _$NotifyLoginoutTypeCopyWithImpl<$Res, NotifyLoginoutType>;
  @useResult
  $Res call(
      {String? playerId,
      String? playerObjId,
      String? serviceName,
      String? messageType,
      bool? isBlacklisted});
}

/// @nodoc
class _$NotifyLoginoutTypeCopyWithImpl<$Res, $Val extends NotifyLoginoutType>
    implements $NotifyLoginoutTypeCopyWith<$Res> {
  _$NotifyLoginoutTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotifyLoginoutType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = freezed,
    Object? playerObjId = freezed,
    Object? serviceName = freezed,
    Object? messageType = freezed,
    Object? isBlacklisted = freezed,
  }) {
    return _then(_value.copyWith(
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      playerObjId: freezed == playerObjId
          ? _value.playerObjId
          : playerObjId // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceName: freezed == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      messageType: freezed == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String?,
      isBlacklisted: freezed == isBlacklisted
          ? _value.isBlacklisted
          : isBlacklisted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotifyLoginoutModelImplCopyWith<$Res>
    implements $NotifyLoginoutTypeCopyWith<$Res> {
  factory _$$NotifyLoginoutModelImplCopyWith(_$NotifyLoginoutModelImpl value,
          $Res Function(_$NotifyLoginoutModelImpl) then) =
      __$$NotifyLoginoutModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? playerId,
      String? playerObjId,
      String? serviceName,
      String? messageType,
      bool? isBlacklisted});
}

/// @nodoc
class __$$NotifyLoginoutModelImplCopyWithImpl<$Res>
    extends _$NotifyLoginoutTypeCopyWithImpl<$Res, _$NotifyLoginoutModelImpl>
    implements _$$NotifyLoginoutModelImplCopyWith<$Res> {
  __$$NotifyLoginoutModelImplCopyWithImpl(_$NotifyLoginoutModelImpl _value,
      $Res Function(_$NotifyLoginoutModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotifyLoginoutType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = freezed,
    Object? playerObjId = freezed,
    Object? serviceName = freezed,
    Object? messageType = freezed,
    Object? isBlacklisted = freezed,
  }) {
    return _then(_$NotifyLoginoutModelImpl(
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      playerObjId: freezed == playerObjId
          ? _value.playerObjId
          : playerObjId // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceName: freezed == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      messageType: freezed == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String?,
      isBlacklisted: freezed == isBlacklisted
          ? _value.isBlacklisted
          : isBlacklisted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotifyLoginoutModelImpl
    with DiagnosticableTreeMixin
    implements _NotifyLoginoutModel {
  _$NotifyLoginoutModelImpl(
      {this.playerId,
      this.playerObjId,
      this.serviceName,
      this.messageType,
      this.isBlacklisted});

  factory _$NotifyLoginoutModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotifyLoginoutModelImplFromJson(json);

  @override
  final String? playerId;
  @override
  final String? playerObjId;
  @override
  final String? serviceName;
  @override
  final String? messageType;

  /// 是否为黑名单
  @override
  final bool? isBlacklisted;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotifyLoginoutType(playerId: $playerId, playerObjId: $playerObjId, serviceName: $serviceName, messageType: $messageType, isBlacklisted: $isBlacklisted)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NotifyLoginoutType'))
      ..add(DiagnosticsProperty('playerId', playerId))
      ..add(DiagnosticsProperty('playerObjId', playerObjId))
      ..add(DiagnosticsProperty('serviceName', serviceName))
      ..add(DiagnosticsProperty('messageType', messageType))
      ..add(DiagnosticsProperty('isBlacklisted', isBlacklisted));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotifyLoginoutModelImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerObjId, playerObjId) ||
                other.playerObjId == playerObjId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.isBlacklisted, isBlacklisted) ||
                other.isBlacklisted == isBlacklisted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, playerId, playerObjId,
      serviceName, messageType, isBlacklisted);

  /// Create a copy of NotifyLoginoutType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotifyLoginoutModelImplCopyWith<_$NotifyLoginoutModelImpl> get copyWith =>
      __$$NotifyLoginoutModelImplCopyWithImpl<_$NotifyLoginoutModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotifyLoginoutModelImplToJson(
      this,
    );
  }
}

abstract class _NotifyLoginoutModel implements NotifyLoginoutType {
  factory _NotifyLoginoutModel(
      {final String? playerId,
      final String? playerObjId,
      final String? serviceName,
      final String? messageType,
      final bool? isBlacklisted}) = _$NotifyLoginoutModelImpl;

  factory _NotifyLoginoutModel.fromJson(Map<String, dynamic> json) =
      _$NotifyLoginoutModelImpl.fromJson;

  @override
  String? get playerId;
  @override
  String? get playerObjId;
  @override
  String? get serviceName;
  @override
  String? get messageType;

  /// 是否为黑名单
  @override
  bool? get isBlacklisted;

  /// Create a copy of NotifyLoginoutType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotifyLoginoutModelImplCopyWith<_$NotifyLoginoutModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
