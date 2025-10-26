/// future 扔出的异常
class ApiException implements Exception {
  int? code;
  String message = '';
  ApiException([this.code = -200, this.message = '']);

  @override
  String toString() {
    return "ApiException:code:$code message:$message";
  }
}
