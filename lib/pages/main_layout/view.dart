import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/pages/dashboard/page.dart';
import 'package:lottery_app/pages/gift_lottery/page.dart';
import 'package:lottery_app/pages/main_layout/controller.dart';
import 'package:lottery_app/pages/main_layout/state.dart';
import 'package:lottery_app/pages/profile/page.dart';
import 'package:lottery_app/pages/recharge_records/page.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';

class MainLayoutView extends StatefulWidget {
  final MainLayoutState state;

  const MainLayoutView({super.key, required this.state});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<MainLayoutCtrl>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: GestureDetector(
        onPanEnd: (details) {
          // 检测水平滑动速度
          if (details.velocity.pixelsPerSecond.dx > 300 &&
              widget.state.selectedIndex == 1) {
            // 向右快速滑动，从"我的"切换到"首页"
            controller.changeTab(0);
          } else if (details.velocity.pixelsPerSecond.dx < -300 &&
              widget.state.selectedIndex == 0) {
            // 向左快速滑动，从"首页"切换到"我的"
            controller.changeTab(1);
          }
        },
        child: IndexedStack(
          index: widget.state.selectedIndex,
          children: const [
            DashboardPage(key: ValueKey('dashboard')),
            GiftLotteryPage(key: ValueKey('giftLottery')),
            RechargeRecordsPage(key: ValueKey('rechargeRecord')),
            ProfilePage(key: ValueKey('profile')),
          ],
        ),
      ),
      bottomNavigationBar: widget.state.showBottomNavigation
          ? _buildBottomNavigationBar(controller)
          : null,
    );
  }

  /// 构建底部导航栏
  Widget _buildBottomNavigationBar(MainLayoutCtrl controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFE8E8E8),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: pt(16),
            offset: Offset(0, -pt(4)),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: pt(60),
          child: Row(
            children: [
              _buildTabItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: '首页',
                controller: controller,
              ),
              _buildTabItem(
                index: 1,
                icon: Icons.wallet_giftcard_outlined,
                activeIcon: Icons.wallet_giftcard_rounded,
                label: '赠送',
                controller: controller,
              ),
              _buildTabItem(
                index: 2,
                icon: Icons.wallet_outlined,
                activeIcon: Icons.wallet,
                label: '账户',
                controller: controller,
              ),
              _buildTabItem(
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建Tab项
  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required MainLayoutCtrl controller,
  }) {
    final isSelected = widget.state.selectedIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.textTertiary;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.changeTab(index),
          borderRadius: BorderRadius.circular(pt(8)),
          child: Container(
            height: pt(60),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey(isSelected),
                    size: pt(20),
                    color: color,
                  ),
                ),
                SizedBox(height: pt(4)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: pt(10),
                    color: color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: 'PingFang SC',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
