import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';

class InvtaionTextformfield extends StatelessWidget {
  const InvtaionTextformfield({
    super.key,
    required this.name,
    required this.controller,
    this.validator,
    this.inputFormatters,


  });

  final String name;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(       fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: Font.alex,
            color: AppColors.black,),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator ??
                  (value) {
                if (value == null || value.isEmpty) {
                  return 'please Enter Name';
                }
                return null;
              },
          inputFormatters: inputFormatters,

          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.bIcon),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.bIcon),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.bIcon, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}