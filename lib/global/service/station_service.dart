import 'package:dio/dio.dart';
import 'package:oil_business_app/global/model/station_req_type.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'station_service.g.dart';

@RestApi()
abstract class StationService {
  factory StationService(Dio dio, {String baseUrl}) = _StationService;

  /// 获取加油站列表
  @GET('/stations')
  Future<GetStationResponse> getStationStatus(
    @Query('page') int page,
    @Query('pageSize') int pageSize,
    @Query('statuses') List<String> statuses,
  );

  /// 新增加油站
  @POST('/stations')
  Future bindStation(@Body() BindStationRequest request);

  /// 编辑加油站
  @PUT('/stations/{id}')
  Future updateStation(
    @Path('id') String id,
    @Body() BindStationRequest request,
  );
}

/// 获取StationService实例，确保网络管理器已初始化
StationService get stationService =>
    StationService(netManager.clientDio ?? Dio());
