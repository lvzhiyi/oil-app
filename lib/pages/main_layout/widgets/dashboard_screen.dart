import 'package:flutter/material.dart';
import 'package:oil_business_app/interfaces/top_bar_click_listener.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/topbar/topbar.dart';

import '../widgets/dashboard_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (context) => const DashboardScreen());
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin
    implements TopBarClickListener {
  int selectedBottomIndex = 0;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: bottomNavigationBarList.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        setState(() {
          selectedBottomIndex = _tabController.index;
        }); // To update TopBar
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(
              this,
              title: selectedBottomIndex == 0
                  ? '买油'
                  : selectedBottomIndex == 1
                      ? '提油'
                      : selectedBottomIndex == 2
                          ? '我的'
                          : "",
              isShowProfile: selectedBottomIndex == 0,
              isShowNotification: false,
              isShowLike: selectedBottomIndex == 1,
              isShowSearchField: selectedBottomIndex == 1 ? true : false,
              height: 120,
              isShowCart: selectedBottomIndex == 0 || selectedBottomIndex == 1,
              topBarColor: selectedBottomIndex == 0
                  ? CustomAppColor(context).bgTopBar
                  : selectedBottomIndex == 1
                      ? CustomAppColor(context).bgScaffold
                      : CustomAppColor(context).bgBlackWhiteScaffold,
              isShowShadow: selectedBottomIndex == 0 ||
                      selectedBottomIndex == 1 ||
                      selectedBottomIndex == 3
                  ? false
                  : true,
              textColor: selectedBottomIndex == 0
                  ? CustomAppColor.of(context).txtAppBar
                  : CustomAppColor.of(context).txtBlack,
              isShowCartCount: false,
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: bottomNavigationBarList
                    .map((item) => item.screen ?? const SizedBox())
                    .toList(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: CustomAppColor.of(context).bgNavBar,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.setWidth(20)),
              topRight: Radius.circular(AppSizes.setWidth(20)),
            ),
          ),
          child: TabBar(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            indicatorWeight: 4,
            indicator: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColor.icPurple, width: 4))),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding:
                EdgeInsets.symmetric(horizontal: AppSizes.setWidth(20)),
            labelColor: CustomAppColor.of(context).icPurple,
            unselectedLabelColor: CustomAppColor.of(context).txtGrey,
            tabs: bottomNavigationBarList.map((item) {
              int i = bottomNavigationBarList.indexOf(item);
              return Padding(
                padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
                child: Tab(
                  height: AppSizes.setHeight(65),
                  icon: Padding(
                    padding: EdgeInsets.only(
                        top: AppSizes.setHeight(12),
                        bottom: AppSizes.setHeight(4)),
                    child: Image.asset(
                      item.image!,
                      height: AppSizes.setHeight(24),
                      width: AppSizes.setWidth(24),
                      color: selectedBottomIndex == i
                          ? CustomAppColor.of(context).icPurple
                          : CustomAppColor.of(context).txtGrey,
                    ),
                  ),
                  text: item.title,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {String value = ""}) {
    if (name == 'pay_order_list') {
      BaseRouter.push(url: AppPage.payOrderListPage.path);
    }
  }
}
