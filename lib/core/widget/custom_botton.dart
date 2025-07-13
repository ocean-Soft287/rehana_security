import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color/colors.dart';

class CustomBotton extends StatelessWidget {
  const CustomBotton({super.key, required this.text, this.onTap});
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.30,
      height: 48.h,
      decoration: BoxDecoration(
          color: AppColors.circlecolor,
          borderRadius: BorderRadius.circular(18.r)),
      child: GestureDetector(
      onTap: onTap,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.white,
              fontSize: MediaQuery.of(context).size.width < 800 ? 14.sp : 18.sp,
              fontWeight: FontWeight.w400,
              fontFamily: "Alexandria"
            ),
          ),
        ),
      ),
    ),

    );
  }
}
