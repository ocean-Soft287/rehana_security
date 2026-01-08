import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rehana_security/core/widget/loading_button.dart';

import '../../../../../core/color/colors.dart';

class CustomButtonInvtaion extends StatelessWidget {
  const CustomButtonInvtaion({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115.w,
      height: 39.h,
      decoration: BoxDecoration(
        color: AppColors.circlecolor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Center(
          child: isLoading
              ? const LoadingButton()
              : Text(
            text,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "Alexandria",
            ),
          ),
        ),
      ),
    );
  }
}
