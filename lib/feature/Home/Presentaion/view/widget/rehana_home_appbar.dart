import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehana_security/core/color/colors.dart';
import '../../../../../core/images/images.dart';
import '../../../../../core/network/local/flutter_secure_storage.dart';
import '../../../../conectivitiy/manger/internet_cubit.dart';

class RehanaHome extends StatelessWidget {
  const RehanaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetBloc, InternetState>(
      listener: (context, state) {},
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          bool isDesktop = screenWidth > 900;
          bool isTablet = screenWidth > 600 && screenWidth <= 900;

          return Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 20,
                  vertical: 20,
                ),
                color: AppColors.bIcon,
                child: Column(
                  children: [
                    // Centered Logo
                    Center(
                      child: Image.asset(
                        Imagesassets.logoapp,
                        height:
                            isDesktop
                                ? 100
                                : isTablet
                                ? 80
                                : 60,
                      ),
                    ),
                    SizedBox(height: 10),

                    // User Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Profile and Name
                        Row(
                          children: [
                            Image.asset(
                              Imagesassets.person,
                              width:
                                  isDesktop
                                      ? 60
                                      : isTablet
                                      ? 50
                                      : 40,
                              height:
                                  isDesktop
                                      ? 60
                                      : isTablet
                                      ? 50
                                      : 40,
                            ),
                            SizedBox(width: 10),
                            FutureBuilder<String?>(
                              future: SecureStorageService.read(
                                SecureStorageService.name,
                              ),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<dynamic> snapshot,
                              ) {
                                return Text(
                                  "الاسم : ${snapshot.data ?? '---'}",
                                  style: TextStyle(
                                    fontFamily: "Alexandria",
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        isDesktop
                                            ? 22
                                            : isTablet
                                            ? 18
                                            : 16,
                                    color: AppColors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        // Internet Status Indicator
                        // BlocBuilder<InternetBloc, InternetState>(
                        //   builder: (context, state) {
                        //     return GestureDetector(
                        //       onTap: () {
                        //         context.read<InternetBloc>().add(InternetManuallyDisconnected());
                        //       },
                        //       child: Container(
                        //         height: isDesktop ? 25 : 20,
                        //         width: isDesktop ? 25 : 20,
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           color: state is InternetConnectedState
                        //               ? Colors.green
                        //               : Colors.red,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
