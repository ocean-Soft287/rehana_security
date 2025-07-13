import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/color/colors.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.pop();
      },
      child: Icon(
        Icons.arrow_back_ios_new, size: 20, color: AppColors.black),
    );
  }
}
