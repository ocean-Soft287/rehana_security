import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';

/// عنوان فوق كل حقل فى صفحة تسجيل دعوة يدوى
class FieldLabel extends StatelessWidget {
  const FieldLabel({super.key, required this.text, this.isRequired = false});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              fontFamily: Font.alex,
              color: AppColors.black,
            ),
          ),
          if (isRequired)
            Text(
              ' *',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontFamily: Font.alex,
                color: AppColors.red,
              ),
            ),
        ],
      ),
    );
  }
}

/// حقل نصى بنفس ستايل الصفحة
class ManualInvitationField extends StatelessWidget {
  const ManualInvitationField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(fontSize: 14.sp, fontFamily: Font.alex),
      decoration: manualInvitationDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

InputDecoration manualInvitationDecoration({
  required String hintText,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: AppColors.circlecolor,
      fontFamily: Font.alex,
      fontSize: 13.sp,
    ),
    filled: true,
    fillColor: AppColors.white,
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.bIcon, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.red, width: 1.5),
    ),
    errorStyle: TextStyle(fontFamily: Font.alex, fontSize: 12.sp),
  );
}
