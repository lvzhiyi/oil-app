var regHttp = RegExp(r'^https?:\/\/', caseSensitive: false);

bool isHttpRouter(String url) {
  return regHttp.hasMatch(url);
}

var regTinman = RegExp(r'^tinman-router:\/\/', caseSensitive: false);

bool isTinmanRouter(String url) {
  return regTinman.hasMatch(url);
}

var regPage = RegExp(r'^\/?pages\/', caseSensitive: false);
var regSubPage = RegExp(r'^\/?subpackages\/', caseSensitive: false);

bool isWXMiniRouter(String url) {
  return regPage.hasMatch(url) || regSubPage.hasMatch(url);
}
