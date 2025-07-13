import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/color/colors.dart';

class Iftextotp extends StatelessWidget {
  const Iftextotp({super.key});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Column(

      children: [
        SizedBox(height: 20.h),
        Row(
          children: [
            Text(
              "إذا لم تتلق رمزًا ",
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: width<800?12.sp:6.sp,
                  fontWeight: FontWeight.w600),
            ),
            InkWell(
              onTap: () {


              },
              child: FittedBox(
               fit: BoxFit.scaleDown,
                child: Text(
                  "إعادة الإرسال",
                  style: TextStyle(
                      color: AppColors.bIcon,
                      fontSize: width<800?12.sp:6.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 48.h),
      ],
    );
  }
}
