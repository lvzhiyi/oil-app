import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottery_app/pages/employee_management/edit_employee/controller.dart';
import 'package:lottery_app/pages/employee_management/edit_employee/state.dart';
import 'package:lottery_app/pages/employee_management/edit_employee/view.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/sports_app_bar.dart';

class EditEmployeePage extends StatelessWidget {
  final String? employeeId;

  const EditEmployeePage({
    Key? key,
    this.employeeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditEmployeeController(employeeId: employeeId),
      child: BlocBuilder<EditEmployeeController, EditEmployeeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFF),
            appBar: SportsAppBar(
              title: state.isEditMode ? '编辑员工' : '新建员工',
              onBack: () => context.pop(),
              actions: [
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () => _handleSave(context, state),
                  child: state.isLoading
                      ? SizedBox(
                          width: pt(20),
                          height: pt(20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: AppColors.primary,
                          ),
                        )
                      : Text(
                          '保存',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: pt(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : const EditEmployeeView(),
          );
        },
      ),
    );
  }

  /// 处理保存操作
  Future<void> _handleSave(BuildContext context, EditEmployeeState state) async {
    // 先进行表单校验
    if (!EditEmployeeViewValidator.instance.validate()) {
      return;
    }

    // 进行角色校验
    if (state.roles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一个角色')),
      );
      return;
    }

    // 执行保存
    final success = await context.read<EditEmployeeController>().saveEmployee();
    if (success && context.mounted) {
      context.pop(true);
    }
  }
}
