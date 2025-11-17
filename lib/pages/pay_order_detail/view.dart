import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/common/base_appbar.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';
import 'widgets/upload_voucher_dialog.dart';
import 'widgets/image_viewer.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

import 'state.dart';
import 'controller.dart';

class PayOrderDetailView extends HookWidget {
  final PayOrderDetailState state;
  final OrderModel order;

  const PayOrderDetailView({Key? key, required this.state, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PayOrderDetailCtrl>();

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: const BaseAppBar(
          title: '支付订单详情',
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final orderDetail = state.order;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BaseAppBar(
        title: '支付订单详情',
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leadingOnClick: () {
          BaseRouter.popToRoot();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(pt(16)),
                child: Column(
                  children: [
                    _buildOrderInfoCard(orderDetail, context),
                    SizedBox(height: pt(16)),
                    if (orderDetail?.status !=
                        OrderStatus.Completed) // 只有未完成的订单才显示转账信息
                      _buildTransferInfoCard(orderDetail, context),
                    if (orderDetail?.status != OrderStatus.Completed)
                      SizedBox(height: pt(16)),
                    if (state.uploadedImageUrls.isNotEmpty) ...[
                      _buildUploadedImages(state.uploadedImageUrls, context),
                    ],
                    SizedBox(height: pt(100)), // 为底部按钮留出空间
                  ],
                ),
              ),
            ),
          ),
          // 只有未支付的订单才显示操作按钮
          if (orderDetail?.status != OrderStatus.Completed)
            _buildBottomActions(context, controller),
        ],
      ),
    );
  }

  /// 构建订单信息卡片
  Widget _buildOrderInfoCard(OrderModel? orderDetail, BuildContext context) {
    if (orderDetail == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: pt(10),
            offset: Offset(0, pt(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: pt(8), vertical: pt(4)),
                decoration: BoxDecoration(
                  color:
                      CustomAppColor.of(context).white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(pt(4)),
                ),
                child: Text(
                  orderDetail.status?.displayName ?? '',
                  style: TextStyle(
                    color: CustomAppColor.of(context).btnPurple,
                    fontSize: pt(12, isFontSize: true),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '¥${orderDetail.totalAmount}',
                style: TextStyle(
                  fontSize: pt(20, isFontSize: true),
                  fontWeight: FontWeight.bold,
                  color: CustomAppColor.of(context).white,
                ),
              ),
            ],
          ),
          SizedBox(height: pt(16)),
          _buildOrderInfoRow('订单编号', orderDetail.orderNo ?? '-'),
          _buildOrderInfoRow('充值金额', '¥${orderDetail.totalAmount}'),
          _buildOrderInfoRow('订单状态', orderDetail.status?.displayName ?? ''),
          _buildOrderInfoRow(
              '提交时间',
              DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(DateTime.parse(orderDetail.createdAt ?? ''))),
          if (orderDetail.status != OrderStatus.Completed)
            _buildOrderInfoRow(
                orderDetail.status == OrderStatus.Completed ? '完成时间' : '更新时间',
                DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(DateTime.parse(orderDetail.updatedAt ?? ''))),
          _buildOrderInfoRow('备注', orderDetail.remark ?? ''),
        ],
      ),
    );
  }

  /// 构建订单信息行
  Widget _buildOrderInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: pt(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: pt(80),
            child: Text(
              label,
              style: TextStyle(
                fontSize: pt(14, isFontSize: true),
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: pt(14, isFontSize: true),
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferInfoCard(OrderModel? orderDetail, BuildContext context) {
    if (orderDetail == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: pt(10),
            offset: Offset(0, pt(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance,
                color: CustomAppColor.of(context).btnPurple,
                size: pt(20),
              ),
              SizedBox(width: pt(8)),
              Text(
                '转账信息',
                style: TextStyle(
                  fontSize: pt(16, isFontSize: true),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: pt(16)),
          Text(
            '请使用对公账号向以下账户转账',
            style: TextStyle(
              fontSize: pt(14, isFontSize: true),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: pt(16)),
          _buildInfoRow(context, '收款账户名称', orderDetail.accountName ?? '',
              canCopy: true),
          _buildInfoRow(context, '银行账号', orderDetail.bankAccount ?? '',
              canCopy: true),
          _buildInfoRow(context, '开户银行', orderDetail.bankName ?? '',
              canCopy: true),
          _buildInfoRow(context, '联行号', orderDetail.bankBranchNumber ?? '',
              canCopy: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {bool canCopy = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: pt(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: pt(100),
            child: Text(
              label,
              style: TextStyle(
                fontSize: pt(14, isFontSize: true),
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: pt(14, isFontSize: true),
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: pt(10)),
          if (canCopy)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                SportsToast.showSuccess('已复制到剪贴板');
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: pt(8), vertical: pt(4)),
                decoration: BoxDecoration(
                  color: CustomAppColor.of(context)
                      .btnPurple
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(pt(4)),
                ),
                child: Text(
                  '复制',
                  style: TextStyle(
                    color: CustomAppColor.of(context).btnPurple,
                    fontSize: pt(12, isFontSize: true),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadedImages(List<String> imageUrls, BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(pt(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: pt(10),
            offset: Offset(0, pt(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '转账凭证',
                style: TextStyle(
                  fontSize: pt(16, isFontSize: true),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${imageUrls.length}张',
                style: TextStyle(
                  fontSize: pt(14, isFontSize: true),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: pt(12)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: pt(8),
              mainAxisSpacing: pt(8),
              childAspectRatio: 1.0,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showImageViewer(context, imageUrls, index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(pt(8)),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(pt(8)),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(pt(8)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: pt(24),
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: pt(4)),
                            Text(
                              '加载失败',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: pt(10, isFontSize: true),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showImageViewer(
      BuildContext context, List<String> imageUrls, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          isLocalImages: false,
        ),
      ),
    );
  }

  /// 构建底部操作按钮
  Widget _buildBottomActions(
      BuildContext context, PayOrderDetailCtrl controller) {
    return Container(
      padding: EdgeInsets.all(pt(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: pt(10),
            offset: Offset(0, -pt(2)),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 取消按钮
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {
                  _showCancelDialog(context, controller);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: pt(12)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(pt(8)),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Text(
                  '取消',
                  style: TextStyle(
                    fontSize: pt(16, isFontSize: true),
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            SizedBox(width: pt(12)),
            // 上传凭证按钮
            Expanded(
              flex: 2,
              child: CommonButton(
                height: pt(48),
                btnText: state.hasUploaded ? '修改凭证' : '上传转账凭证',
                onTap: () {
                  _showUploadDialog(context, controller, state.hasUploaded);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示取消订单确认对话框
  void _showCancelDialog(BuildContext context, PayOrderDetailCtrl controller) {
    SportsDialog.show(
      showClose: false,
      title: '取消充值',
      bodyText: '确定要取消这笔充值订单吗？取消后将无法恢复',
      onOk: () {
        controller.cancelOrder();
        SportsDialog.dismiss();
      },
      okText: '确定取消',
      cancelText: '我再想想',
      onCancel: () {
        SportsDialog.dismiss();
      },
    );
  }

  void _showUploadDialog(
      BuildContext context, PayOrderDetailCtrl controller, bool hasUploaded) {
    showDialog(
      context: context,
      barrierDismissible: false, // 防止点击外部关闭弹窗
      builder: (BuildContext dialogContext) {
        return BlocBuilder<PayOrderDetailCtrl, PayOrderDetailState>(
          bloc: controller, // 直接传入 controller 实例
          builder: (context, dialogState) {
            // final hasImages = dialogState.selectedImagePaths.isNotEmpty;

            return PopScope(
              canPop: !dialogState.isUploading,
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(pt(16)),
                ),
                title: Text(
                  '请上传转账凭证',
                  style: TextStyle(
                      fontSize: pt(18, isFontSize: true),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: SingleChildScrollView(
                      child: UploadVoucherDialog(
                        onPickImage: () {
                          controller.pickSingleImage();
                        },
                        onRemoveImage: (index) {
                          controller.removeSelectedImage(index);
                        },
                        onUploadImage: (index) {
                          controller.uploadSingleImage(index);
                        },
                        onUploadAllImages: () {
                          controller.uploadAllImages();
                        },
                        onRemoveUploadedImage: (index) {
                          controller.removeUploadedImage(index);
                        },
                        uploadingImageIndices:
                            dialogState.uploadingImageIndices,
                        selectedImagePaths: dialogState.selectedImagePaths,
                        uploadedImageUrls: dialogState.uploadedImageUrls,
                        maxUploadCount: 20,
                      ),
                    ),
                  ),
                ),
                actions: [
                  SizedBox(width: pt(12)),
                  CommonButton(
                    btnText: dialogState.selectedImagePaths.isEmpty &&
                            dialogState.uploadedImageUrls.isNotEmpty
                        ? '完成'
                        : '取消',
                    onTap: () {
                      if (dialogState.selectedImagePaths.isEmpty &&
                          dialogState.uploadedImageUrls.isNotEmpty) {
                        controller.uploadAllImages();
                      } else {
                        controller.clearSelectedImages();
                      }
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 格式化日期时间
  String _formatDateTime(int? timestamp) {
    return formatDateFromMilliSecond(timestamp!, format: 'yyyy-MM-dd HH:mm:ss');
  }
}
