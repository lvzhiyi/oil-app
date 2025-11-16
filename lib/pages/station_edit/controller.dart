import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/global/model/common_req_type.dart';
import 'package:oil_business_app/global/model/station_req_type.dart';
import 'package:oil_business_app/global/service/common_service.dart';
import 'package:oil_business_app/global/service/station_service.dart';
import 'package:oil_business_app/pages/station_edit/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

class StationEditCtrl extends Cubit<StationEditState> {
  StationEditCtrl({String? stationId}) : super(StationEditState()) {
    _stationId = stationId;
    if (stationId != null) {
      initState(stationId);
    }
  }

  String? _stationId;

  void initState(String stationId) {
    // TODO: 从API加载加油站信息
    // 目前保持空状态，等待后续实现
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

    if (state.provinceCode.isEmpty || state.cityCode.isEmpty || state.areaCode.isEmpty) {
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

    emit(state.copyWith(isLoading: true, hasError: false, errorMessage: null));

    try {
      String businessLicenseUrl = state.businessLicenseUrl;
      String fuelRetailPermitUrl = state.fuelRetailPermitUrl;

      if (businessLicenseUrl.isNotEmpty && !businessLicenseUrl.startsWith('http')) {
        final uploadedUrl = await uploadImage(businessLicenseUrl);
        if (uploadedUrl == null) {
          SportsToast.showWarning('上传营业执照失败，请稍后重试');
          emit(state.copyWith(isLoading: false));
          return false;
        }
        businessLicenseUrl = uploadedUrl;
      }

      if (fuelRetailPermitUrl.isNotEmpty && !fuelRetailPermitUrl.startsWith('http')) {
        final uploadedUrl = await uploadImage(fuelRetailPermitUrl);
        if (uploadedUrl == null) {
          SportsToast.showWarning('上传成品油零售许可失败，请稍后重试');
          emit(state.copyWith(isLoading: false));
          return false;
        }
        fuelRetailPermitUrl = uploadedUrl;
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
      BaseRouter.pop();
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

  Future<String?> uploadImage(String url) async {
    try {
      final contentLength = await XFile(url).readAsBytes();
      final contentType = XFile(url).mimeType ?? 'image/jpeg';
      final response = await commonService.getUploadSignature(
        UploadSignatureRequest(
          bizPrefix: 'stations',
          contentType: contentType,
          contentLength: contentLength.length,
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
    } catch (e) {
      l.e('StationEditCtrl', '图片上传失败: $e');
      return null;
    }
  }
}

