import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.obscureText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: widget.controller, // widget. is how the State classes access the variables defined in the parent class
          keyboardType: widget.keyboardType,
          obscureText: isPassword && _isObscured,
          readOnly: widget.readOnly,
          maxLines: isPassword ? 1 : widget.maxLines,
          validator: widget.validator,
          onChanged: widget.onChanged,

          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    size: 19,
                    color: AppColors.textSecondary,
                  )
                : null,

            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 19,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
