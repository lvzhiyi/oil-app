// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel {
  int? get id;
  set id(int? value);
  String? get orderNo;
  set orderNo(String? value);
  @JsonKey(fromJson: OrderStatus.fromValue)
  OrderStatus? get status;
  @JsonKey(fromJson: OrderStatus.fromValue)
  set status(OrderStatus? value);
  int? get depotId;
  set depotId(int? value);
  String? get depotName;
  set depotName(String? value);
  String? get fuelType;
  set fuelType(String? value);
  double? get fuelPriceCny;
  set fuelPriceCny(double? value);
  double? get purchaseTon;
  set purchaseTon(double? value);
  double? get totalAmount;
  set totalAmount(double? value);
  String? get createdAt;
  set createdAt(String? value);
  String? get updatedAt;
  set updatedAt(String? value);
  String? get accountName;
  set accountName(String? value);
  String? get bankAccount;
  set bankAccount(String? value);
  String? get bankName;
  set bankName(String? value);
  String? get bankBranchNumber;
  set bankBranchNumber(String? value);
  String? get remark;
  set remark(String? value);
  double? get availableInventory;
  set availableInventory(double? value);
  List<String>? get paymentProofUrls;
  set paymentProofUrls(List<String>? value);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<OrderModel> get copyWith =>
      _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNo: $orderNo, status: $status, depotId: $depotId, depotName: $depotName, fuelType: $fuelType, fuelPriceCny: $fuelPriceCny, purchaseTon: $purchaseTon, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt, accountName: $accountName, bankAccount: $bankAccount, bankName: $bankName, bankBranchNumber: $bankBranchNumber, remark: $remark, availableInventory: $availableInventory, paymentProofUrls: $paymentProofUrls)';
  }
}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) _then) =
      _$OrderModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orderNo,
      @JsonKey(fromJson: OrderStatus.fromValue) OrderStatus? status,
      int? depotId,
      String? depotName,
      String? fuelType,
      double? fuelPriceCny,
      double? purchaseTon,
      double? totalAmount,
      String? createdAt,
      String? updatedAt,
      String? accountName,
      String? bankAccount,
      String? bankName,
      String? bankBranchNumber,
      String? remark,
      double? availableInventory,
      List<String>? paymentProofUrls});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res> implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? status = freezed,
    Object? depotId = freezed,
    Object? depotName = freezed,
    Object? fuelType = freezed,
    Object? fuelPriceCny = freezed,
    Object? purchaseTon = freezed,
    Object? totalAmount = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? accountName = freezed,
    Object? bankAccount = freezed,
    Object? bankName = freezed,
    Object? bankBranchNumber = freezed,
    Object? remark = freezed,
    Object? availableInventory = freezed,
    Object? paymentProofUrls = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _self.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus?,
      depotId: freezed == depotId
          ? _self.depotId
          : depotId // ignore: cast_nullable_to_non_nullable
              as int?,
      depotName: freezed == depotName
          ? _self.depotName
          : depotName // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelPriceCny: freezed == fuelPriceCny
          ? _self.fuelPriceCny
          : fuelPriceCny // ignore: cast_nullable_to_non_nullable
              as double?,
      purchaseTon: freezed == purchaseTon
          ? _self.purchaseTon
          : purchaseTon // ignore: cast_nullable_to_non_nullable
              as double?,
      totalAmount: freezed == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      accountName: freezed == accountName
          ? _self.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _self.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankBranchNumber: freezed == bankBranchNumber
          ? _self.bankBranchNumber
          : bankBranchNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _self.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      availableInventory: freezed == availableInventory
          ? _self.availableInventory
          : availableInventory // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentProofUrls: freezed == paymentProofUrls
          ? _self.paymentProofUrls
          : paymentProofUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
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
    TResult Function(_OrderModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
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
    TResult Function(_OrderModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel():
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
    TResult? Function(_OrderModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
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
            int? id,
            String? orderNo,
            @JsonKey(fromJson: OrderStatus.fromValue) OrderStatus? status,
            int? depotId,
            String? depotName,
            String? fuelType,
            double? fuelPriceCny,
            double? purchaseTon,
            double? totalAmount,
            String? createdAt,
            String? updatedAt,
            String? accountName,
            String? bankAccount,
            String? bankName,
            String? bankBranchNumber,
            String? remark,
            double? availableInventory,
            List<String>? paymentProofUrls)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
        return $default(
            _that.id,
            _that.orderNo,
            _that.status,
            _that.depotId,
            _that.depotName,
            _that.fuelType,
            _that.fuelPriceCny,
            _that.purchaseTon,
            _that.totalAmount,
            _that.createdAt,
            _that.updatedAt,
            _that.accountName,
            _that.bankAccount,
            _that.bankName,
            _that.bankBranchNumber,
            _that.remark,
            _that.availableInventory,
            _that.paymentProofUrls);
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
            int? id,
            String? orderNo,
            @JsonKey(fromJson: OrderStatus.fromValue) OrderStatus? status,
            int? depotId,
            String? depotName,
            String? fuelType,
            double? fuelPriceCny,
            double? purchaseTon,
            double? totalAmount,
            String? createdAt,
            String? updatedAt,
            String? accountName,
            String? bankAccount,
            String? bankName,
            String? bankBranchNumber,
            String? remark,
            double? availableInventory,
            List<String>? paymentProofUrls)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel():
        return $default(
            _that.id,
            _that.orderNo,
            _that.status,
            _that.depotId,
            _that.depotName,
            _that.fuelType,
            _that.fuelPriceCny,
            _that.purchaseTon,
            _that.totalAmount,
            _that.createdAt,
            _that.updatedAt,
            _that.accountName,
            _that.bankAccount,
            _that.bankName,
            _that.bankBranchNumber,
            _that.remark,
            _that.availableInventory,
            _that.paymentProofUrls);
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
            int? id,
            String? orderNo,
            @JsonKey(fromJson: OrderStatus.fromValue) OrderStatus? status,
            int? depotId,
            String? depotName,
            String? fuelType,
            double? fuelPriceCny,
            double? purchaseTon,
            double? totalAmount,
            String? createdAt,
            String? updatedAt,
            String? accountName,
            String? bankAccount,
            String? bankName,
            String? bankBranchNumber,
            String? remark,
            double? availableInventory,
            List<String>? paymentProofUrls)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
        return $default(
            _that.id,
            _that.orderNo,
            _that.status,
            _that.depotId,
            _that.depotName,
            _that.fuelType,
            _that.fuelPriceCny,
            _that.purchaseTon,
            _that.totalAmount,
            _that.createdAt,
            _that.updatedAt,
            _that.accountName,
            _that.bankAccount,
            _that.bankName,
            _that.bankBranchNumber,
            _that.remark,
            _that.availableInventory,
            _that.paymentProofUrls);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrderModel implements OrderModel {
  _OrderModel(
      {this.id,
      this.orderNo,
      @JsonKey(fromJson: OrderStatus.fromValue) this.status,
      this.depotId,
      this.depotName,
      this.fuelType,
      this.fuelPriceCny,
      this.purchaseTon,
      this.totalAmount,
      this.createdAt,
      this.updatedAt,
      this.accountName,
      this.bankAccount,
      this.bankName,
      this.bankBranchNumber,
      this.remark,
      this.availableInventory,
      this.paymentProofUrls});
  factory _OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  @override
  int? id;
  @override
  String? orderNo;
  @override
  @JsonKey(fromJson: OrderStatus.fromValue)
  OrderStatus? status;
  @override
  int? depotId;
  @override
  String? depotName;
  @override
  String? fuelType;
  @override
  double? fuelPriceCny;
  @override
  double? purchaseTon;
  @override
  double? totalAmount;
  @override
  String? createdAt;
  @override
  String? updatedAt;
  @override
  String? accountName;
  @override
  String? bankAccount;
  @override
  String? bankName;
  @override
  String? bankBranchNumber;
  @override
  String? remark;
  @override
  double? availableInventory;
  @override
  List<String>? paymentProofUrls;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderModelCopyWith<_OrderModel> get copyWith =>
      __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderModelToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNo: $orderNo, status: $status, depotId: $depotId, depotName: $depotName, fuelType: $fuelType, fuelPriceCny: $fuelPriceCny, purchaseTon: $purchaseTon, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt, accountName: $accountName, bankAccount: $bankAccount, bankName: $bankName, bankBranchNumber: $bankBranchNumber, remark: $remark, availableInventory: $availableInventory, paymentProofUrls: $paymentProofUrls)';
  }
}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(
          _OrderModel value, $Res Function(_OrderModel) _then) =
      __$OrderModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orderNo,
      @JsonKey(fromJson: OrderStatus.fromValue) OrderStatus? status,
      int? depotId,
      String? depotName,
      String? fuelType,
      double? fuelPriceCny,
      double? purchaseTon,
      double? totalAmount,
      String? createdAt,
      String? updatedAt,
      String? accountName,
      String? bankAccount,
      String? bankName,
      String? bankBranchNumber,
      String? remark,
      double? availableInventory,
      List<String>? paymentProofUrls});
}

/// @nodoc
class __$OrderModelCopyWithImpl<$Res> implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? status = freezed,
    Object? depotId = freezed,
    Object? depotName = freezed,
    Object? fuelType = freezed,
    Object? fuelPriceCny = freezed,
    Object? purchaseTon = freezed,
    Object? totalAmount = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? accountName = freezed,
    Object? bankAccount = freezed,
    Object? bankName = freezed,
    Object? bankBranchNumber = freezed,
    Object? remark = freezed,
    Object? availableInventory = freezed,
    Object? paymentProofUrls = freezed,
  }) {
    return _then(_OrderModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _self.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus?,
      depotId: freezed == depotId
          ? _self.depotId
          : depotId // ignore: cast_nullable_to_non_nullable
              as int?,
      depotName: freezed == depotName
          ? _self.depotName
          : depotName // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelPriceCny: freezed == fuelPriceCny
          ? _self.fuelPriceCny
          : fuelPriceCny // ignore: cast_nullable_to_non_nullable
              as double?,
      purchaseTon: freezed == purchaseTon
          ? _self.purchaseTon
          : purchaseTon // ignore: cast_nullable_to_non_nullable
              as double?,
      totalAmount: freezed == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      accountName: freezed == accountName
          ? _self.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _self.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankBranchNumber: freezed == bankBranchNumber
          ? _self.bankBranchNumber
          : bankBranchNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _self.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      availableInventory: freezed == availableInventory
          ? _self.availableInventory
          : availableInventory // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentProofUrls: freezed == paymentProofUrls
          ? _self.paymentProofUrls
          : paymentProofUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

// dart format on
