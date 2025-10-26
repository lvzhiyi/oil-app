import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/pages/employee_management/model/common_type.dart';

import 'package:lottery_app/utils/pt.dart';

class EmployeeEditDialog extends HookWidget {
  final EmployeeInfo? employee;
  final Function(EmployeeEditRequest) onSave;

  const EmployeeEditDialog({
    Key? key,
    this.employee,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController =
        useTextEditingController(text: employee?.username ?? '');
    final phoneController =
        useTextEditingController(text: employee?.phone ?? '');
    final selectedRole =
        useState<EmployeeRole>(employee?.roles.first ?? EmployeeRole.employee);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return AlertDialog(
      title: Text(employee == null ? '添加员工' : '编辑员工'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 姓名输入框
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '姓名',
                  hintText: '请输入员工姓名',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入员工姓名';
                  }
                  return null;
                },
              ),
              Gap(pt(16)),
              // 手机号输入框
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: '手机号',
                  hintText: '请输入手机号',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入手机号';
                  }
                  if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value.trim())) {
                    return '请输入正确的手机号';
                  }
                  return null;
                },
              ),
              Gap(pt(16)),
              // 角色选择
              DropdownButtonFormField<EmployeeRole>(
                value: selectedRole.value,
                decoration: const InputDecoration(
                  labelText: '角色',
                  border: OutlineInputBorder(),
                ),
                items: EmployeeRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedRole.value = value;
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return '请选择角色';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final request = EmployeeEditRequest(
                uuid: employee?.uuid ?? '',
                username: nameController.text.trim(),
                phone: phoneController.text.trim(),
                roles: [selectedRole.value],
              );
              onSave(request);
              Navigator.pop(context);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
