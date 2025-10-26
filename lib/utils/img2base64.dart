import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

Future<String?> imageToBase64(String imageUrl) async {
  try {
    Dio dio = Dio();
    Response response = await dio.get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200) {
      Uint8List bytes = Uint8List.fromList(response.data);
      String base64String = base64Encode(bytes);
      return 'data:image/png;base64,$base64String';
    } else {
      // 请求失败，处理错误
      return null;
    }
  } catch (e) {
    return null;
  }
}
