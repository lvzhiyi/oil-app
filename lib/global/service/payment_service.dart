import 'package:dio/dio.dart';
import 'package:oil_business_app/config/address.dart';
import 'package:oil_business_app/global/model/bank_info_model.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'payment_service.g.dart';

/// 支付相关服务API（使用 /app/ 前缀）
@RestApi()
abstract class PaymentService {
  factory PaymentService(Dio dio, {String baseUrl}) = _PaymentService;

  /// 获取对公转账银行信息
  @GET('/payment/bank-info')
  Future<BankInfoModel> getBankInfo();
}

/// 获取PaymentService实例
PaymentService get paymentService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return PaymentService(
    netManager.clientDio!,
    baseUrl: BaseAddress.baseApiPath,
  );
}
