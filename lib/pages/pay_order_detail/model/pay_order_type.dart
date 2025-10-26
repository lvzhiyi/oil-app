import 'package:json_annotation/json_annotation.dart';
import 'package:lottery_app/global/enum/common.dart';
part 'pay_order_type.g.dart';

@JsonSerializable()
class OrderDetailResponse {
  PayOrderDetailModel? data;
  int? code;
  String? message;
  String? requestId;

  OrderDetailResponse({
    this.data,
    this.code,
    this.message,
    this.requestId,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailResponseToJson(this);

  OrderDetailResponse copyWith({
    PayOrderDetailModel? data,
    int? code,
    String? message,
    String? requestId,
  }) {
    return OrderDetailResponse(
      data: data ?? this.data,
      code: code ?? this.code,
      message: message ?? this.message,
      requestId: requestId ?? this.requestId,
    );
  }
}

@JsonSerializable()
class PayOrderDetailModel {
  int? id;
  int? createTime;
  int? updateTime;
  String? uuid;
  String? type;
  String? quota;
  int? lotteryType;
  String? payAmount;
  String? remark;
  String? paymentMethod;
  String? origin;
  String? status;
  String? tenantUuid;
  String? pCreatedBy;
  String? pUpdatedBy;
  String? tCreatedBy;
  String? tUpdatedBy;
  List<FileAttachment>? attachments;

  // 银行信息（用于转账）
  String? accountName;
  String? bankAccount;
  String? bankName;
  String? bankBranchNumber;
  String? voucherUrl;
  String? voucherPath;

  PayOrderDetailModel({
    this.id,
    this.createTime,
    this.updateTime,
    this.uuid,
    this.type,
    this.quota,
    this.lotteryType,
    this.payAmount,
    this.remark,
    this.paymentMethod,
    this.origin,
    this.status,
    this.tenantUuid,
    this.pCreatedBy,
    this.pUpdatedBy,
    this.tCreatedBy,
    this.tUpdatedBy,
    this.attachments,
    this.accountName,
    this.bankAccount,
    this.bankName,
    this.bankBranchNumber,
    this.voucherUrl,
    this.voucherPath,
  });

  factory PayOrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PayOrderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayOrderDetailModelToJson(this);

  PayOrderDetailModel copyWith({
    int? id,
    int? createTime,
    int? updateTime,
    String? uuid,
    String? type,
    String? quota,
    int? lotteryType,
    String? payAmount,
    String? remark,
    String? paymentMethod,
    String? origin,
    String? status,
    String? tenantUuid,
    String? pCreatedBy,
    String? pUpdatedBy,
    String? tCreatedBy,
    String? tUpdatedBy,
    List<FileAttachment>? attachments,
    String? accountName,
    String? bankAccount,
    String? bankName,
    String? bankBranchNumber,
    String? voucherUrl,
    String? voucherPath,
  }) {
    return PayOrderDetailModel(
      id: id ?? this.id,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      quota: quota ?? this.quota,
      lotteryType: lotteryType ?? this.lotteryType,
      payAmount: payAmount ?? this.payAmount,
      remark: remark ?? this.remark,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      origin: origin ?? this.origin,
      status: status ?? this.status,
      tenantUuid: tenantUuid ?? this.tenantUuid,
      pCreatedBy: pCreatedBy ?? this.pCreatedBy,
      pUpdatedBy: pUpdatedBy ?? this.pUpdatedBy,
      tCreatedBy: tCreatedBy ?? this.tCreatedBy,
      tUpdatedBy: tUpdatedBy ?? this.tUpdatedBy,
      attachments: attachments ?? this.attachments,
      accountName: accountName ?? this.accountName,
      bankAccount: bankAccount ?? this.bankAccount,
      bankName: bankName ?? this.bankName,
      bankBranchNumber: bankBranchNumber ?? this.bankBranchNumber,
      voucherUrl: voucherUrl ?? this.voucherUrl,
      voucherPath: voucherPath ?? this.voucherPath,
    );
  }

  /// 是否为套餐购买
  bool get isPackagePurchase => type == 'package';

  /// 是否为余额充值
  bool get isBalanceRecharge => type == 'balance';

  /// 是否已取消
  bool get isCanceled => status == 'canceled';

  /// 是否为未支付
  bool get isUnPaid => status == OrderStatus.Pending.value;

  /// 是否已上传凭证
  bool get isSubmitted => status == OrderStatus.Submitted.value;

  /// 是否已完成
  bool get isCompleted =>
      status == OrderStatus.Success.value ||
      status == OrderStatus.Canceled.value;
}

/// 取消充值请求体：{ "uuid": "..." }
@JsonSerializable()
class CancelRechargeRequest {
  final String status;

  const CancelRechargeRequest({required this.status});

  factory CancelRechargeRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelRechargeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CancelRechargeRequestToJson(this);
}

@JsonSerializable()
class UpdateOrderVoucherRequest {
  List<FileAttachment>? attachments;
  String? status;

  UpdateOrderVoucherRequest({
    this.attachments,
    this.status,
  });

  factory UpdateOrderVoucherRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderVoucherRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrderVoucherRequestToJson(this);

  UpdateOrderVoucherRequest copyWith({
    List<FileAttachment>? attachments,
    String? status,
  }) {
    return UpdateOrderVoucherRequest(
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
    );
  }
}

@JsonSerializable()
class FileAttachment {
  String? uuid;
  String? path;

  FileAttachment({
    this.uuid,
    this.path,
  });

  factory FileAttachment.fromJson(Map<String, dynamic> json) =>
      _$FileAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$FileAttachmentToJson(this);

  FileAttachment copyWith({
    String? uuid,
    String? path,
  }) {
    return FileAttachment(
      uuid: uuid ?? this.uuid,
      path: path ?? this.path,
    );
  }
}

/// 文件上传请求
class FileUploadRequest {
  /// 文件类型
  final String fileType;

  /// 上传方式
  final String method;

  /// 文件内容（二进制）
  final List<int> file;

  const FileUploadRequest({
    required this.fileType,
    required this.method,
    required this.file,
  });

  Map<String, dynamic> toJson() => {
        'fileType': fileType,
        'method': method,
        'file': file,
      };
}

/// 文件上传响应数据
@JsonSerializable()
class FileUploadData {
  /// 文件UUID
  final String? uuid;

  /// 文件路径
  final String? path;

  /// 文件类型
  final String? type;

  const FileUploadData({
    this.uuid,
    this.path,
    this.type,
  });

  factory FileUploadData.fromJson(Map<String, dynamic> json) =>
      _$FileUploadDataFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadDataToJson(this);
}

/// 文件上传响应
@JsonSerializable()
class FileUploadResponse {
  final int code;
  final String message;
  final FileUploadData data;
  final String? requestId;

  const FileUploadResponse({
    required this.code,
    required this.message,
    required this.data,
    this.requestId,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadResponseToJson(this);
}

/// 获取文件签名URL响应
@JsonSerializable()
class FileSignUrlResponse {
  final int code;
  final String message;
  final String? data;
  final String? requestId;

  const FileSignUrlResponse({
    required this.code,
    required this.message,
    this.data,
    this.requestId,
  });

  factory FileSignUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$FileSignUrlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileSignUrlResponseToJson(this);
}
