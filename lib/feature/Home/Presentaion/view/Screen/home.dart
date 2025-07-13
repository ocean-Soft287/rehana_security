import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/color/colors.dart';
import '../../../../../core/network/local/flutter_secure_storage.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../conectivitiy/manger/internet_cubit.dart';
import '../../../../qrcode/scan_qr_screen.dart';
import '../widget/home_contaner.dart';
import '../widget/rehana_home_appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> chooseFrom = [
      "دخول",
      "خروج",
      "تسجيل دعوة يدوي",
      "تسجيل خروج",
    ];
    return BlocProvider(
      create: (context) => InternetBloc()..add(InternetChecked()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: AppColors.bIcon,
              elevation: 0,
              centerTitle: true,
            ),
          ),
          body: SafeArea(
            child: CustomScrollView(
              key: const Key('custom_scroll_view'),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 150.h,
                      minWidth: double.infinity,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bIcon,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                      ),
                    ),
                    child: const RehanaHome(),
                  ),

                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.sp,
                        horizontal: 12.sp,
                      ),
                      child: HomeContaner(
                        name: chooseFrom[index],
                        onTap: () {
                          if (index == 0 || index == 1) {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ScanQrScreen(
                                      name: index == 0 ? 'دخول' : 'خروج',
                                    ),
                              ),);

                          } else if (index == 2) {

                            context.push(AppRouter.oneTimeInvitation);
                          } else if (index == 3) {

                            context.push(AppRouter.kLoginview);

                          } else if (index == 4) {


                          } else if (index == 5) {

                            context.push(AppRouter.kLoginview);
                            SecureStorageService.deleteAll();

                          }
                        },
                      ),
                    ),
                    childCount: chooseFrom.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
