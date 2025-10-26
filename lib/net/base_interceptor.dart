import 'package:dio/dio.dart';

class BaseInterceptor extends InterceptorsWrapper {
  final String tag;

  BaseInterceptor({required this.tag});
}
