import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';
import '../../../../../core/images/images.dart';
import '../../../../../core/widget/custom_botton.dart';
import '../../../../Home/Presentaion/view/Screen/home.dart';

class PasswordChanged extends StatelessWidget {
  const PasswordChanged({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.center,
              child: Image.asset(Imagesassets.rightphoto)),
          SizedBox(
            height: 20.r,
          ),
          Text(message,
              style: TextStyle(
                  fontSize:MediaQuery.of(context).size.width < 900 ?14.sp:10.sp,
                  color: AppColors.black,
                  fontFamily: Font.alex,
                  fontWeight: FontWeight.w700)),
          SizedBox(
            height:80,
          ),
          CustomBotton(
            text: "حسناً",
            onTap: () {
             Navigator.push(context, MaterialPageRoute(builder:(context)=> Home()));
            },
          )
        ],
      ),
    );
  }
}