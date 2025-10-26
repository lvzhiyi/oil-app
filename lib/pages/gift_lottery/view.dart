import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/config/config.dart';
import 'package:lottery_app/global/app_controller.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_lottery/controller.dart';
import 'package:lottery_app/pages/gift_lottery/state.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/router/router.dart';
import 'package:lottery_app/router/routes.dart';
import 'package:lottery_app/widgets/common/balance_info_card_widget.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/pull_refresh_easy.dart';
import 'package:lottery_app/widgets/popup/dialog.dart';

class GiftLotteryView extends StatelessWidget {
  final GiftLotteryState state;

  const GiftLotteryView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: LotteryPageLoading(
          status: state.isLoading
              ? PageStatus.loading
              : state.hasError
                  ? PageStatus.error
                  : PageStatus.success,
          child: _buildContent(context),
        ),
      ),
    );
  }

  /// 构建主要内容
  Widget _buildContent(BuildContext context) {
    return PullOrRefreshEasy(
      refreshController: context.read<GiftLotteryCtrl>().refreshController,
      onRefresh: () async {
        BaseConfig.appContext?.read<AppController>().fetchAgentInfo();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: pt(16)),

            // ignore: prefer_const_constructors
            BalanceInfoCardWidget(),

            /// 二维码类型选择
            Container(
              padding: EdgeInsets.all(pt(16)),
              child: _buildQrTypeSelector(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建二维码类型选择器
  Widget _buildQrTypeSelector(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: pt(32),
                height: pt(32),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(pt(8)),
                ),
                child: Icon(
                  Icons.qr_code,
                  color: AppColors.primary,
                  size: pt(18),
                ),
              ),
              SizedBox(width: pt(12)),
              Text(
                '赠送方式',
                style: TextStyle(
                  fontSize: pt(18),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: pt(12)),
          Column(
            children: QrCodeType.values.map((type) {
              final isEnable =
                  context.read<GiftLotteryCtrl>().roleHasCodeGenerate(type);
              return GestureDetector(
                onTap: () async {
                  if (!isEnable) {
                    SportsDialog.show(
                      title: '无${type.displayName}赠送权限',
                      body: Text(
                        '您还没有${type.displayName}赠送权限，请联系管理员配置。\n配置路径: 代理商APP-我的-员工管理',
                        style: TextStyle(
                          fontSize: pt(14),
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                    return;
                  }
                  await BaseRouter.push(
                    url: type == QrCodeType.dynamic
                        ? AppPage.giftLotteryQrDynamicPage.path
                        : AppPage.giftLotteryQrStaticPage.path,
                  );
                  BaseConfig.appContext?.read<AppController>().fetchAgentInfo();
                },
                child: Container(
                  width: pt(360),
                  margin: EdgeInsets.only(
                    bottom: type == QrCodeType.dynamic ? 0 : 12,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isEnable ? Colors.grey[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(pt(8)),
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        type == QrCodeType.dynamic
                            ? Icons.refresh
                            : Icons.grid_view,
                        color:
                            isEnable ? AppColors.primary : AppColors.textGray2,
                        size: pt(42),
                      ),
                      SizedBox(height: pt(8)),
                      Text(
                        type.displayName,
                        style: TextStyle(
                          fontSize: pt(16),
                          color: AppColors.appText,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: pt(12)),
                      Text(
                        type == QrCodeType.static
                            ? '固定一张码赠送一张彩票'
                            : '用于实时赠送场景，一张码有效期内可以赠送多张',
                        style: TextStyle(
                          fontSize: pt(12),
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
