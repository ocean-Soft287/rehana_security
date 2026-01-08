import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:rehana_security/core/router/app_router.dart';
import 'package:rehana_security/core/widget/context_show.dart';
import 'package:rehana_security/core/widget/loading_button.dart';
import 'package:rehana_security/feature/Auth/presentation/Manger/auth_cubit.dart';
import 'package:rehana_security/core/widget/custom_botton.dart';
import 'package:rehana_security/feature/Auth/presentation/views/widget/custom_text_form_field.dart';
import '../../../../core/color/colors.dart';
import '../../../../core/images/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<bool> tazakarni = ValueNotifier<bool>(false);
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<AuthCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image(
                      image: const AssetImage("assets/images/logo.png"),
                      height: 161.h,
                      width: 122.w,
                    ),
                  ),
                  SizedBox(height: 29.h),
                  const Text(
                    "تسجيل دخول",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Alexandria",
                    ),
                  ),
                  SizedBox(height: 48.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      hintText: 'الايميل',
                      controller: email,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "يرجى إدخال اسم المستخدم";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "يرجى إدخال بريد إلكتروني صالح";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 48.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      hintText: 'كلمة المرور',
                      controller: password,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "يرجى إدخال كلمة المرور";
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: tazakarni,
                        builder: (context, value, child) {
                          return InkWell(
                            onTap: () {
                              tazakarni.value = !tazakarni.value;
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  value
                                      ? Imagesassets.correctgreen
                                      : Imagesassets.correctwhite,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "تذكرني",
                                  style: TextStyle(
                                    fontFamily: "Alexandria",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 34.h),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          context.showSuccessMessage("تم تسجيل الدخول بنجاح");
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.push(AppRouter.home);
                          });
                        } else if (state is AuthFailure) {
                          context.showErrorMessage(state.message);
                        }
                      },
                      builder: (context, state) {
                        AuthCubit auth = context.read<AuthCubit>();
                        if (state is AuthLoading) {
                          return LoadingButton();
                        } else {
                          return CustomBotton(
                            text: "تسجيل دخول",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                auth.login(
                                  email: email.text,
                                  password: password.text,
                                  remberme: tazakarni.value,
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    tazakarni.dispose();
    super.dispose();
  }
}
