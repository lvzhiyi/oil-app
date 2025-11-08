import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/model/common_req_type.dart';
import 'package:oil_business_app/global/model/station_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/global/service/common_service.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

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
    final reqParams = BindStationRequest(
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
    l.d('Register', '开始注册: reqParams.toJson(): ${reqParams.toJson()}');
    emit(state.copyWith(loading: false));

    // final response = await stationService.bindStation(reqParams);
    // BaseConfig.appContext?.read<AppController>().setAuthResponse(response);
    // BaseRouter.replace(url: AppPage.mainLayoutPage.path);
  }

  uploadImage(String url) async {
    final response = await commonService.getUploadSignature(
      UploadSignatureRequest(
        bizPrefix: 'stations',
        contentType: 'image/jpeg',
        contentLength: url.length,
      ),
    );
    return response;
  }

  /// 收起键盘
  void unFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
