import 'package:flutter/material.dart';

import '../../../../../core/color/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscurePass = false,
    required this.validator,
    this.prefixIcon,
    this.keyboardType,
    this.suffixIcon,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obscurePass;
  final String? Function(String?)? validator;
  final Widget? prefixIcon; // Added as optional
  final Widget? suffixIcon; // Added as optional
  final TextInputType? keyboardType; // Make keyboardType nullable

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscurePass,
      keyboardType: keyboardType,
      validator: validator,

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.white, fontFamily: "Alexandria"),
        // Directly pass the font TextStyle
        filled: true,
        fillColor: AppColors.bIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.blue2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.blue3, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
