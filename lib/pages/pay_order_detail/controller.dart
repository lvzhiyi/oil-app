import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/global/commom/upload.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

import '../pay_order_list/model/orders_data.dart';
import 'model/payment_proof_request.dart';
import 'service/pay_order_service.dart';
import 'state.dart';

class PayOrderDetailCtrl extends Cubit<PayOrderDetailState> {
  final OrderModel? order;
  final int? orderId;
  Timer? _saveProofDebounceTimer;
  Future<void>? _pendingSaveOperation;

  PayOrderDetailCtrl(this.order, {this.orderId})
      : super(
          PayOrderDetailState(),
        ) {
    initState();
  }

  @override
  Future<void> close() {
    _saveProofDebounceTimer?.cancel();
    return super.close();
  }

  initState() async {
    await loadOrderDetail();
  }

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

      emit(state.copyWith(
        order: orderDetail,
        isLoading: false,
        hasUploaded: orderDetail.status == OrderStatus.PaymentUploaded,
        lastSavedProofUrls: const [], // 初始化时清空上次保存的凭证列表
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
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      // 限制最多上传5张图片（后端要求1-5张之间）
      const maxImages = 5;
      final totalImages =
          state.selectedImagePaths.length + state.uploadedImageUrls.length;

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

      // 调整上传中的索引列表
      final updatedUploadingIndices = state.uploadingImageIndices
          .where((i) => i != index) // 移除被删除图片的索引
          .map((i) => i > index ? i - 1 : i) // 调整后续索引
          .toList();

      emit(state.copyWith(
        selectedImagePaths: currentImages,
        uploadingImageIndices: updatedUploadingIndices,
      ));
    }
  }

  /// 清除所有选中的图片
  void clearSelectedImages() {
    emit(state.copyWith(
      clearSelectedImagePaths: true,
      uploadingImageIndices: [], // 同时清空上传中的索引列表
    ));
  }

  /// 删除已上传的图片
  Future<void> removeUploadedImage(int index) async {
    try {
      final uploadedUrls = state.uploadedImageUrls;
      final orderDetail = state.order;

      if (index < 0 || index >= uploadedUrls.length || orderDetail == null) {
        SportsToast.showError('图片索引错误');
        return;
      }

      // 更新本地状态
      final updatedUploadedUrls = List<String>.from(uploadedUrls);
      updatedUploadedUrls.removeAt(index);

      // 如果删除后凭证数量为0，提示用户至少需要1张凭证
      if (updatedUploadedUrls.isEmpty) {
        SportsToast.showWarning('至少需要保留1张凭证');
        return;
      }

      emit(state.copyWith(
        order: orderDetail,
        uploadedImageUrls: updatedUploadedUrls,
        hasUploaded: updatedUploadedUrls.isNotEmpty,
      ));

      SportsToast.showSuccess('图片删除成功');

      // 删除后立即保存凭证列表
      _savePaymentProofDebounced(updatedUploadedUrls);
    } catch (e) {
      SportsToast.showError('删除图片失败: ${e.toString()}');
    }
  }

  /// 一键上传所有待上传图片
  Future<void> uploadAllImages() async {
    final imagePaths = state.selectedImagePaths;
    if (imagePaths.isEmpty) {
      return;
    }

    // 检查是否有图片正在上传
    if (state.uploadingImageIndices.isNotEmpty) {
      SportsToast.showWarning('请等待当前图片上传完成');
      return;
    }

    try {
      // 将所有图片索引添加到上传中列表
      final allIndices = List.generate(imagePaths.length, (index) => index);
      emit(state.copyWith(uploadingImageIndices: allIndices));

      final List<String> newImageUrls = [];
      final List<int> failedIndices = [];

      // 顺序上传所有图片（避免并发过多）
      for (int index = 0; index < imagePaths.length; index++) {
        final imagePath = imagePaths[index];
        try {
          final file = File(imagePath);
          if (!await file.exists()) {
            failedIndices.add(index);
            continue;
          }

          final uploadUrl = await uploadImage(imagePath);
          if (uploadUrl != null && uploadUrl.isNotEmpty) {
            newImageUrls.add(uploadUrl);
          } else {
            failedIndices.add(index);
          }
        } catch (e) {
          failedIndices.add(index);
        }
      }

      // 更新状态
      final updatedSelectedPaths = <String>[];
      final updatedUploadedUrls = [
        ...state.uploadedImageUrls,
        ...newImageUrls
      ];

      emit(state.copyWith(
        selectedImagePaths: updatedSelectedPaths,
        uploadedImageUrls: updatedUploadedUrls,
        uploadingImageIndices: [],
        hasUploaded: updatedUploadedUrls.isNotEmpty,
      ));

      if (failedIndices.isEmpty) {
        SportsToast.showSuccess('所有图片上传成功');
        // 上传成功后立即保存凭证列表
        _savePaymentProofDebounced(updatedUploadedUrls);
      } else {
        SportsToast.showWarning(
            '${newImageUrls.length}张图片上传成功，${failedIndices.length}张图片上传失败');
        // 即使有部分失败，也保存已成功上传的凭证
        if (newImageUrls.isNotEmpty) {
          _savePaymentProofDebounced(updatedUploadedUrls);
        }
      }
    } catch (e) {
      emit(state.copyWith(uploadingImageIndices: []));
      SportsToast.showError('批量上传失败: ${e.toString()}');
    }
  }

  /// 上传单张图片
  Future uploadSingleImage(int imageIndex) async {
    final imagePaths = state.selectedImagePaths;
    if (imageIndex >= imagePaths.length) {
      SportsToast.showError('图片索引错误');
      return false;
    }

    final imagePath = imagePaths[imageIndex];

    // 添加当前图片索引到上传中列表
    final updatedUploadingIndices = [
      ...state.uploadingImageIndices,
      imageIndex
    ];
    emit(state.copyWith(uploadingImageIndices: updatedUploadingIndices));

    // 读取文件
    final file = File(imagePath);
    if (!await file.exists()) {
      // 从上传中列表移除当前索引
      final updatedUploadingIndices =
          state.uploadingImageIndices.where((i) => i != imageIndex).toList();
      emit(state.copyWith(uploadingImageIndices: updatedUploadingIndices));
      SportsToast.showError('图片文件不存在');
      return false;
    }

    try {
      // 调用上传接口
      final uploadUrl = await uploadImage(imagePath);
      
      if (uploadUrl == null || uploadUrl.isEmpty) {
        // 上传失败，从上传中列表移除当前索引
        final updatedUploadingIndices =
            state.uploadingImageIndices.where((i) => i != imageIndex).toList();
        emit(state.copyWith(uploadingImageIndices: updatedUploadingIndices));
        SportsToast.showError('图片上传失败，请重试');
        return false;
      }

      // 上传成功，更新状态
      final updatedSelectedPaths = List<String>.from(state.selectedImagePaths);
      updatedSelectedPaths.removeAt(imageIndex);

      final updatedUploadedUrls = List<String>.from(state.uploadedImageUrls);
      updatedUploadedUrls.add(uploadUrl);

      // 从上传中列表移除当前索引，并调整其他索引
      final finalUploadingIndices = state.uploadingImageIndices
          .where((i) => i != imageIndex)
          .map((i) => i > imageIndex ? i - 1 : i) // 调整索引，因为删除了一个元素
          .toList();

      emit(state.copyWith(
        selectedImagePaths: updatedSelectedPaths,
        uploadedImageUrls: updatedUploadedUrls,
        uploadingImageIndices: finalUploadingIndices,
        hasUploaded: true,
      ));

      SportsToast.showSuccess('图片上传成功');

      // 上传成功后立即保存凭证列表
      _savePaymentProofDebounced(updatedUploadedUrls);

      return true;
    } catch (e) {
      // 上传异常，从上传中列表移除当前索引
      final updatedUploadingIndices =
          state.uploadingImageIndices.where((i) => i != imageIndex).toList();
      emit(state.copyWith(uploadingImageIndices: updatedUploadingIndices));
      SportsToast.showError('图片上传失败: ${e.toString()}');
      return false;
    }
  }

  /// 保存支付凭证（带防抖）
  void _savePaymentProofDebounced(List<String> proofUrls) {
    _saveProofDebounceTimer?.cancel();
    _saveProofDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      savePaymentProof(proofUrls);
    });
  }

  /// 保存支付凭证
  Future<void> savePaymentProof(List<String> proofUrls) async {
    final id = order?.id ?? orderId;
    if (id == null) {
      SportsToast.showError('订单ID不能为空');
      return;
    }

    // 验证凭证数量：后端要求1-5张之间
    if (proofUrls.isEmpty) {
      // 如果凭证数量为0，不调用保存接口（删除所有凭证的情况）
      // 更新上次保存的凭证列表为空，避免重复保存
      emit(state.copyWith(lastSavedProofUrls: []));
      return;
    }

    if (proofUrls.length > 5) {
      SportsToast.showError('凭证数量不能超过5张，请删除多余的凭证');
      return;
    }

    // 如果凭证列表与上次保存的一致，则不需要保存
    if (_isProofUrlsEqual(proofUrls, state.lastSavedProofUrls)) {
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

      // 保存成功，更新上次保存的凭证列表
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

  /// 判断两个凭证URL列表是否相等
  bool _isProofUrlsEqual(List<String> urls1, List<String> urls2) {
    if (urls1.length != urls2.length) {
      return false;
    }
    for (int i = 0; i < urls1.length; i++) {
      if (urls1[i] != urls2[i]) {
        return false;
      }
    }
    return true;
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

  /// 加载多张凭证图片URL
  Future<void> _loadVoucherImageUrls(List<String> attachments) async {
    // try {
    //   emit(state.copyWith(isLoadingImageUrl: true));

    //   final List<String> imageUrls = [];

    //   for (final attachment in attachments) {
    //     if (attachment.path != null) {
    //       final signUrlResponse =
    //           await payOrderService.getFileSignUrl(attachment.path!);
    //       if (signUrlResponse.code == HttpCode.success &&
    //           signUrlResponse.data != null) {
    //         imageUrls.add(signUrlResponse.data!);
    //       }
    //     }
    //   }

    //   // 更新第一张图片的URL到voucherUrl字段（保持兼容性）
    //   // final currentOrderDetail = state.orderDetail;
    //   // if (currentOrderDetail != null) {
    //   //   final updatedOrderDetail = currentOrderDetail.copyWith(
    //   //     voucherUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
    //   //   );

    //   //   emit(state.copyWith(
    //   //     orderDetail: updatedOrderDetail,
    //   //     uploadedImageUrls: imageUrls,
    //   //     isLoadingImageUrl: false,
    //   //     hasUploaded: imageUrls.isNotEmpty,
    //   //   ));
    //   // } else {
    //   //   emit(state.copyWith(
    //   //     uploadedImageUrls: imageUrls,
    //   //     isLoadingImageUrl: false,
    //   //     hasUploaded: imageUrls.isNotEmpty,
    //   //   ));
    //   // }
    // } catch (e) {
    //   emit(state.copyWith(isLoadingImageUrl: false));
    // }
  }

  /// 取消订单
  Future<void> cancelOrder() async {
    // final request = CancelRechargeRequest(status: 'Canceled');
    // final res =
    //     await payOrderService.cancelRecharge(order.id.toString(), request);

    // if (res.code == HttpCode.success) {
    //   SportsToast.showSuccess('订单已取消');
    //   await loadOrderDetail(); // 重新加载页面数据
    // } else {
    //   SportsToast.showError(res.message ?? '');
    // }
  }
}

