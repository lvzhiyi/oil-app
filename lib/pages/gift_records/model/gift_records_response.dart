import 'package:json_annotation/json_annotation.dart';
part 'gift_records_response.g.dart';

@JsonSerializable()
class GiftRecordsResponse {
  GiftRecordsData? data;
  int? code;
  String? message;
  String? requestId;

  GiftRecordsResponse({
    this.data,
    this.code,
    this.message,
    this.requestId,
  });

  factory GiftRecordsResponse.fromJson(Map<String, dynamic> json) =>
      _$GiftRecordsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GiftRecordsResponseToJson(this);

  GiftRecordsResponse copyWith({
    GiftRecordsData? data,
    int? code,
    String? message,
    String? requestId,
  }) {
    return GiftRecordsResponse(
      data: data ?? this.data,
      code: code ?? this.code,
      message: message ?? this.message,
      requestId: requestId ?? this.requestId,
    );
  }
}

@JsonSerializable()
class GiftRecordsData {
  List<GiftRecordItem>? list;
  int? total;

  GiftRecordsData({
    this.list,
    this.total,
  });

  factory GiftRecordsData.fromJson(Map<String, dynamic> json) => _$GiftRecordsDataFromJson(json);

  Map<String, dynamic> toJson() => _$GiftRecordsDataToJson(this);

  GiftRecordsData copyWith({
    List<GiftRecordItem>? list,
    int? total,
  }) {
    return GiftRecordsData(
      list: list ?? this.list,
      total: total ?? this.total,
    );
  }
}

@JsonSerializable()
class GiftRecordItem {
  int? id;
  int? createTime;
  String? createdBy;
  GiftRecordCreator? creator;
  String? tenantUuid;
  int? lotteryType;
  String? type;
  String? originCode;
  String? num;
  GiftRecordTenant? tenant;
  int? receiveCount;

  GiftRecordItem({
    this.id,
    this.createTime,
    this.createdBy,
    this.creator,
    this.tenantUuid,
    this.lotteryType,
    this.type,
    this.originCode,
    this.num,
    this.tenant,
    this.receiveCount,
  });

  factory GiftRecordItem.fromJson(Map<String, dynamic> json) => _$GiftRecordItemFromJson(json);

  Map<String, dynamic> toJson() => _$GiftRecordItemToJson(this);

  GiftRecordItem copyWith({
    int? id,
    int? createTime,
    String? createdBy,
    GiftRecordCreator? creator,
    String? tenantUuid,
    int? lotteryType,
    String? type,
    String? originCode,
    String? num,
    GiftRecordTenant? tenant,
    int? receiveCount,
  }) {
    return GiftRecordItem(
      id: id ?? this.id,
      createTime: createTime ?? this.createTime,
      createdBy: createdBy ?? this.createdBy,
      creator: creator ?? this.creator,
      tenantUuid: tenantUuid ?? this.tenantUuid,
      lotteryType: lotteryType ?? this.lotteryType,
      type: type ?? this.type,
      originCode: originCode ?? this.originCode,
      num: num ?? this.num,
      tenant: tenant ?? this.tenant,
      receiveCount: receiveCount ?? this.receiveCount,
    );
  }
}

@JsonSerializable()
class GiftRecordCreator {
  int? id;
  String? uuid;
  String? username;

  GiftRecordCreator({
    this.id,
    this.uuid,
    this.username,
  });

  factory GiftRecordCreator.fromJson(Map<String, dynamic> json) =>
      _$GiftRecordCreatorFromJson(json);

  Map<String, dynamic> toJson() => _$GiftRecordCreatorToJson(this);

  GiftRecordCreator copyWith({
    int? id,
    String? uuid,
    String? username,
  }) {
    return GiftRecordCreator(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
    );
  }
}

@JsonSerializable()
class GiftRecordTenant {
  int? id;
  String? uuid;
  String? name;

  GiftRecordTenant({
    this.id,
    this.uuid,
    this.name,
  });

  factory GiftRecordTenant.fromJson(Map<String, dynamic> json) => _$GiftRecordTenantFromJson(json);

  Map<String, dynamic> toJson() => _$GiftRecordTenantToJson(this);

  GiftRecordTenant copyWith({
    int? id,
    String? uuid,
    String? name,
  }) {
    return GiftRecordTenant(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
    );
  }
}
