import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehana_security/core/images/font.dart';

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/images.dart';
import '../../manger/securityonetime_cubit.dart';

class Picturewidget extends StatelessWidget {
  const Picturewidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "صوره",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: Font.alex,
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocConsumer<SecurityonetimeCubit, SecurityonetimeState>(
                    listener: (context, state) {
                      // يمكن إضافة Snackbar مثلاً لو فيه خطأ
                    },
                    builder: (context, state) {
                      final invitationCubit = context.read<SecurityonetimeCubit>();
                      final picked = invitationCubit.imageEditProfilePhoto;

                      return GestureDetector(
                        onTap: () {
                          invitationCubit.getProfileImageByGallery();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 146,
                          height: 132,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.black),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: picked != null
                                ? Image.file(
                              File(picked.path),
                              width: 146,
                              height: 132,
                              fit: BoxFit.contain,
                            )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Imagesassets.photo,
                                  width: 18,
                                  height: 18,
                                ),
                                const SizedBox(height: 21),
                                Text(
                                  "اضف صوره",
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: Font.alex,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
      ],
    );
  }
}