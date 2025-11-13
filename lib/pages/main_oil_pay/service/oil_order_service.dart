import 'package:dio/dio.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:retrofit/retrofit.dart';

part 'oil_order_service.g.dart';

@RestApi()
abstract class OilOrderService {
  factory OilOrderService(Dio dio, {String baseUrl}) = _OilOrderService;

  /// 获取油库列表
  @GET('/oil-depots')
  Future<GetOilStoreResponse> getOilStoreList(
      {required int page, required int pageSize});
}

/// 获取CommonService实例，确保网络管理器已初始化
OilOrderService get oilOrderService =>
    OilOrderService(netManager.clientDio ?? Dio());
