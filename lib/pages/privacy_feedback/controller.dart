import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class PrivacyFeedbackController extends Cubit<PrivacyFeedbackState> {
  PrivacyFeedbackController() : super(PrivacyFeedbackState()) {
    _loadData();
  }

  void _loadData() async {
    emit(state.copyWith(isLoading: true));
    // Mock data delay
    await Future.delayed(const Duration(seconds: 1));
    final mockItems = [
      PrivacyFeedbackItem(id: '1', title: '无法删除账号', date: '2023-10-01', status: '已解决'),
      PrivacyFeedbackItem(id: '2', title: '数据导出请求', date: '2023-10-05', status: '处理中'),
      PrivacyFeedbackItem(id: '3', title: '关于隐私政策的疑问', date: '2023-10-10', status: '待处理'),
    ];
    emit(state.copyWith(items: mockItems, isLoading: false));
  }
}
