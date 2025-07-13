import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rehana_security/core/images/font.dart';

import '../color/colors.dart';

class CustomButtonInvtaion extends StatelessWidget {
  const CustomButtonInvtaion({super.key, required this.text, this.onTap, this.color});
  final String text;
  final void Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115.w,
      height: 39.h,
      decoration: BoxDecoration(
          color:color ?? AppColors.circlecolor,
          borderRadius: BorderRadius.circular(20)

      ),
      child:
      GestureDetector(
          onTap: onTap,
          child: Center(child: Text(text,style: TextStyle(color: AppColors.white,fontSize: 14,fontWeight: FontWeight.w400,fontFamily:Font.alex),))),
    );
  }
}
