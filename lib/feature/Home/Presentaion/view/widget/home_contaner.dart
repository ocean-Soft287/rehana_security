import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/color/colors.dart';
import '../../../../conectivitiy/manger/internet_cubit.dart';

class HomeContaner extends StatelessWidget {
  const HomeContaner({super.key, required this.name, required this.onTap});
  final String name;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetState>(
      builder: (context, state) {
        return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth * 0.90,
          height:constraints.minWidth<800? 70.h:100.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.bIcon),
          ),
          child: InkWell(
            onTap:  (name == "العمل بدون اتصال")?(){

              context.read<InternetBloc>().add(InternetManuallyDisconnected());

          } :onTap,
            child: Padding(
              padding: EdgeInsets.all(8.r), // Padding متجاوب
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontSize: constraints.minWidth<600? 18.sp:15.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (name == "العمل بدون اتصال")
                    BlocBuilder<InternetBloc, InternetState>(
      builder: (context, state) {
        if(state is InternetConnectedState)
    {
    }
        else{

        }
        return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: state is InternetConnectedState    ? Colors.green
                              : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
      },
    ),

                ],
              ),
            ),
          ),
        );
      },
    );
      },
    );
  }
}