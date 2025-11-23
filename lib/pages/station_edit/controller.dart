import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/commom/upload.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_req_type.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/pages/station_edit/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

class StationEditCtrl extends Cubit<StationEditState> {
  StationEditCtrl({Station? station, bool isFromPendingReview = false})
      : super(StationEditState()) {
    _isFromPendingReview = isFromPendingReview;
    if (station != null) {
      initState(station);
    }
  }

  String? _stationId;
  bool _isFromPendingReview = false;
  
  void initState(Station station) {
    _stationId = station.idString;
    
    final businessLicenseUrl = station.businessLicenseUrl ?? '';
    final fuelRetailPermitUrl = station.fuelRetailPermitUrl ?? '';

    emit(state.copyWith(
      station: station,
      name: station.stationName ?? '',
      provinceName: station.provinceName ?? '',
      cityName: station.cityName ?? '',
      areaName: station.areaName ?? '',
      provinceCode: station.provinceCode ?? '',
      cityCode: station.cityCode ?? '',
      areaCode: station.areaCode ?? '',
      addressDetail: station.addressDetail ?? '',
      businessLicenseUrl: businessLicenseUrl,
      fuelRetailPermitUrl: fuelRetailPermitUrl,
      originalBusinessLicenseUrl: businessLicenseUrl,
      originalFuelRetailPermitUrl: fuelRetailPermitUrl,
      isLoading: false,
    ));
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  /// 更新省市区信息
  /// 参数顺序：provinceName, cityName, areaName, provinceCode, cityCode, areaCode
  /// 遵循 KISS 原则，直接解构数组参数
  void updateCityData(List<dynamic> cityData) {
    if (cityData.length >= 6) {
      emit(state.copyWith(
        provinceName: cityData[0] as String,
        cityName: cityData[1] as String,
        areaName: cityData[2] as String,
        provinceCode: cityData[3] as String,
        cityCode: cityData[4] as String,
        areaCode: cityData[5] as String,
      ));
    }
  }

  void updateAddressDetail(String addressDetail) {
    emit(state.copyWith(addressDetail: addressDetail));
  }

  void updateBusinessLicenseUrl(String url) {
    emit(state.copyWith(businessLicenseUrl: url));
  }

  void updateFuelRetailPermitUrl(String url) {
    emit(state.copyWith(fuelRetailPermitUrl: url));
  }

  Future<bool> save(BuildContext context) async {
    if (state.name.isEmpty) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: '请输入加油站名称',
      ));
      return false;
    }

    if (state.provinceCode.isEmpty ||
        state.cityCode.isEmpty ||
        state.areaCode.isEmpty) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: '请选择省市区',
      ));
      return false;
    }

    if (state.addressDetail.isEmpty) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: '请输入详细地址',
      ));
      return false;
    }

    if (_stationId != null && state.station?.status == StationStatus.active) {
      final completer = Completer<bool>();

      SportsDialog.show(
        title: '提示',
        bodyText: '修改信息后需要重新审核，加油站将暂时无法使用，确认继续吗？',
        cancelText: '取消',
        okText: '确认',
        onCancel: () {
          if (!completer.isCompleted) completer.complete(false);
        },
        onOk: () {
          SportsDialog.dismiss();
          if (!completer.isCompleted) completer.complete(true);
        },
      );

      final confirm = await completer.future;
      if (!confirm) {
        return false;
      }
    }

    emit(state.copyWith(isLoading: true, hasError: false, errorMessage: null));

    try {
      String businessLicenseUrl = state.businessLicenseUrl;
      String fuelRetailPermitUrl = state.fuelRetailPermitUrl;

      if (businessLicenseUrl.isNotEmpty) {
        if (businessLicenseUrl == state.originalBusinessLicenseUrl) {
          final queryIndex = businessLicenseUrl.indexOf('?');
          if (queryIndex != -1) {
            businessLicenseUrl = businessLicenseUrl.substring(0, queryIndex);
          }
        } else if (!businessLicenseUrl.startsWith('http')) {
          final uploadedUrl = await uploadImage(businessLicenseUrl);
          if (uploadedUrl == null) {
            SportsToast.showWarning('上传营业执照失败，请稍后重试');
            emit(state.copyWith(isLoading: false));
            return false;
          }
          businessLicenseUrl = uploadedUrl;
        }
      }

      if (fuelRetailPermitUrl.isNotEmpty) {
        if (fuelRetailPermitUrl == state.originalFuelRetailPermitUrl) {
          final queryIndex = fuelRetailPermitUrl.indexOf('?');
          if (queryIndex != -1) {
            fuelRetailPermitUrl = fuelRetailPermitUrl.substring(0, queryIndex);
          }
        } else if (!fuelRetailPermitUrl.startsWith('http')) {
          final uploadedUrl = await uploadImage(fuelRetailPermitUrl);
          if (uploadedUrl == null) {
            SportsToast.showWarning('上传成品油零售许可失败，请稍后重试');
            emit(state.copyWith(isLoading: false));
            return false;
          }
          fuelRetailPermitUrl = uploadedUrl;
        }
      }

      final reqParams = BindStationRequest(
        stationName: state.name,
        provinceCode: state.provinceCode,
        provinceName: state.provinceName,
        cityCode: state.cityCode,
        cityName: state.cityName,
        areaCode: state.areaCode,
        areaName: state.areaName,
        addressDetail: state.addressDetail,
        businessLicenseUrl: businessLicenseUrl,
        fuelRetailPermitUrl: fuelRetailPermitUrl,
      );

      if (_stationId == null) {
        await stationService.bindStation(reqParams);
        l.d('StationEditCtrl', '新增加油站成功');
      } else {
        await stationService.updateStation(_stationId!, reqParams);
        l.d('StationEditCtrl', '编辑加油站成功: $_stationId');
      }

      emit(state.copyWith(
        isLoading: false,
        hasError: false,
      ));

      SportsToast.showSuccess('保存成功');
      if (_isFromPendingReview) {
        BaseRouter.popAndPush(url: AppPage.pendingReviewPage.path, extra: {
          'station':
              state.station?.copyWith(status: StationStatus.pending_review),
        });
      } else {
        BaseRouter.pop(result: {'refresh': true});
      }
      return true;
    } catch (e) {
      l.e('StationEditCtrl', '保存失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
      SportsToast.showError('保存失败，请稍后重试');
      return false;
    }
  }
}
