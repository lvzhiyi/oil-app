import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

///获取渠道
Future<String> getChannel() async {
  String channel = "";
  if (Platform.isAndroid) {
    const platform = MethodChannel("com.yinse/device");
    try {
      channel = await platform.invokeMethod("getChannel");
    } on PlatformException {
      // channel = "1";
    }
  }
  return channel;
}

Future<String> getOrCreateUUID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uuid = prefs.getString('device_uuid');
  if (uuid == null) {
    uuid = const Uuid().v4();
    await prefs.setString('device_uuid', uuid);
  }
  return uuid;
}

Future<String> getAndroidDeviceId() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
  if (androidInfo.serialNumber.isNotEmpty &&
      androidInfo.serialNumber != 'unknown') {
    return androidInfo.serialNumber;
  } else {
    return await getOrCreateUUID();
  }
}
