import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/commom/upload.dart';
import 'package:oil_business_app/global/model/station_req_type.dart';
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

      await stationService.bindStation(reqParams);
      SportsToast.showSuccess('绑定成功');
      await Future.delayed(const Duration(seconds: 1));
      BaseRouter.replace(url: AppPage.pendingReviewPage.path);
    } catch (e) {
      emit(state.copyWith(loading: false));
    }
  }
}
