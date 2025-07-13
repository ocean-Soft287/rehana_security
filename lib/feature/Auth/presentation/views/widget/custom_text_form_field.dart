import 'package:flutter/material.dart';

import '../../../../../core/color/colors.dart';

class Customtextformfield extends StatelessWidget {
  const Customtextformfield({
    super.key,
    required this.hinttext,
    required this.controller,
    this.obesurepass = false,
    required this.validator, 
    this.prefixIcon, 
    this.keyboardType, 
    this.suffixIcon, 
  });

  final String hinttext;
  final TextEditingController controller;
  final bool obesurepass;
  final String? Function(String?)? validator;
  final Widget? prefixIcon; // Added as optional
  final Widget? suffixIcon; // Added as optional
  final TextInputType? keyboardType; // Make keyboardType nullable

  @override
  Widget build(BuildContext context) {


        return TextFormField(
          controller: controller,
          obscureText: obesurepass,
          keyboardType: keyboardType,
          validator: validator,

          decoration: InputDecoration(
            hintText: hinttext,
             hintStyle: TextStyle(color: AppColors.white,fontFamily: "Alexandria"), // Directly pass the font TextStyle
            filled: true,
            fillColor:AppColors.bIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color(0xff2970FF).withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: const Color(0xff2970FF).withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xff2970FF),
                width: 1.0,
              ),
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