import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/router/router.dart';
import 'widgets/upload_voucher_dialog.dart';
import 'widgets/image_viewer.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

import 'state.dart';
import 'controller.dart';

class PayOrderDetailView extends HookWidget {
  final PayOrderDetailState state;
  final OrderModel? order;
  final String? from;
  const PayOrderDetailView(
      {Key? key, required this.state, this.order, this.from})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PayOrderDetailCtrl>();

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: const Color(0xFF1F2937),
              size: AppSizes.setWidth(20),
            ),
            onPressed: () {
              if (from == 'oilPurchaseDetail') {
                BaseRouter.popToRoot();
              } else {
                BaseRouter.pop();
              }
            },
          ),
          title: CommonText(
            text: '支付订单详情',
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.setFontSize(17),
            textColor: const Color(0xFF1F2937),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final orderDetail = state.order;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: CustomAppColor(context).white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF1F2937),
            size: AppSizes.setWidth(20),
          ),
          onPressed: () {
            if (from == 'oilPurchaseDetail') {
              BaseRouter.popToRoot();
            } else {
              BaseRouter.pop();
            }
          },
        ),
        title: CommonText(
          text: '支付订单详情',
          fontWeight: FontWeight.w600,
          fontSize: AppSizes.setFontSize(17),
          textColor: const Color(0xFF1F2937),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.setWidth(16)),
                child: Column(
                  children: [
                    _buildStatusCard(orderDetail, context),
                    SizedBox(height: AppSizes.setHeight(16)),
                    if (orderDetail?.status != OrderStatus.Completed)
                      _buildTransferInfoCard(orderDetail, context),
                    if (orderDetail?.status != OrderStatus.Completed)
                      SizedBox(height: AppSizes.setHeight(16)),
                    _buildOrderDetailCard(orderDetail, context),
                    if (orderDetail?.paymentProofUrls?.isNotEmpty ?? false) ...[
                      SizedBox(height: AppSizes.setHeight(16)),
                      _buildUploadedImages(
                          orderDetail?.paymentProofUrls ?? [], context),
                    ],
                    SizedBox(height: AppSizes.setHeight(16)),
                  ],
                ),
              ),
            ),
          ),
          if (orderDetail?.status != OrderStatus.Completed &&
              orderDetail?.status != OrderStatus.Cancelled &&
              orderDetail?.status != OrderStatus.PendingReview &&
              orderDetail?.status != OrderStatus.Rejected)
            _buildBottomActions(context, controller),
        ],
      ),
    );
  }

  /// 构建状态卡片
  Widget _buildStatusCard(OrderModel? orderDetail, BuildContext context) {
    if (orderDetail == null) return const SizedBox.shrink();

    final isRejected = orderDetail.status == OrderStatus.Rejected;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStatusBadge(orderDetail.status),
          SizedBox(height: AppSizes.setHeight(16)),
          CommonText(
            text: '需支付金额(元)',
            fontSize: AppSizes.setFontSize(14),
            textColor: const Color(0xFF6B7280),
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          CommonText(
            text: '¥${_formatPrice(orderDetail.totalAmount ?? 0)}',
            fontSize: AppSizes.setFontSize(24),
            fontWeight: FontWeight.w700,
            textColor: const Color(0xFF1F2937),
          ),
          // 驳回原因（仅当状态为驳回时显示）
          if (isRejected &&
              orderDetail.reviewRemark != null &&
              orderDetail.reviewRemark!.isNotEmpty) ...[
            SizedBox(height: AppSizes.setHeight(16)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.setWidth(12)),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: AppSizes.setWidth(16),
                    color: const Color(0xFFF59E0B),
                  ),
                  SizedBox(width: AppSizes.setWidth(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: '驳回原因',
                          fontSize: AppSizes.setFontSize(12),
                          fontWeight: FontWeight.w600,
                          textColor: const Color(0xFFF59E0B),
                        ),
                        SizedBox(height: AppSizes.setHeight(4)),
                        CommonText(
                          text: orderDetail.reviewRemark ?? '',
                          fontSize: AppSizes.setFontSize(12),
                          textColor: const Color(0xFF92400E),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建状态徽章
  Widget _buildStatusBadge(OrderStatus? status) {
    String text = status?.displayName ?? '';
    Color textColor;
    Widget? icon;

    switch (status) {
      case OrderStatus.PendingPayment:
        textColor = const Color(0xFFF59E0B);
        icon = Icon(
          Icons.access_time,
          size: AppSizes.setWidth(20),
          color: textColor,
        );
        break;
      case OrderStatus.PaymentUploaded:
        textColor = const Color(0xFF3B82F6);
        break;
      case OrderStatus.Completed:
        textColor = const Color(0xFF22C55E);
        break;
      case OrderStatus.Cancelled:
        textColor = const Color(0xFF9CA3AF);
        break;
      default:
        textColor = const Color(0xFF9CA3AF);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(8),
        vertical: AppSizes.setHeight(4),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon,
            SizedBox(width: AppSizes.setWidth(4)),
          ],
          CommonText(
            text: text,
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w600,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  /// 构建订单详情卡片
  Widget _buildOrderDetailCard(OrderModel? orderDetail, BuildContext context) {
    if (orderDetail == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('订单编号', orderDetail.orderNo ?? '-'),
          _buildDetailRow(
            '提交时间',
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(DateTime.parse(orderDetail.createdAt ?? '')),
          ),
          _buildDetailRow(
            orderDetail.status == OrderStatus.Completed ? '完成时间' : '更新时间',
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(DateTime.parse(orderDetail.updatedAt ?? '')),
          ),
          if (orderDetail.status == OrderStatus.Rejected &&
              orderDetail.reviewRemark != null &&
              orderDetail.reviewRemark!.isNotEmpty)
            _buildDetailRow('驳回原因', orderDetail.reviewRemark ?? '无'),
          _buildDetailRow('备注信息', orderDetail.remark ?? '无'),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat('#,###.00');
    return formatter.format(price);
  }

  /// 构建详情行
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSizes.setWidth(80),
            child: CommonText(
              text: label,
              fontSize: AppSizes.setFontSize(14),
              textColor: const Color(0xFF6B7280),
            ),
          ),
          Expanded(
            child: CommonText(
              text: value,
              textAlign: TextAlign.left,
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.w500,
              textColor: const Color(0xFF1F2937),
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
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor(context).white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                color: AppColor.txtPurple,
                size: AppSizes.setWidth(20),
              ),
              SizedBox(width: AppSizes.setWidth(8)),
              CommonText(
                text: '对公转账信息',
                fontSize: AppSizes.setFontSize(16),
                fontWeight: FontWeight.w700,
                textColor: const Color(0xFF1F2937),
              ),
            ],
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          _buildTransferInfoRow(
            context,
            '收款户名',
            orderDetail.accountName ?? '',
            canCopy: true,
          ),
          _buildTransferInfoRow(
            context,
            '银行账号',
            orderDetail.bankAccount ?? '',
            canCopy: true,
          ),
          _buildTransferInfoRow(
            context,
            '开户银行',
            orderDetail.bankName ?? '',
            canCopy: true,
          ),
          _buildTransferInfoRow(
            context,
            '联行号',
            orderDetail.bankBranchNumber ?? '',
            canCopy: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTransferInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool canCopy = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSizes.setWidth(80),
            child: CommonText(
              text: label,
              fontSize: AppSizes.setFontSize(14),
              textColor: const Color(0xFF6B7280),
            ),
          ),
          Expanded(
            child: CommonText(
              textAlign: TextAlign.left,
              text: value,
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.w500,
              textColor: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(width: AppSizes.setWidth(8)),
          if (canCopy)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                SportsToast.showSuccess('已复制到剪贴板');
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(12),
                  vertical: AppSizes.setHeight(4),
                ),
                decoration: BoxDecoration(
                  color: AppColor.txtPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CommonText(
                  text: '复制',
                  fontSize: AppSizes.setFontSize(12),
                  textColor: AppColor.txtPurple,
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
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor(context).white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonText(
                text: '转账凭证',
                fontSize: AppSizes.setFontSize(16),
                fontWeight: FontWeight.w700,
                textColor: const Color(0xFF1F2937),
              ),
              const Spacer(),
              CommonText(
                text: '${imageUrls.length}张',
                fontSize: AppSizes.setFontSize(14),
                textColor: const Color(0xFF6B7280),
              ),
            ],
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSizes.setWidth(8),
              mainAxisSpacing: AppSizes.setHeight(8),
              childAspectRatio: 1.0,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showImageViewer(context, imageUrls, index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: AppSizes.setWidth(24),
                              color: const Color(0xFF9CA3AF),
                            ),
                            SizedBox(height: AppSizes.setHeight(4)),
                            CommonText(
                              text: '加载失败',
                              fontSize: AppSizes.setFontSize(10),
                              textColor: const Color(0xFF9CA3AF),
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
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor(context).white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context
                      .read<PayOrderDetailCtrl>()
                      .reasonOfCancellation(context, order ?? OrderModel());
                },
                child: Container(
                  height: AppSizes.setHeight(48),
                  decoration: BoxDecoration(
                    // color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: CustomAppColor(context).borderGrey,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: CommonText(
                    text: '取消订单',
                    fontSize: AppSizes.setFontSize(16),
                    fontWeight: FontWeight.w500,
                    textColor: CustomAppColor(context).txtBlack,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSizes.setWidth(12)),
            Expanded(
              flex: 2,
              child: CommonButton(
                height: AppSizes.setHeight(48),
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

  void _showUploadDialog(
      BuildContext context, PayOrderDetailCtrl controller, bool hasUploaded) {
    // 初始化弹窗状态
    controller.initUploadDialog();

    showDialog(
      context: context,
      barrierDismissible: false, // 防止点击外部关闭弹窗
      builder: (BuildContext dialogContext) {
        return BlocBuilder<PayOrderDetailCtrl, PayOrderDetailState>(
          bloc: controller, // 直接传入 controller 实例
          builder: (context, dialogState) {
            final hasChanges = dialogState.selectedImagePaths.isNotEmpty ||
                (dialogState.currentProofUrls.length !=
                    (dialogState.order?.paymentProofUrls?.length ?? 0)) ||
                // 检查凭证内容是否有变化（简单比较长度，实际应该比较内容）
                !_listsEqual(dialogState.currentProofUrls,
                    dialogState.order?.paymentProofUrls ?? []);

            return PopScope(
              canPop: !dialogState.isUploading &&
                  !dialogState.isSavingProof &&
                  !hasChanges,
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(pt(16)),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '请上传转账凭证',
                        style: TextStyle(
                            fontSize: pt(18, isFontSize: true),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!dialogState.isUploading &&
                            !dialogState.isSavingProof) {
                          // 没有变更，直接关闭
                          controller.clearSelectedImages();
                          Navigator.of(dialogContext).pop();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(pt(4)),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: pt(18),
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
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
                        onRemoveUploadedImage: (index) {
                          controller.removeUploadedProof(index);
                        },
                        selectedImagePaths: dialogState.selectedImagePaths,
                        uploadedImageUrls: dialogState.currentProofUrls,
                        maxUploadCount: 5,
                      ),
                    ),
                  ),
                ),
                actions: [
                  SizedBox(width: pt(12)),
                  CommonButton(
                    btnText:
                        (dialogState.isUploading || dialogState.isSavingProof)
                            ? '上传中...'
                            : (!hasChanges ? '取消' : '确认上传'),
                    onTap:
                        (dialogState.isUploading || dialogState.isSavingProof)
                            ? null
                            : () async {
                                if (!hasChanges) {
                                  // 没有变更，直接关闭
                                  controller.clearSelectedImages();
                                  Navigator.of(dialogContext).pop();
                                } else {
                                  // 有变更，统一上传并保存
                                  final success =
                                      await controller.uploadAndSaveProof();
                                  if (success && dialogContext.mounted) {
                                    Navigator.of(dialogContext).pop();
                                  }
                                }
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

  /// 比较两个列表是否相等
  bool _listsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
