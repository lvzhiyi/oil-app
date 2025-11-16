import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/model/common_req_type.dart';
import 'package:oil_business_app/global/model/station_req_type.dart';
import 'package:oil_business_app/global/service/common_service.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

import 'state.dart';

class BindStationCtrl extends Cubit<BindStationState> {
  BindStationCtrl({this.extra})
      : super(
          BindStationState(),
        ) {
    initState();
  }
  final Map<String, dynamic>? extra;

  final formKey = GlobalKey<FormBuilderState>();

  final cityController = TextEditingController();

  String provinceCode = '';
  String provinceName = '';
  String cityCode = '';
  String cityName = '';
  String areaCode = '';
  String areaName = '';
  String businessLicenseUrl = '';
  String fuelRetailPermitUrl = '';

  initState() async {
    print('extra: $extra');
  }

  /// 注册前置检查
  bool registerPrecheck() {
    if (state.loading) return false;
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  submit() async {
    if (!registerPrecheck()) return;

    emit(state.copyWith(loading: true));

    // 获取表单数据
    final formData = formKey.currentState?.value ?? {};
    final _reqParams = BindStationRequest(
      stationName: formData['stationName'] ?? '',
      provinceCode: provinceCode,
      provinceName: provinceName,
      cityCode: cityCode,
      cityName: cityName,
      areaCode: areaCode,
      areaName: areaName,
      addressDetail: formData['addressDetail'] ?? '',
      businessLicenseUrl: businessLicenseUrl,
      fuelRetailPermitUrl: fuelRetailPermitUrl,
    );
    l.d('Register', '开始注册: reqParams.toJson(): ${_reqParams.toJson()}');
    try {
      final uploadResult = await Future.wait([
        uploadImage(businessLicenseUrl),
        uploadImage(fuelRetailPermitUrl),
      ]);

      if (uploadResult.any((element) => element == null)) {
        SportsToast.showWarning('上传图片失败, 清稍后重试');
        emit(state.copyWith(loading: false));
        return;
      }

      final reqParams = _reqParams.copyWith(
        businessLicenseUrl: uploadResult[0],
        fuelRetailPermitUrl: uploadResult[1],
      );

      final response = await stationService.bindStation(reqParams);
      BaseConfig.appContext?.read<AppController>().setAuthResponse(response);
      BaseRouter.replace(url: AppPage.pendingReviewPage.path);
    } catch (e) {
      emit(state.copyWith(loading: false));
    }
  }

  Future<String?> uploadImage(String url) async {
    final contenLength = await XFile(url).readAsBytes();
    final contentType = XFile(url).mimeType ?? 'image/jpeg';
    final response = await commonService.getUploadSignature(
      UploadSignatureRequest(
        bizPrefix: 'stations',
        contentType: contentType,
        contentLength: contenLength.length,
      ),
    );

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(url),
      'policy': response.policy,
      'x-oss-signature-version': response.signatureVersion,
      'x-oss-credential': response.credential,
      'x-oss-date': response.date,
      'success_action_status': '200',
      'key': response.path,
      'x-oss-signature': response.signature,
      'x-oss-security-token': response.securityToken,
    });

    final uploadResponse = await Dio(BaseOptions(baseUrl: response.host ?? ''))
        .post(response.host ?? '', data: formData);

    if (uploadResponse.statusCode != 200) {
      return null;
    }
    return '${response.host}${response.path}';
  }
}
