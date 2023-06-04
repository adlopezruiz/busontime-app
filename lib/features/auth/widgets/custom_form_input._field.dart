import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.focusNode,
    required this.onSaved,
    required this.validator,
    required this.labelText,
    required this.prefixIcon,
    this.obscuredText,
    this.trailing,
    this.textCapitalization,
  });
  final FocusNode focusNode;
  final void Function(String?) onSaved;
  final String? Function(String?) validator;
  final String labelText;
  final IconData prefixIcon;
  final bool? obscuredText;
  final Widget? trailing;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showEye = false;

  @override
  void initState() {
    if (widget.obscuredText ?? false) {
      showEye = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      controller: widget.controller,
      obscureText: showEye,
      cursorColor: AppColors.primaryGreen,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryGreen,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        filled: true,
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: widget.focusNode.hasFocus ? AppColors.primaryGreen : null,
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: widget.focusNode.hasFocus ? AppColors.primaryGreen : null,
        ),
        suffixIcon: widget.obscuredText ?? false
            ? IconButton(
                color: AppColors.primaryGreen,
                onPressed: () {
                  setState(() => showEye = !showEye);
                },
                icon: Icon(
                  showEye
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              )
            : null,
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
