import 'package:flutter/material.dart';
import 'package:lottery_app/utils/log.dart';
import 'package:go_router/go_router.dart';

extension Compatible on GoRouterState {
  Map<String, String> get queryParams => uri.queryParameters;
}

class BaseRoute extends GoRoute {
  BaseRoute({
    required super.path,
    super.name,
    super.builder,
    super.pageBuilder,
    super.redirect,
    List<RouteBase> routes = const <RouteBase>[],
  }) : super(routes: routes);
}

class BaseRouter {
  /// 一个全局路由观察者
  static late NavigatorObserver observer;

  // 导航栏高度
  static double barHeight = 44;

  // 状态栏高度，用于web环境
  static double statusBarHeight = 40;

  static bool _isInitRouter = false;

  /// 路由表
  static List<BaseRoute> get routes => _routes;

  /// location
  static String? get location => _location();

  static double nativeStackIndex = 0;

  // static RouterConfig<Object>? get routerConfig => _router;

  static RouterDelegate<Object>? get routerDelegate => _router?.routerDelegate;

  static RouteInformationParser<Object>? get routeInformationParser =>
      _router?.routeInformationParser;

  static RouteInformationProvider? get routeInformationProvider =>
      _router?.routeInformationProvider;

  static void init({
    GoRouterWidgetBuilder? errorBuilder,
    GoRouterRedirect? redirect,
    Listenable? refreshListenable,
    String? initialLocation,
    List<BaseRoute>? routes,
    List<NavigatorObserver>? observers,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    observer = NavigatorObserver();
    var obs = observers ?? [];
    obs.add(BaseRouter.observer);
    if (routes != null) {
      registerRoutes(routes);
    }
    _router = GoRouter(
      initialLocation: initialLocation,
      routes: _routes,
      observers: obs,
      navigatorKey: navigatorKey,
      errorBuilder: errorBuilder,
      redirect: redirect,
      refreshListenable: refreshListenable,
    );

    _router?.routerDelegate.addListener(() {
      if (_isInitRouter) {
        return;
      }
      // 初始化路由参数
      _isInitRouter = true;
      final location = _location() ?? '';
      Uri uri = Uri.parse(location);
      Map<String, String> queryParams = uri.queryParameters;

      // 获取路由 barHeight参数
      if (queryParams['barHeight'] != null) {
        barHeight = double.parse(queryParams['barHeight'] ?? '44');
      }
    });
  }

  static String? _location() {
    if (_router == null) {
      return null;
    }
    final RouteMatch lastMatch =
        _router!.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router!.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }

  static void registerRoutes(List<BaseRoute> routes) {
    for (var route in routes) {
      String key = route.path;
      if (_routeKeys.contains(key)) {
        l.e("registerRoutes 重复路由 path: $key", '');
      }
      _routeKeys.add(key);
    }
    _routes.addAll(routes);
  }

  static GoRouter? _router;

  static final List<BaseRoute> _routes = [];
  static final Set<String> _routeKeys = {};

  static final _default = BaseRouter._internal();

  factory BaseRouter() => _default;

  BaseRouter._internal();

  static void replace(
      {BuildContext? context, required String url, Object? extra}) {
    var con = context ?? observer.navigator?.context;
    if (con == null) {
      l.e('BaseRouter.replace', 'failed, $url');
      return;
    }
    con.replace(url, extra: extra);
  }

  static Future<T?> push<T>({
    BuildContext? context,
    required String url,
    Object? extra,
  }) {
    var con = context ?? observer.navigator?.context;
    if (con == null) {
      l.e('BaseRouter.push', 'failed, $url');
      return Future.value();
    }
    return con.push<T>(url, extra: extra);
  }

  /// 栈顶只会有一个相同路由
  static Future<T?> pushSingle<T>({
    BuildContext? context,
    required String url,
    Object? extra,
  }) {
    var current = location;
    if (current != null) {
      Uri uri1 = Uri.parse(current);
      Uri uri2 = Uri.parse(url);
      if (uri1.path == uri2.path) {
        return Future.value();
      }
    }

    return push<T>(context: context, url: url, extra: extra);
  }

  static void popAndPush(
      {BuildContext? context, required String url, Object? extra}) {
    var con = context ?? observer.navigator?.context;
    if (con == null) {
      l.e('BaseRouter.go', 'failed, $url');
      return;
    }
    con.go(url, extra: extra);
  }

  static void pop<T extends Object?>({BuildContext? context, T? result}) {
    var con = context ?? observer.navigator?.context;

    if (con == null) {
      l.e('BaseRouter.pop', 'failed');
      return;
    }

    if (con.canPop()) {
      con.pop(result);
    }
  }

  static bool canPop<T extends Object?>({BuildContext? context}) {
    var con = context ?? observer.navigator?.context;
    if (con == null) {
      l.e('BaseRouter.canPop', 'failed');
      return false;
    }
    return con.canPop();
  }

  static void popToRoot({BuildContext? context}) {
    var con = context ?? observer.navigator?.context;
    if (con == null) {
      l.e('BaseRouter.popToRoot', 'failed');
      return;
    }

    while (con.canPop()) {
      con.pop();
    }
  }

  static void popUtil({BuildContext? context, required String url}) {
    var con = context ?? observer.navigator?.context;
    if (con == null) {
      l.e('BaseRouter.canPop,', 'failed');
      return;
    }
    final router = GoRouter.of(con);
    final GoRouterDelegate delegate = router.routerDelegate;
    final routes = delegate.currentConfiguration.routes;
    for (var i = 0; i < routes.length; i++) {
      final route = routes[i] as GoRoute;
      if (route.name == url) break;
      GoRouter.of(con).pop();
    }
  }
}
