import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/base/btn.dart';

/// 联系人信息编辑对话框
class ContactEditDialog extends StatefulWidget {
  final String initialContactName;
  final String initialContactPhone;
  final Function(String contactName, String contactPhone) onSave;

  const ContactEditDialog({
    Key? key,
    required this.initialContactName,
    required this.initialContactPhone,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ContactEditDialog> createState() => _ContactEditDialogState();
}

class _ContactEditDialogState extends State<ContactEditDialog> {
  late TextEditingController _contactNameController;
  late TextEditingController _contactPhoneController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _contactNameController =
        TextEditingController(text: widget.initialContactName);
    _contactPhoneController =
        TextEditingController(text: widget.initialContactPhone);
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(pt(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(pt(12)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '编辑联系人信息',
                style: TextStyle(
                  fontSize: pt(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Gap(pt(20)),
              Text(
                '联系人姓名',
                style: TextStyle(
                  fontSize: pt(14),
                  color: Colors.grey[700],
                ),
              ),
              Gap(pt(8)),
              TextFormField(
                controller: _contactNameController,
                decoration: InputDecoration(
                  hintText: '请输入联系人姓名',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(pt(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: pt(12),
                    vertical: pt(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入联系人姓名';
                  }
                  if (value.trim().length < 2) {
                    return '联系人姓名至少2个字符';
                  }
                  return null;
                },
              ),
              Gap(pt(16)),
              Text(
                '联系电话',
                style: TextStyle(
                  fontSize: pt(14),
                  color: Colors.grey[700],
                ),
              ),
              Gap(pt(8)),
              TextFormField(
                controller: _contactPhoneController,
                decoration: InputDecoration(
                  hintText: '请输入联系电话',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(pt(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: pt(12),
                    vertical: pt(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入联系电话';
                  }
                  if (!RegExp(r'^\d{11}$').hasMatch(value.trim())) {
                    return '请输入正确的手机号码';
                  }
                  return null;
                },
              ),
              Gap(pt(24)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(pt(40)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(pt(8)),
                        ),
                      ),
                      child: const Text('取消'),
                    ),
                  ),
                  Gap(pt(12)),
                  Expanded(
                    child: SportsBtn(
                      text: '保存',
                      height: pt(40),
                      btnLoading: _isLoading,
                      tapHandle: _handleSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSave(
        _contactNameController.text.trim(),
        _contactPhoneController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // 错误处理已在外部处理
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

/// 显示联系人信息编辑对话框
void showContactEditDialog({
  required BuildContext context,
  required String initialContactName,
  required String initialContactPhone,
  required Function(String contactName, String contactPhone) onSave,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ContactEditDialog(
      initialContactName: initialContactName,
      initialContactPhone: initialContactPhone,
      onSave: onSave,
    ),
  );
}
