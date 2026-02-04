import 'package:todo/core/utils/extension.dart';
import 'package:todo/presentation/theme/text_theme.dart';
import 'package:todo/presentation/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final bool readOnly;
  final bool obscureText;
  final String? initialValue;
  final String? title;
  final String? hintText;
  final int? maxLine;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;

  const InputField({
    super.key,
    this.readOnly = false,
    this.obscureText = false,
    this.initialValue,
    this.title,
    this.hintText,
    this.maxLine = 1,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(widget.title!, style: AppTextTheme.body.greyDark),
          vSpace6,
        ],
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: widget.initialValue,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLine,
          decoration: InputDecoration(
            hintText: widget.hintText ?? widget.title,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
          inputFormatters:
              widget.inputFormatters ?? [LengthLimitingTextInputFormatter(100)],
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: widget.onChanged,
          validator: widget.validator,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
      ],
    );
  }
}
