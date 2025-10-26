import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter/services.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/theme.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/widgets/popup/popup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'global/app_state.dart';

class SportsInitedApp extends StatefulWidget {
  const SportsInitedApp({super.key});

  @override
  SportsInitedAppState createState() => SportsInitedAppState();
}

class SportsInitedAppState extends State<SportsInitedApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return BlocProvider(
        create: (context) => appController,
        child: BlocBuilder<AppController, AppState>(builder: (context, state) {
          BaseConfig.appContext ??= context;
          return MaterialApp.router(
            key: BaseConfig.navigatorKey,
            theme: ThemeData(
              extensions: [
                TDThemeData.fromJson(
                  'Sports',
                  SportsDefaultTheme.defaultThemeConfig,
                )!
              ],
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              }),
              scaffoldBackgroundColor: Colors.white,
              splashColor: const Color(0xff3c9fff),
              appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white),
                elevation: 0,
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(color: Colors.black),
              ),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColors.darkBlue,
                selectionColor: AppColors.darkBlue,
                selectionHandleColor: AppColors.darkBlue,
              ),
            ),
            builder: SportsPopup.init(builder: (context, widget) {
              return MediaQuery(
                ///设置文字大小不随系统设置改变
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: widget ?? Container(),
              );
            }),
            routeInformationProvider: BaseRouter.routeInformationProvider,
            routeInformationParser: BaseRouter.routeInformationParser!,
            routerDelegate: BaseRouter.routerDelegate!,
          );
        }));
  }
}

//继承RouteObserver
class CustomRouteObserver<PageRoute> extends RouteObserver {}
