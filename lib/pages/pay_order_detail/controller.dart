import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/net/code.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

import 'model/pay_order_type.dart';
import 'service/pay_order_service.dart';
import 'state.dart';

class PayOrderDetailCtrl extends Cubit<PayOrderDetailState> {
  final String uuid;

  PayOrderDetailCtrl(this.uuid)
      : super(
          PayOrderDetailState(),
        ) {
    initState();
  }

  initState() async {
    await loadOrderDetail();
  }

  /// 加载订单详情
  Future<void> loadOrderDetail() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final response = await payOrderService.getOrderDetail(uuid);

      if (response.code == HttpCode.success && response.data != null) {
        // 合并银行信息（这些信息可能来自配置或其他接口）
        final orderDetail = response.data!.copyWith(
          accountName: '闪省（重庆）网络科技有限公司', // 这里应该从配置或其他接口获取
          bankAccount: '1239 1799 7710 001',
          bankName: '招商银行重庆分行江北支行',
          bankBranchNumber: '3086 5301 8042',
        );

        emit(state.copyWith(
          orderDetail: orderDetail,
          isLoading: false,
          hasUploaded: orderDetail.attachments?.isNotEmpty ?? false,
        ));

        // 如果已有凭证路径，获取可访问的URL
        if (orderDetail.attachments?.isNotEmpty ?? false) {
          await _loadVoucherImageUrls(orderDetail.attachments!);
        } else {
          // 如果没有附件，清空已上传的图片URL列表
          emit(state.copyWith(uploadedImageUrls: []));
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        ));
      }
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

      // 限制最多上传20张图片
      const maxImages = 20;
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
      final orderDetail = state.orderDetail;

      if (index < 0 ||
          index >= uploadedUrls.length ||
          orderDetail?.attachments == null) {
        SportsToast.showError('图片索引错误');
        return;
      }

      final attachments = orderDetail!.attachments!;
      if (index >= attachments.length) {
        SportsToast.showError('附件索引错误');
        return;
      }

      // 创建新的附件列表，移除指定索引的附件
      final updatedAttachments = List<FileAttachment>.from(attachments);
      updatedAttachments.removeAt(index);

      // 更新订单凭证
      await updateOrderVouchers(updatedAttachments);

      // 更新本地状态
      final updatedUploadedUrls = List<String>.from(uploadedUrls);
      updatedUploadedUrls.removeAt(index);

      // 更新orderDetail
      final updatedOrderDetail = orderDetail.copyWith(
        attachments: updatedAttachments,
        voucherUrl:
            updatedUploadedUrls.isNotEmpty ? updatedUploadedUrls.first : null,
      );

      emit(state.copyWith(
        orderDetail: updatedOrderDetail,
        uploadedImageUrls: updatedUploadedUrls,
        hasUploaded: updatedUploadedUrls.isNotEmpty,
      ));

      SportsToast.showSuccess('图片删除成功');
    } catch (e) {
      SportsToast.showError('删除图片失败: ${e.toString()}');
    }
  }

  /// 一键上传所有待上传图片
  Future<void> uploadAllImages() async {
    final imagePaths = state.selectedImagePaths;
    if (imagePaths.isEmpty) {
      // SportsToast.showWarning('没有待上传的图片');
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

      final List<FileAttachment> newAttachments = [];
      final List<String> newImageUrls = [];
      final List<int> failedIndices = [];

      // 并发上传所有图片
      final uploadTasks = imagePaths.asMap().entries.map((entry) async {
        final index = entry.key;
        final imagePath = entry.value;

        try {
          // 读取文件
          final file = File(imagePath);
          if (!await file.exists()) {
            failedIndices.add(index);
            return;
          }

          final fileBytes = await file.readAsBytes();
          final fileName = file.path.split('/').last;

          // 创建FormData
          final formData = FormData.fromMap({
            'fileType': FileUploadTypeEnum.Img.value,
            'method': 'PUT',
            'file': MultipartFile.fromBytes(
              fileBytes,
              filename: fileName,
            ),
          });

          // 调用上传接口
          final uploadResponse = await payOrderService.uploadFile(formData);

          if (uploadResponse.code == HttpCode.success &&
              uploadResponse.data.path != null) {
            // 获取可访问的URL
            String? imageUrl;
            try {
              final signUrlResponse = await payOrderService
                  .getFileSignUrl(uploadResponse.data.path!);
              if (signUrlResponse.code == HttpCode.success &&
                  signUrlResponse.data != null) {
                imageUrl = signUrlResponse.data;
              }
            } catch (e) {
              // getFileSignUrl失败不影响主流程
            }

            // 创建新的附件
            final newAttachment = FileAttachment(
              path: uploadResponse.data.path!,
              uuid: uploadResponse.data.uuid!,
            );

            newAttachments.add(newAttachment);
            if (imageUrl != null) {
              newImageUrls.add(imageUrl);
            }
          } else {
            failedIndices.add(index);
          }
        } catch (e) {
          failedIndices.add(index);
        }
      });

      // 等待所有上传任务完成
      await Future.wait(uploadTasks);

      // 更新订单凭证 - 保留之前的附件并添加新的
      if (newAttachments.isNotEmpty) {
        final currentAttachments = state.orderDetail?.attachments ?? [];
        final updatedAttachments = [...currentAttachments, ...newAttachments];
        await updateOrderVouchers(updatedAttachments);

        // 更新本地状态
        final updatedUploadedUrls = [
          ...state.uploadedImageUrls,
          ...newImageUrls
        ];

        // 更新orderDetail中的attachments字段
        final currentOrderDetail = state.orderDetail;
        PayOrderDetailModel? updatedOrderDetail;
        if (currentOrderDetail != null) {
          updatedOrderDetail = currentOrderDetail.copyWith(
            attachments: updatedAttachments,
            voucherUrl: updatedUploadedUrls.isNotEmpty
                ? updatedUploadedUrls.first
                : null,
          );
        }

        emit(state.copyWith(
          orderDetail: updatedOrderDetail,
          selectedImagePaths: [], // 清空待上传列表
          uploadedImageUrls: updatedUploadedUrls,
          uploadingImageIndices: [], // 清空上传中状态
          hasUploaded: true,
        ));

        if (failedIndices.isEmpty) {
          SportsToast.showSuccess('所有图片上传成功');
        } else {
          SportsToast.showWarning(
              '${newAttachments.length}张图片上传成功，${failedIndices.length}张图片上传失败');
        }
      } else {
        // 所有图片都上传失败
        emit(state.copyWith(uploadingImageIndices: []));
        SportsToast.showError('所有图片上传失败，请重试');
      }
    } catch (e) {
      emit(state.copyWith(uploadingImageIndices: []));
      SportsToast.showError('批量上传失败: ${e.toString()}');
    }
  }

  /// 上传单张图片
  Future<bool> uploadSingleImage(int imageIndex) async {
    final imagePaths = state.selectedImagePaths;
    if (imageIndex >= imagePaths.length) {
      SportsToast.showError('图片索引错误');
      return false;
    }

    final imagePath = imagePaths[imageIndex];

    try {
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

      final fileBytes = await file.readAsBytes();
      final fileName = file.path.split('/').last;

      // 创建FormData
      final formData = FormData.fromMap({
        'fileType': FileUploadTypeEnum.Img.value,
        'method': 'PUT',
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });

      // 调用上传接口
      final uploadResponse = await payOrderService.uploadFile(formData);

      if (uploadResponse.code == HttpCode.success &&
          uploadResponse.data.path != null) {
        // 获取可访问的URL
        final signUrlResponse =
            await payOrderService.getFileSignUrl(uploadResponse.data.path!);
        String? imageUrl;
        if (signUrlResponse.code == HttpCode.success &&
            signUrlResponse.data != null) {
          imageUrl = signUrlResponse.data;
        }

        // 创建新的附件
        final newAttachment = FileAttachment(
          path: uploadResponse.data.path!,
          uuid: uploadResponse.data.uuid!,
        );

        // 更新订单凭证 - 保留之前的附件并添加新的
        final currentAttachments = state.orderDetail?.attachments ?? [];
        final updatedAttachments = [...currentAttachments, newAttachment];
        await updateOrderVouchers(updatedAttachments);

        // 更新本地状态 - 同时更新orderDetail中的attachments
        final updatedSelectedPaths =
            List<String>.from(state.selectedImagePaths);
        updatedSelectedPaths.removeAt(imageIndex);

        final updatedUploadedUrls = List<String>.from(state.uploadedImageUrls);
        if (imageUrl != null) {
          updatedUploadedUrls.add(imageUrl);
        }

        // 更新orderDetail中的attachments字段
        final currentOrderDetail = state.orderDetail;
        PayOrderDetailModel? updatedOrderDetail;
        if (currentOrderDetail != null) {
          updatedOrderDetail = currentOrderDetail.copyWith(
            attachments: updatedAttachments,
            voucherUrl: updatedUploadedUrls.isNotEmpty
                ? updatedUploadedUrls.first
                : null,
          );
        }

        // 从上传中列表移除当前索引，并调整其他索引
        final updatedUploadingIndices = state.uploadingImageIndices
            .where((i) => i != imageIndex)
            .map((i) => i > imageIndex ? i - 1 : i) // 调整索引，因为删除了一个元素
            .toList();

        emit(state.copyWith(
          orderDetail: updatedOrderDetail,
          selectedImagePaths: updatedSelectedPaths,
          uploadedImageUrls: updatedUploadedUrls,
          uploadingImageIndices: updatedUploadingIndices,
          hasUploaded: true,
        ));

        SportsToast.showSuccess('图片上传成功');
        return true;
      } else {
        throw Exception('上传失败: ${uploadResponse.message}');
      }
    } on DioException catch (e) {
      // 从上传中列表移除当前索引
      final updatedUploadingIndices =
          state.uploadingImageIndices.where((i) => i != imageIndex).toList();
      emit(state.copyWith(uploadingImageIndices: updatedUploadingIndices));
      SportsToast.showError(e.response?.data?['message'] ?? '上传失败，请重试');
      return false;
    } catch (e) {
      // 从上传中列表移除当前索引
      final updatedUploadingIndices =
          state.uploadingImageIndices.where((i) => i != imageIndex).toList();
      emit(state.copyWith(uploadingImageIndices: updatedUploadingIndices));
      SportsToast.showError('上传失败: ${e.toString()}');
      return false;
    }
  }

  /// 更新订单的支付凭证（支持多张图片）
  /// @param attachments 凭证附件列表
  Future<void> updateOrderVouchers(List<FileAttachment> attachments) async {
    final request = UpdateOrderVoucherRequest(
      attachments: attachments,
      status: 'Submitted',
    );
    final res = await payOrderService.updateOrderVoucher(uuid, request);
    if (res.code == HttpCode.success) {
      SportsToast.showSuccess('凭证上传成功');
    } else {
      SportsToast.showError(res.message ?? '');
    }
  }

  /// 加载多张凭证图片URL
  Future<void> _loadVoucherImageUrls(List<FileAttachment> attachments) async {
    try {
      emit(state.copyWith(isLoadingImageUrl: true));

      final List<String> imageUrls = [];

      for (final attachment in attachments) {
        if (attachment.path != null) {
          final signUrlResponse =
              await payOrderService.getFileSignUrl(attachment.path!);
          if (signUrlResponse.code == HttpCode.success &&
              signUrlResponse.data != null) {
            imageUrls.add(signUrlResponse.data!);
          }
        }
      }

      // 更新第一张图片的URL到voucherUrl字段（保持兼容性）
      final currentOrderDetail = state.orderDetail;
      if (currentOrderDetail != null) {
        final updatedOrderDetail = currentOrderDetail.copyWith(
          voucherUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
        );

        emit(state.copyWith(
          orderDetail: updatedOrderDetail,
          uploadedImageUrls: imageUrls,
          isLoadingImageUrl: false,
          hasUploaded: imageUrls.isNotEmpty,
        ));
      } else {
        emit(state.copyWith(
          uploadedImageUrls: imageUrls,
          isLoadingImageUrl: false,
          hasUploaded: imageUrls.isNotEmpty,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingImageUrl: false));
    }
  }

  /// 取消订单
  Future<void> cancelOrder() async {
    final request = CancelRechargeRequest(status: 'Canceled');
    final res = await payOrderService.cancelRecharge(uuid, request);

    if (res.code == HttpCode.success) {
      SportsToast.showSuccess('订单已取消');
      await loadOrderDetail(); // 重新加载页面数据
    } else {
      SportsToast.showError(res.message ?? '');
    }
  }
}
