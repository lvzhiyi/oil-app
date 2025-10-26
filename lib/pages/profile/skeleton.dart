import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/skeleton_loading.dart';

/// 个人中心骨架屏
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8FAFF),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SkeletonLoading(
            child: Column(
              children: [
                _buildHeaderSkeleton(),
                Gap(pt(24)),
                _buildUserHeaderSkeleton(),
                Gap(pt(24)),
                _buildAccountStatsSkeleton(),
                Gap(pt(24)),
                _buildMenuItemsSkeleton(),
                Gap(pt(24)),
                _buildVersionInfoSkeleton(),
                Gap(pt(40)),
                _buildLogoutButtonSkeleton(),
                Gap(pt(32)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建顶部Header骨架屏
  Widget _buildHeaderSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pt(20), vertical: pt(16)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: pt(100), height: pt(24)),
              Gap(pt(4)),
              SkeletonLine(width: pt(150), height: pt(14)),
            ],
          ),
          const Spacer(),
          SkeletonBox(
            width: pt(48),
            height: pt(48),
            borderRadius: pt(12),
          ),
        ],
      ),
    );
  }

  /// 构建用户头部信息骨架屏
  Widget _buildUserHeaderSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      padding: EdgeInsets.all(pt(24)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.mediumBlue.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(pt(16)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SkeletonCircle(size: pt(60)),
              Gap(pt(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: pt(100), height: pt(18)),
                    Gap(pt(4)),
                    Row(
                      children: [
                        SkeletonLine(width: pt(60), height: pt(14)),
                        Gap(pt(8)),
                        SkeletonLine(width: pt(40), height: pt(14)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(pt(16)),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SkeletonLine(width: pt(80), height: pt(14)),
                    Gap(pt(2)),
                    SkeletonLine(width: pt(40), height: pt(10)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SkeletonLine(width: pt(100), height: pt(14)),
                    Gap(pt(2)),
                    SkeletonLine(width: pt(60), height: pt(10)),
                  ],
                ),
              ),
              SkeletonLine(width: pt(16), height: pt(16)),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建账户统计信息骨架屏
  Widget _buildAccountStatsSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      padding: EdgeInsets.all(pt(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(16)),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: pt(1),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItemSkeleton()),
          Container(
            width: pt(1),
            height: pt(40),
            color: Colors.grey[300],
          ),
          Expanded(child: _buildStatItemSkeleton()),
          Container(
            width: pt(1),
            height: pt(40),
            color: Colors.grey[300],
          ),
          Expanded(child: _buildStatItemSkeleton()),
        ],
      ),
    );
  }

  /// 构建统计项骨架屏
  Widget _buildStatItemSkeleton() {
    return Column(
      children: [
        SkeletonLine(width: pt(60), height: pt(18)),
        Gap(pt(4)),
        SkeletonLine(width: pt(40), height: pt(12)),
      ],
    );
  }

  /// 构建功能菜单项骨架屏
  Widget _buildMenuItemsSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(16)),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: pt(1),
        ),
      ),
      child: Column(
        children: List.generate(
          5,
          (index) => _buildMenuItemSkeleton(isLast: index == 4),
        ),
      ),
    );
  }

  /// 构建单个菜单项骨架屏
  Widget _buildMenuItemSkeleton({bool isLast = false}) {
    return Container(
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          SkeletonBox(
            width: pt(24),
            height: pt(24),
            borderRadius: pt(4),
          ),
          Gap(pt(12)),
          Expanded(
            child: SkeletonLine(width: pt(100), height: pt(16)),
          ),
          SkeletonBox(
            width: pt(20),
            height: pt(20),
            borderRadius: pt(4),
          ),
        ],
      ),
    );
  }

  /// 构建版本信息骨架屏
  Widget _buildVersionInfoSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      padding: EdgeInsets.all(pt(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(16)),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: pt(1),
        ),
      ),
      child: Row(
        children: [
          SkeletonBox(
            width: pt(20),
            height: pt(20),
            borderRadius: pt(4),
          ),
          Gap(pt(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: pt(60), height: pt(14)),
                SkeletonLine(width: pt(120), height: pt(12)),
              ],
            ),
          ),
          SkeletonLine(width: pt(50), height: pt(20)),
        ],
      ),
    );
  }

  /// 构建退出登录按钮骨架屏
  Widget _buildLogoutButtonSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pt(20)),
      child: SkeletonBox(
        width: double.infinity,
        height: pt(52),
        borderRadius: pt(12),
      ),
    );
  }
}
