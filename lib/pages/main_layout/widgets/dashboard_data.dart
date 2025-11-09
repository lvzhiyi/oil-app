import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/profile/page.dart';
import 'package:oil_business_app/static/icon.dart';

class BottomNavigationBarData {
  BottomNavigationBarData({
    this.image,
    this.title,
    this.screen,
  });

  String? image;
  String? title;
  Widget? screen;
}

List<BottomNavigationBarData> bottomNavigationBarList = [
  // BottomNavigationBarData(
  //   title: '首页',
  //   image: AssetsIcon.IC_HOME,
  //   screen: Container(),
  // ),
  BottomNavigationBarData(
    title: '买油',
    image: AssetsIcon.IC_CATEGORY,
    screen: Container(),
  ),
  BottomNavigationBarData(
    title: '提油',
    image: AssetsIcon.IC_BAG,
    screen: Container(),
  ),
  BottomNavigationBarData(
    title: '我的',
    image: AssetsIcon.IC_PROFILE,
    screen: ProfilePage(),
  ),
];
