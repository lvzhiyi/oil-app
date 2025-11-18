import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/model/common_req_type.dart';
import 'package:oil_business_app/global/service/common_service.dart';
import 'package:oil_business_app/utils/file_util.dart';
import 'package:oil_business_app/utils/log.dart';

Future<String?> uploadImage(String url) async {
  final xFile = XFile(url);
  final contentBytes = await xFile.readAsBytes();
  final contentType = FileUtil.getContentType(xFile.mimeType, url);

  final response = await commonService.getUploadSignature(
    UploadSignatureRequest(
      bizPrefix: 'stations',
      contentType: contentType,
      contentLength: contentBytes.length,
    ),
  );

  if (response.host == null || response.host!.isEmpty) {
    l.e('uploadImage', '上传签名返回的host为空');
    return null;
  }

  if (response.path == null || response.path!.isEmpty) {
    l.e('uploadImage', '上传签名返回的path为空');
    return null;
  }

  final formData = FormData.fromMap({
    'policy': response.policy,
    'x-oss-signature-version': response.signatureVersion,
    'x-oss-credential': response.credential,
    'x-oss-date': response.date,
    'success_action_status': '200',
    'key': response.path,
    'x-oss-signature': response.signature,
    'x-oss-security-token': response.securityToken,
    'file': await MultipartFile.fromFile(
      url,
      filename: url.split('/').last,
    ),
  });

  try {
    final uploadResponse = await Dio().post(
      response.host!,
      data: formData,
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${BaseConfig.appContext?.read<AppController>().state.authResponse?.accessToken}',
        },
      ),
    );

    if (uploadResponse.statusCode != 200) {
      l.e('uploadImage',
          '上传失败，状态码: ${uploadResponse.statusCode}, 响应: ${uploadResponse.data}');
      return null;
    }
    return '${response.host}/${response.path}';
  } catch (e) {
    l.e('uploadImage', '上传异常: $e');
    return null;
  }
}
