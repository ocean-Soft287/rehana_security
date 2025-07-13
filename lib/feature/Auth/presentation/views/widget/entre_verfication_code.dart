import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/color/colors.dart';

class EntreVerficationCode extends StatelessWidget {
  const EntreVerficationCode({super.key});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: 150.h),
        Text(
          "أدخل رمز التحقق",
          style: TextStyle(
              color: AppColors.black,
              fontSize: width<800?24.sp:12.sp,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 29.h),
      ],
    );
  }
}
