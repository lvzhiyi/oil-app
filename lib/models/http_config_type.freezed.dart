// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_config_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HttpConfigType implements DiagnosticableTreeMixin {
  /// 0关 1开
  int? get canVisit;
  String? get endTime;
  String? get startTime;
  String? get tip;

  /// Create a copy of HttpConfigType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HttpConfigTypeCopyWith<HttpConfigType> get copyWith =>
      _$HttpConfigTypeCopyWithImpl<HttpConfigType>(
          this as HttpConfigType, _$identity);

  /// Serializes this HttpConfigType to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is HttpConfigType &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HttpConfigType(canVisit: $canVisit, endTime: $endTime, startTime: $startTime, tip: $tip)';
  }
}

/// @nodoc
abstract mixin class $HttpConfigTypeCopyWith<$Res> {
  factory $HttpConfigTypeCopyWith(
          HttpConfigType value, $Res Function(HttpConfigType) _then) =
      _$HttpConfigTypeCopyWithImpl;
  @useResult
  $Res call({int? canVisit, String? endTime, String? startTime, String? tip});
}

/// @nodoc
class _$HttpConfigTypeCopyWithImpl<$Res>
    implements $HttpConfigTypeCopyWith<$Res> {
  _$HttpConfigTypeCopyWithImpl(this._self, this._then);

  final HttpConfigType _self;
  final $Res Function(HttpConfigType) _then;

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
    return _then(_self.copyWith(
      canVisit: freezed == canVisit
          ? _self.canVisit
          : canVisit // ignore: cast_nullable_to_non_nullable
              as int?,
      endTime: freezed == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      tip: freezed == tip
          ? _self.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HttpConfigType].
extension HttpConfigTypePatterns on HttpConfigType {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HttpConfigType value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HttpConfigType() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HttpConfigType value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HttpConfigType():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HttpConfigType value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HttpConfigType() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int? canVisit, String? endTime, String? startTime, String? tip)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HttpConfigType() when $default != null:
        return $default(
            _that.canVisit, _that.endTime, _that.startTime, _that.tip);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int? canVisit, String? endTime, String? startTime, String? tip)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HttpConfigType():
        return $default(
            _that.canVisit, _that.endTime, _that.startTime, _that.tip);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int? canVisit, String? endTime, String? startTime, String? tip)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HttpConfigType() when $default != null:
        return $default(
            _that.canVisit, _that.endTime, _that.startTime, _that.tip);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HttpConfigType with DiagnosticableTreeMixin implements HttpConfigType {
  _HttpConfigType({this.canVisit, this.endTime, this.startTime, this.tip});
  factory _HttpConfigType.fromJson(Map<String, dynamic> json) =>
      _$HttpConfigTypeFromJson(json);

  /// 0关 1开
  @override
  final int? canVisit;
  @override
  final String? endTime;
  @override
  final String? startTime;
  @override
  final String? tip;

  /// Create a copy of HttpConfigType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HttpConfigTypeCopyWith<_HttpConfigType> get copyWith =>
      __$HttpConfigTypeCopyWithImpl<_HttpConfigType>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HttpConfigTypeToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is _HttpConfigType &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HttpConfigType(canVisit: $canVisit, endTime: $endTime, startTime: $startTime, tip: $tip)';
  }
}

/// @nodoc
abstract mixin class _$HttpConfigTypeCopyWith<$Res>
    implements $HttpConfigTypeCopyWith<$Res> {
  factory _$HttpConfigTypeCopyWith(
          _HttpConfigType value, $Res Function(_HttpConfigType) _then) =
      __$HttpConfigTypeCopyWithImpl;
  @override
  @useResult
  $Res call({int? canVisit, String? endTime, String? startTime, String? tip});
}

/// @nodoc
class __$HttpConfigTypeCopyWithImpl<$Res>
    implements _$HttpConfigTypeCopyWith<$Res> {
  __$HttpConfigTypeCopyWithImpl(this._self, this._then);

  final _HttpConfigType _self;
  final $Res Function(_HttpConfigType) _then;

  /// Create a copy of HttpConfigType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? canVisit = freezed,
    Object? endTime = freezed,
    Object? startTime = freezed,
    Object? tip = freezed,
  }) {
    return _then(_HttpConfigType(
      canVisit: freezed == canVisit
          ? _self.canVisit
          : canVisit // ignore: cast_nullable_to_non_nullable
              as int?,
      endTime: freezed == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      tip: freezed == tip
          ? _self.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
