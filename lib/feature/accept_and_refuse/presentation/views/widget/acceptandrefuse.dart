import 'package:flutter/material.dart';
import '../../../../../core/color/colors.dart';
import '../../../../../core/widget/custom_button_invtaion.dart';

class AcceptAndRefuse extends StatelessWidget {
  /// هنديك Callbacks جاهزة من بره الويدجت
  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  const AcceptAndRefuse({
    super.key,
    required this.onAccept,
    required this.onRefuse,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// زر قبول
        CustomButtonInvtaion(
          text: 'قبول',
          color: AppColors.bIcon,
          onTap: onAccept,
        ),

        /// زر رفض
        CustomButtonInvtaion(
          text: 'رفض',
          color: AppColors.red,
          onTap: onRefuse,
        ),
      ],
    );
  }
}






///رفض
///context.go(AppRouter.home);