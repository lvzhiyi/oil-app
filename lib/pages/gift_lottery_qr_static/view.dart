import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/controller.dart';
import 'package:lottery_app/pages/gift_lottery_qr_static/state.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/base/input.dart';
import 'package:lottery_app/widgets/common/base_appbar.dart';
import 'package:lottery_app/widgets/common/dropdown_menu.dart';
import 'package:lottery_app/widgets/common/page_loading.dart';
import 'package:lottery_app/widgets/common/pull_refresh_easy.dart';
import 'package:lottery_app/widgets/popup/dialog.dart';
import 'package:lottery_app/widgets/popup/toast.dart';

import 'widgets/static_item.dart';

class GiftLotteryQrStaticView extends StatelessWidget {
  final GiftLotteryQrStaticState state;

  const GiftLotteryQrStaticView({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const BaseAppBar(
        title: '静态码',
      ),
      body: SafeArea(
        child: _buildContent(context),
      ),
    );
  }

  /// 构建主要内容
  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        /// 顶部操作栏
        _buildTopActionBar(context),

        /// 筛选和排序栏
        _buildFilterSortBar(context),
        Expanded(
          child: LotteryPageLoading(
            status: state.pageStatus,
            child: _buildStaticCodeList(context),
          ),
        ),
      ],
    );
  }

  /// 构建顶部操作栏
  Widget _buildTopActionBar(BuildContext context) {
    QrCodeStatus qrSelectedStatus = QrCodeStatus.all;

    return Container(
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: pt(8),
            offset: Offset(0, pt(2)),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 导出Excel按钮
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                if (state.staticCodes.isEmpty) {
                  SportsToast.show('请先生成二维码', ToastType.error);
                  return;
                }
                SportsDialog.show(
                  title: '导出PDF',
                  useSystem: true,
                  body: StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text('选择彩票状态:', style: TextStyle(fontSize: pt(16))),
                            SizedBox(width: pt(12)),
                            LotteryDropdownMenu<QrCodeStatus>(
                              hintText: '选择彩票状态',
                              width: pt(140),
                              items: QrCodeStatus.values
                                  .map((QrCodeStatus item) =>
                                      DropdownMenuItem<QrCodeStatus>(
                                        value: item,
                                        child: Text(
                                          item.displayName,
                                          style: TextStyle(
                                            color: AppColors.accentBlue,
                                            fontSize: pt(14),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: qrSelectedStatus,
                              onChanged: (QrCodeStatus? value) {
                                if (value != null) {
                                  setState(() {
                                    qrSelectedStatus = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  onOk: () {
                    SportsDialog.dismiss();
                    context
                        .read<GiftLotteryQrStaticCtrl>()
                        .exportPdf(qrSelectedStatus);
                  },
                  onCancel: () {
                    SportsDialog.dismiss();
                  },
                );
              },
              icon: Icon(Icons.file_download, size: pt(18)),
              label: Text('导出PDF', style: TextStyle(fontSize: pt(16))),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: pt(12)),
              ),
            ),
          ),
          SizedBox(width: pt(12)),

          /// 新生成按钮
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showGenerateDialog(
                context,
                title: '生成新静态码',
                okHandler: () {
                  context.read<GiftLotteryQrStaticCtrl>().generateNewCodes();
                },
              ),
              icon: Icon(Icons.add, size: pt(18)),
              label: Text('新生成', style: TextStyle(fontSize: pt(16))),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: pt(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选和排序栏
  Widget _buildFilterSortBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          LotteryDropdownMenu(
            hintText: '选择彩票类型',
            width: pt(100),
            icon: Icons.filter_list,
            items: LotteryType.values
                .map((LotteryType item) => DropdownMenuItem<LotteryType>(
                      enabled: item.enable,
                      value: item,
                      child: Text(
                        item.displayName,
                        style: TextStyle(
                          color: item.enable
                              ? AppColors.accentBlue
                              : AppColors.textGray2,
                          fontSize: pt(14),
                        ),
                      ),
                    ))
                .toList(),
            value: state.selectedLotteryType,
            onChanged: (LotteryType? value) {
              if (value != null) {
                context
                    .read<GiftLotteryQrStaticCtrl>()
                    .selectLotteryType(value);
              }
            },
          ),
          SizedBox(width: pt(8)),
          Expanded(
            child: LotteryDropdownMenu<SortType>(
              hintText: '时间排序',
              icon: Icons.filter_list,
              items: SortType.values
                  .map((SortType item) => DropdownMenuItem<SortType>(
                        enabled: true,
                        value: item,
                        child: Text(
                          item.displayName,
                          style: TextStyle(
                            color: AppColors.accentBlue,
                            fontSize: pt(14),
                          ),
                        ),
                      ))
                  .toList(),
              value: state.selectedSortType,
              onChanged: (SortType? value) {
                if (value != null) {
                  context.read<GiftLotteryQrStaticCtrl>().selectSortType(value);
                }
              },
            ),
          ),
          SizedBox(width: pt(8)),
          Expanded(
            child: LotteryDropdownMenu(
              hintText: '彩票状态',
              width: pt(100),
              icon: Icons.filter_list,
              items: [
                ...QrCodeStatus.values
                    .map((QrCodeStatus item) => DropdownMenuItem<QrCodeStatus>(
                          enabled: true,
                          value: item,
                          child: Text(
                            item.displayName,
                            style: TextStyle(
                              color: AppColors.accentBlue,
                              fontSize: pt(14),
                            ),
                          ),
                        ))
                    .toList(),
              ],
              value: state.selectedStatus,
              onChanged: (QrCodeStatus? value) {
                context.read<GiftLotteryQrStaticCtrl>().selectStatus(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建静态码列表
  Widget _buildStaticCodeList(BuildContext context) {
    GiftLotteryQrStaticCtrl _ctrl = context.read<GiftLotteryQrStaticCtrl>();

    return PullOrRefreshEasy(
      headerTopSpace: pt(68),
      onLoading: () {
        _ctrl.onLoading();
      },
      onRefresh: () {
        _ctrl.onRefresh();
      },
      refreshController: _ctrl.refreshController,
      child: ListView.builder(
        padding: EdgeInsets.all(pt(16)),
        itemCount: state.staticCodes.length,
        itemBuilder: (context, index) {
          final staticCode = state.staticCodes[index];
          return StaticItem(staticCode: staticCode);
        },
      ),
    );
  }

  /// 新生成显示的对话框
  Future<void> _showGenerateDialog(
    BuildContext context, {
    String? title,
    VoidCallback? okHandler,
  }) async {
    final newCodeInputController =
        context.read<GiftLotteryQrStaticCtrl>().newCodeInputController;
    newCodeInputController.clear();

    await SportsDialog.show(
      title: title ?? '生成新静态码:',
      useSystem: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text('选择彩票类型:', style: TextStyle(fontSize: pt(16))),
              SizedBox(width: pt(12)),
              LotteryDropdownMenu<LotteryType>(
                hintText: '选择彩票类型',
                width: pt(140),
                items: LotteryType.values
                    .map((LotteryType item) => DropdownMenuItem<LotteryType>(
                          enabled: item.enable,
                          value: item,
                          child: Text(
                            item.displayName,
                            style: TextStyle(
                              color: item.enable
                                  ? AppColors.accentBlue
                                  : AppColors.textGray2,
                              fontSize: pt(14),
                            ),
                          ),
                        ))
                    .toList(),
                value: state.selectedLotteryTypeOfNewCode,
                onChanged: (LotteryType? value) {
                  if (value != null) {
                    context
                        .read<GiftLotteryQrStaticCtrl>()
                        .selectLotteryTypeOfNewCode(value);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: pt(12)),
          Row(
            children: [
              Text('输入生成数量:', style: TextStyle(fontSize: pt(16))),
              SizedBox(width: pt(12)),
              Expanded(
                child: SportsInput(
                  keyboardType: TextInputType.number,
                  focusNode: context
                      .read<GiftLotteryQrStaticCtrl>()
                      .newCodeInputFocusNode,
                  controller: context
                      .read<GiftLotteryQrStaticCtrl>()
                      .newCodeInputController,
                  hintText: '请输入生成数量',
                ),
              ),
            ],
          ),
          SizedBox(height: pt(12)),
        ],
      ),
      onOk: () {
        okHandler?.call();
      },
    );
    newCodeInputController.clear();
  }
}
