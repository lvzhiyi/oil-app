import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/global/model/common_req_type.dart';
import 'package:oil_business_app/global/service/common_service.dart';

Future<String?> uploadImage(String url) async {
  final contenLength = await XFile(url).readAsBytes();
  final contentType = XFile(url).mimeType ?? url.split('.').last;

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
  return '${response.host}/${response.path}';
}
