import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../../core/color/colors.dart';
import '../../../../Auth/presentation/views/widget/custom_appbar.dart';
import '../../manger/securityonetime_cubit.dart';
import 'one_time_invitation.dart';

class InvtaionUser extends StatelessWidget {
  const InvtaionUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>GetIt.instance<SecurityonetimeCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: AppBar(
            backgroundColor: AppColors.bIcon,
            elevation: 0,
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            leading: CustomAppbar(),
            title: Text(
              "تسجيل دعوة",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontFamily: "Alexandria"),
            ),
          ),
        ),

        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: OneTimeInvitation(),)


          ],
        ),
      ),
    );
  }
}
