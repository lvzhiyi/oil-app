import 'package:flutter/material.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:gap/gap.dart';

/// 带标签的输入框
class LabeledInput extends StatefulWidget {
  /// 标签
  final String label;

  /// 提示语
  final String hintText;

  /// 控制器
  final TextEditingController? controller;

  /// 初始值（与controller二选一）
  final String? value;

  /// 键盘类型
  final TextInputType? keyboardType;

  /// 是否密文
  final bool obscureText;

  /// 是否可输入
  final bool enabled;

  /// 校验
  final String? Function(String?)? validator;

  /// 变更回调（仅在无controller时使用内部controller转发）
  final void Function(String)? onChanged;

  /// 最大长度
  final int? maxLength;

  const LabeledInput({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.value,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.maxLength,
  });

  @override
  State<LabeledInput> createState() => _LabeledInputState();
}

class _LabeledInputState extends State<LabeledInput> {
  TextEditingController? _internalController;
  late TextEditingController _controller;
  late bool _usingInternal;

  @override
  void initState() {
    super.initState();
    _usingInternal = widget.controller == null;
    if (_usingInternal) {
      _internalController = TextEditingController(text: widget.value ?? '');
      _controller = _internalController!;
    } else {
      _controller = widget.controller!;
    }
  }

  @override
  void didUpdateWidget(covariant LabeledInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool nextUsingInternal = widget.controller == null;

    // 控制器来源发生变化时，切换为对应控制器
    if (_usingInternal != nextUsingInternal) {
      if (_usingInternal) {
        _internalController?.dispose();
        _internalController = null;
      }
      _usingInternal = nextUsingInternal;
      if (_usingInternal) {
        _internalController = TextEditingController(text: widget.value ?? '');
        _controller = _internalController!;
      } else {
        _controller = widget.controller!;
      }
    }

    // 仍然使用内部控制器时，同步外部传入的值变更
    if (_usingInternal) {
      final String nextText = widget.value ?? '';
      if (_controller.text != nextText) {
        final TextSelection selection = _controller.selection;
        _controller.value = TextEditingValue(
          text: nextText,
          selection: selection,
          composing: TextRange.empty,
        );
      }
    }
  }

  @override
  void dispose() {
    if (_usingInternal) {
      _internalController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: SportsTextStyle.baseNormal.copyWith(
            fontSize: pt(14),
            color: AppColors.textSecondary,
          ),
        ),
        Gap(pt(8)),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: SportsTextStyle.grayNormal.copyWith(
              fontSize: pt(14),
            ),
            filled: true,
            fillColor: widget.enabled
                ? const Color(0xFFF8FAFF)
                : const Color(0xFFE5E5E5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(pt(12)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(pt(12)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(pt(12)),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(pt(12)),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(pt(12)),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: pt(16),
              vertical: pt(14),
            ),
          ),
          style: SportsTextStyle.baseNormal.copyWith(
            fontSize: pt(14),
            color: AppColors.textPrimary,
          ),
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          validator: widget.validator,
          onChanged: _usingInternal ? widget.onChanged : null,
          maxLength: widget.maxLength,
        ),
      ],
    );
  }
}
