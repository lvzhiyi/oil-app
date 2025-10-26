import 'package:dio/dio.dart';
import 'package:lottery_app/pages/gift_records/model/gift_records_response.dart';
import 'package:retrofit/retrofit.dart';

part 'gift_records_service.g.dart';

@RestApi()
abstract class GiftRecordsService {
  factory GiftRecordsService(Dio dio, {String baseUrl}) = _GiftRecordsService;

  /// 获取赠送记录列表
  @GET('/lottery-temp-coupons/records')
  Future<GiftRecordsResponse> getGiftRecords(
    @Queries() Map<String, dynamic> queries,
  );
}
