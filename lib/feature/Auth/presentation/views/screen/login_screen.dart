import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/color/colors.dart';
import '../../../../../core/images/images.dart';
import '../../../../../core/router/app_router.dart';
import '../widget/custom_appbar.dart';
import '../../../../../core/widget/custom_botton.dart';
import '../widget/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    final formkey = GlobalKey<FormState>();
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: CustomAppbar()),
      body: Center(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Imagesassets.logoapp,
                    height: 161.h,
                    width: 122.w,
                  ),
                  SizedBox(
                    height: 29.h,
                  ),
                  Text(
                    "Log In",
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 48.h),
                  Container(
                      padding: EdgeInsets.all(20.0.r),
                      child: Customtextformfield(
                        hinttext: 'User name',
                        controller: email,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "please Enter your user name";
                          }
                          return null;
                        },
                      )),
                  Container(

                      padding: EdgeInsets.all(20),
                      child: Customtextformfield(
                        hinttext: 'Password',
                        controller: password,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "please Enter your password";
                          }
                          return null;
                        },
                      )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.0.r),
                        child: InkWell(
                          onTap: () {
                            context.push(AppRouter.kforgetView);
                          },
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(color: AppColors.black,fontFamily:"Alexandria",fontWeight: FontWeight.w400,fontSize:width<600?12.sp:6.sp ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 34,
                  ),
                  Row(
                    children: [
                      Spacer(),  Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomBotton(
                          text: "Log In",
                          onTap: () {
                            // if (formkey.currentState!.validate()) {}

                          },
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 150.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
