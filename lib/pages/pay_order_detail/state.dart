import '../pay_order_list/model/orders_data.dart';

class PayOrderDetailState {
  final OrderModel? order;
  final bool isLoading; // 是否正在加载订单详情
  final bool isUploading;
  final bool hasUploaded;
  final List<String> selectedImagePaths; // 当前选中的图片路径列表（本地）
  final List<String> uploadedImageUrls; // 已上传的图片URL列表
  final List<int> uploadingImageIndices; // 正在上传的图片索引列表
  final bool isLoadingImageUrl; // 是否正在加载图片URL
  final String? errorMessage; // 错误信息
  final bool isSavingProof; // 是否正在保存支付凭证
  final List<String> lastSavedProofUrls; // 上次保存的凭证URL列表

  PayOrderDetailState({
    this.order,
    this.isLoading = false,
    this.isUploading = false,
    this.hasUploaded = false,
    this.selectedImagePaths = const [],
    this.uploadedImageUrls = const [],
    this.uploadingImageIndices = const [],
    this.isLoadingImageUrl = false,
    this.errorMessage,
    this.isSavingProof = false,
    this.lastSavedProofUrls = const [],
  });

  PayOrderDetailState copyWith({
    OrderModel? order,
    bool? isLoading,
    bool? isUploading,
    bool? hasUploaded,
    List<String>? selectedImagePaths,
    bool clearSelectedImagePaths = false,
    List<String>? uploadedImageUrls,
    List<int>? uploadingImageIndices,
    bool? isLoadingImageUrl,
    String? errorMessage,
    bool? isSavingProof,
    List<String>? lastSavedProofUrls,
  }) {
    return PayOrderDetailState(
      order: order ?? this.order,
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
      isSavingProof: isSavingProof ?? this.isSavingProof,
      lastSavedProofUrls: lastSavedProofUrls ?? this.lastSavedProofUrls,
    );
  }
}
