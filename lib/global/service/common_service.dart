import 'package:dio/dio.dart';
import 'package:oil_business_app/config/address.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/model/common_req_type.dart';
import 'package:oil_business_app/global/model/common_response_type.dart';
import 'package:oil_business_app/net/net_manager.dart';
import 'package:retrofit/retrofit.dart';

part 'common_service.g.dart';

@RestApi()
abstract class CommonService {
  factory CommonService(Dio dio, {String baseUrl}) = _CommonService;

  /// 获取上传签名接口
  @POST('/upload/signature')
  Future<UploadSignatureResponse> getUploadSignature(
      @Body() UploadSignatureRequest request);
}

/// 获取CommonService实例，确保网络管理器已初始化
CommonService get commonService => CommonService(
      netManager.clientDio ?? Dio(),
      baseUrl: BaseAddress.commonBaseHost,
    );
