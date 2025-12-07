import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/global/commom/upload.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/pages/pay_order_list/service/pay_order_list.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/bottom_sheet/bottom_sheet.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

import '../pay_order_list/model/orders_data.dart';
import 'model/payment_proof_request.dart';
import 'service/pay_order_service.dart';
import 'state.dart';

class PayOrderDetailCtrl extends Cubit<PayOrderDetailState> {
  final OrderModel? order;
  final int? orderId;
  Future<void>? _pendingSaveOperation;

  PayOrderDetailCtrl(this.order, {this.orderId})
      : super(
          PayOrderDetailState(),
        ) {
    initState();
  }

  initState() async {
    await loadOrderDetail();
  }

  TextEditingController cancelOrderReasonController = TextEditingController();

  /// 加载订单详情
  Future<void> loadOrderDetail() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final id = order?.id ?? orderId;
      if (id == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: '订单ID不能为空',
        ));
        return;
      }

      final response = await payOrderService.getOrderDetail(id.toString());

      // 合并银行信息（这些信息可能来自配置或其他接口）
      final orderDetail = response.copyWith(
        accountName: 'XXXX科技有限公司', // 这里应该从配置或其他接口获取
        bankAccount: 'XXXX',
        bankName: 'XXXX',
        bankBranchNumber: 'XXXX',
      );

      // 初始化已上传的凭证列表
      final proofUrls = orderDetail.paymentProofUrls ?? [];

      emit(state.copyWith(
        order: orderDetail,
        isLoading: false,
        hasUploaded: orderDetail.status == OrderStatus.PaymentUploaded,
        selectedImagePaths: const [], // 初始化时清空选中的图片
        lastSavedProofUrls: const [], // 初始化时清空上次保存的凭证列表
        currentProofUrls: proofUrls, // 初始化当前凭证列表
      ));

      // 如果已有凭证路径，获取可访问的URL
      // if (orderDetail.attachments?.isNotEmpty ?? false) {
      //   await _loadVoucherImageUrls(orderDetail.attachments!);
      // } else {
      //   // 如果没有附件，清空已上传的图片URL列表
      //   emit(state.copyWith(uploadedImageUrls: []));
      // }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '加载订单详情失败: ${e.toString()}',
      ));
    }
  }

  /// 选择单张图片
  Future<void> pickSingleImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      // 限制最多上传5张图片（后端要求1-5张之间）
      const maxImages = 5;
      final totalImages = state.selectedImagePaths.length;

      if (totalImages >= maxImages) {
        SportsToast.showWarning('最多只能上传$maxImages张图片');
        return;
      }

      final updatedImagePaths = [...state.selectedImagePaths, image.path];
      emit(state.copyWith(selectedImagePaths: updatedImagePaths));
    } catch (e) {
      SportsToast.showError('选择图片失败');
    }
  }

  /// 删除选中的图片
  void removeSelectedImage(int index) {
    final currentImages = List<String>.from(state.selectedImagePaths);
    if (index >= 0 && index < currentImages.length) {
      currentImages.removeAt(index);

      emit(state.copyWith(
        selectedImagePaths: currentImages,
      ));
    }
  }

  /// 删除已上传的凭证
  void removeUploadedProof(int index) {
    final currentProofs = List<String>.from(state.currentProofUrls);
    if (index >= 0 && index < currentProofs.length) {
      currentProofs.removeAt(index);

      emit(state.copyWith(
        currentProofUrls: currentProofs,
      ));
    }
  }

  /// 清除所有选中的图片
  void clearSelectedImages() {
    emit(state.copyWith(
      clearSelectedImagePaths: true,
    ));
  }

  /// 初始化弹窗状态（打开弹窗时调用）
  void initUploadDialog() {
    // 将订单中的凭证URL列表复制到currentProofUrls，用于弹窗编辑
    final proofUrls = state.order?.paymentProofUrls ?? [];
    emit(state.copyWith(
      currentProofUrls: List<String>.from(proofUrls),
      selectedImagePaths: const [], // 清空新选择的图片
    ));
  }

  /// 统一上传并保存凭证（在确认按钮点击时调用）
  Future<bool> uploadAndSaveProof() async {
    final imagePaths = state.selectedImagePaths;
    final currentProofs = state.currentProofUrls;

    // 合并已上传的凭证和新上传的凭证
    final totalCount = currentProofs.length + imagePaths.length;

    // 验证至少需要1张凭证
    if (totalCount == 0) {
      SportsToast.showWarning('请至少保留1张转账凭证');
      return false;
    }

    // 验证凭证数量：后端要求1-5张之间
    if (totalCount > 5) {
      SportsToast.showError('凭证数量不能超过5张，请删除多余的凭证');
      return false;
    }

    try {
      // 如果有新选择的图片，需要上传
      if (imagePaths.isNotEmpty) {
        emit(state.copyWith(
          isUploading: true,
          uploadingImageIndices:
              List.generate(imagePaths.length, (index) => index),
        ));

        final List<String> uploadedUrls = [];

        // 顺序上传所有新选择的图片
        for (int index = 0; index < imagePaths.length; index++) {
          final imagePath = imagePaths[index];
          try {
            final file = File(imagePath);
            if (!await file.exists()) {
              continue;
            }

            final uploadUrl = await uploadImage(imagePath);
            if (uploadUrl != null && uploadUrl.isNotEmpty) {
              uploadedUrls.add(uploadUrl);
            }
          } catch (e) {
            // 单个图片上传失败，继续上传其他图片
          }
        }

        // 合并已上传的凭证和新上传的凭证
        final finalProofUrls = [...currentProofs, ...uploadedUrls];

        // 验证最终凭证列表不能为空（后端要求至少1张）
        if (finalProofUrls.isEmpty) {
          emit(state.copyWith(
            uploadingImageIndices: [],
            isUploading: false,
          ));
          // 如果原凭证为空且新图片上传失败，给出更明确的提示
          if (currentProofs.isEmpty && uploadedUrls.isEmpty) {
            SportsToast.showError('图片上传失败，请重新选择图片');
          } else {
            SportsToast.showError('凭证上传失败，请至少保留1张转账凭证');
          }
          return false;
        }

        // 更新状态
        emit(state.copyWith(
          selectedImagePaths: [],
          uploadedImageUrls: uploadedUrls,
          uploadingImageIndices: [],
          isUploading: false,
          hasUploaded: true,
          currentProofUrls: finalProofUrls,
        ));

        // 保存凭证列表
        await savePaymentProof(finalProofUrls);

        if (uploadedUrls.length < imagePaths.length) {
          SportsToast.showWarning(
              '${uploadedUrls.length}张图片上传成功，${imagePaths.length - uploadedUrls.length}张图片上传失败');
        } else if (imagePaths.length > 0) {
          SportsToast.showSuccess('凭证上传成功');
        }
      } else {
        // 没有新选择的图片，只保存当前已上传的凭证列表
        await savePaymentProof(currentProofs);
        if (currentProofs.isEmpty) {
          SportsToast.showSuccess('已删除所有凭证');
        } else {
          SportsToast.showSuccess('凭证已更新');
        }
      }

      return true;
    } catch (e) {
      emit(state.copyWith(
        isUploading: false,
        uploadingImageIndices: [],
      ));
      SportsToast.showError('上传失败: ${e.toString()}');
      return false;
    }
  }

  /// 保存支付凭证
  Future<void> savePaymentProof(List<String> proofUrls) async {
    final id = order?.id ?? orderId;
    if (id == null) {
      SportsToast.showError('订单ID不能为空');
      return;
    }

    // 验证凭证数量：后端要求至少1张，最多5张
    if (proofUrls.isEmpty) {
      SportsToast.showError('凭证不能为空，请至少保留1张转账凭证');
      return;
    }

    if (proofUrls.length > 5) {
      SportsToast.showError('凭证数量不能超过5张，请删除多余的凭证');
      return;
    }

    // 如果正在保存，等待上一次操作完成
    if (_pendingSaveOperation != null) {
      try {
        await _pendingSaveOperation;
      } catch (e) {
        // 忽略错误，继续执行新的保存操作
      }
    }

    // 创建新的保存操作
    _pendingSaveOperation = _performSavePaymentProof(id, proofUrls);
    await _pendingSaveOperation;
  }

  /// 执行保存支付凭证操作
  Future<void> _performSavePaymentProof(int id, List<String> proofUrls) async {
    emit(state.copyWith(isSavingProof: true));

    try {
      final request = PaymentProofRequest(proof: proofUrls);
      await payOrderService.savePaymentProof(id.toString(), request);

      // 保存成功
      emit(state.copyWith(
        isSavingProof: false,
        lastSavedProofUrls: List<String>.from(proofUrls),
      ));

      // 刷新订单详情，更新订单状态
      await loadOrderDetail();
    } catch (e) {
      emit(state.copyWith(isSavingProof: false));
      SportsToast.showError('保存支付凭证失败: ${e.toString()}');
      rethrow;
    } finally {
      _pendingSaveOperation = null;
    }
  }

  /// 更新订单的支付凭证（支持多张图片）
  /// @param attachments 凭证附件列表
  Future<void> updateOrderVouchers(List<String?> attachments) async {
    // final request = UpdateOrderVoucherRequest(
    //   attachments: attachments,
    //   status: 'Submitted',
    // );
    // final res =
    //     await payOrderService.updateOrderVoucher(order.id.toString(), request);
    // if (res.code == HttpCode.success) {
    //   SportsToast.showSuccess('凭证上传成功');
    // } else {
    //   SportsToast.showError(res.message ?? '');
    // }
  }

  Future<void> cancelOrder(String id) async {
    await payOrderListService.cancelOrder(id, cancelOrderReasonController.text);
    SportsToast.showSuccess('取消订单成功');
    loadOrderDetail();
    cancelOrderReasonController.clear();
  }

  void reasonOfCancellation(BuildContext context, OrderModel order) {
    customBottomSheet(
      isPaddingRequired: false,
      isDone: false,
      context: context,
      maxHeightRatio: 0.5,
      title: '取消订单',
      content: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Padding(
          //   padding:
          //       EdgeInsets.symmetric(horizontal: AppSizes.setWidth(22)),
          //   child: CommonText(
          //     text: '请选择取消订单的原因',
          //     textColor: CustomAppColor.of(context).txtGrey,
          //     fontSize: AppSizes.setFontSize(15),
          //     fontWeight: FontWeight.w500,
          //     textAlign: TextAlign.start,
          //   ),
          // ),
          SizedBox(height: AppSizes.setHeight(10)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
            child: CommonTextFormField(
              controller: cancelOrderReasonController,
              radius: 6,
              hintText: '请输入取消订单的原因',
              hintStyle: TextStyle(
                color: CustomAppColor.of(context).txtGrey,
                fontSize: AppSizes.setFontSize(15),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 4,
            ),
          ),
          SizedBox(height: AppSizes.setHeight(10)),
          Container(
            decoration: BoxDecoration(
              color: CustomAppColor.of(context).bgBlackWhiteScaffold,
              border: Border(
                top: BorderSide(
                    color: CustomAppColor.of(context)
                        .txtGrey
                        .withValues(alpha: 0.5)),
              ),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.setWidth(22),
                vertical: AppSizes.setHeight(18)),
            child: CommonButton(
              height: AppSizes.setHeight(44),
              radius: 3,
              btnText: '取消订单',
              onTap: () async {
                await cancelOrder(order.id?.toString() ?? '');
                BaseRouter.pop();
              },
            ),
          ),
        ],
      ),
    ).whenComplete(() {});
  }
}
