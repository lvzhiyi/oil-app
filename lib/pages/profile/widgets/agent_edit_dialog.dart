import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/global/model/agent_info_type.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/base/btn.dart';
import 'package:lottery_app/widgets/popup/toast.dart';

/// 显示代理商信息编辑对话框
void showAgentEditDialog({
  required BuildContext context,
  required AgentInfo agentInfo,
  required Future<void> Function(String contactName, String phone) onSave,
}) {
  showDialog(
    context: context,
    builder: (context) => AgentEditDialog(
      agentInfo: agentInfo,
      onSave: onSave,
    ),
  );
}

class AgentEditDialog extends StatefulWidget {
  /// 代理商信息
  final AgentInfo agentInfo;
  
  /// 保存回调
  final Future<void> Function(String contactName, String phone) onSave;

  const AgentEditDialog({
    Key? key,
    required this.agentInfo,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AgentEditDialog> createState() => _AgentEditDialogState();
}

class _AgentEditDialogState extends State<AgentEditDialog> {
  late TextEditingController _contactNameController;
  late TextEditingController _phoneController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _contactNameController = TextEditingController(text: widget.agentInfo.contactName);
    _phoneController = TextEditingController(text: widget.agentInfo.phone);
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(pt(16)),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(pt(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '编辑代理商信息',
              style: SportsTextStyle.baseBold.copyWith(
                fontSize: pt(18),
                color: AppColors.textPrimary,
              ),
            ),
            Gap(pt(24)),
            _buildInputField('联系人', _contactNameController, true),
            Gap(pt(16)),
            _buildInputField('联系电话', _phoneController, true),
            Gap(pt(32)),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: pt(44),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: AppColors.textSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(pt(8)),
                        ),
                      ),
                      child: Text(
                        '取消',
                        style: SportsTextStyle.baseNormal.copyWith(
                          fontSize: pt(14),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(pt(12)),
                Expanded(
                  child: SportsBtn(
                    text: '保存',
                    width: double.infinity,
                    height: pt(44),
                    btnLoading: _isLoading,
                    tapHandle: _handleSave,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建输入框
  Widget _buildInputField(String label, TextEditingController controller, bool? enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: SportsTextStyle.baseNormal.copyWith(
            fontSize: pt(14),
            color: AppColors.textPrimary,
          ),
        ),
        Gap(pt(8)),
        TextField(
          enabled: enabled ?? true,
          controller: controller,
          style: SportsTextStyle.baseNormal.copyWith(
            fontSize: pt(14),
            color: enabled ?? true ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          decoration: InputDecoration(
            hintText: '请输入$label',
            hintStyle: SportsTextStyle.baseNormal.copyWith(
              fontSize: pt(14),
              color: enabled ?? true ? AppColors.textSecondary : AppColors.textGray2,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(pt(8)),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: pt(1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(pt(8)),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: pt(1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(pt(8)),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: pt(1),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: pt(12),
              vertical: pt(12),
            ),
          ),
        ),
      ],
    );
  }

  /// 处理保存
  Future<void> _handleSave() async {
    final contactName = _contactNameController.text.trim();
    final phone = _phoneController.text.trim();

    if (contactName.isEmpty) {
      _showErrorSnackBar('请输入联系人');
      return;
    }

    if (phone.isEmpty) {
      _showErrorSnackBar('请输入联系电话');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSave(contactName, phone);
      if (mounted) {
        Navigator.of(context).pop();
        SportsToast.showSuccess('保存成功');
      }
    } catch (e) {
      SportsToast.showError('保存失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 显示错误提示
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
