import 'package:oil_business_app/pages/pay_order_detail/model/pay_order_type.dart';

class PayOrderDetailState {
  final PayOrderDetailModel? orderDetail;
  final bool isLoading; // 是否正在加载订单详情
  final bool isUploading;
  final bool hasUploaded;
  final List<String> selectedImagePaths; // 当前选中的图片路径列表（本地）
  final List<String> uploadedImageUrls; // 已上传的图片URL列表
  final List<int> uploadingImageIndices; // 正在上传的图片索引列表
  final bool isLoadingImageUrl; // 是否正在加载图片URL
  final String? errorMessage; // 错误信息

  PayOrderDetailState({
    this.orderDetail,
    this.isLoading = false,
    this.isUploading = false,
    this.hasUploaded = false,
    this.selectedImagePaths = const [],
    this.uploadedImageUrls = const [],
    this.uploadingImageIndices = const [],
    this.isLoadingImageUrl = false,
    this.errorMessage,
  });

  PayOrderDetailState copyWith({
    PayOrderDetailModel? orderDetail,
    bool? isLoading,
    bool? isUploading,
    bool? hasUploaded,
    List<String>? selectedImagePaths,
    bool clearSelectedImagePaths = false,
    List<String>? uploadedImageUrls,
    List<int>? uploadingImageIndices,
    bool? isLoadingImageUrl,
    String? errorMessage,
  }) {
    return PayOrderDetailState(
      orderDetail: orderDetail ?? this.orderDetail,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      hasUploaded: hasUploaded ?? this.hasUploaded,
      selectedImagePaths: clearSelectedImagePaths
          ? []
          : (selectedImagePaths ?? this.selectedImagePaths),
      uploadedImageUrls: uploadedImageUrls ?? this.uploadedImageUrls,
      uploadingImageIndices:
          uploadingImageIndices ?? this.uploadingImageIndices,
      isLoadingImageUrl: isLoadingImageUrl ?? this.isLoadingImageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
