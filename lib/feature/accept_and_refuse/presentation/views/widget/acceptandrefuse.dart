import 'package:flutter/material.dart';
import '../../../../../core/color/colors.dart';
import '../../../../../core/widget/custom_button_invtaion.dart';
import '../../../../../core/widget/loading_button.dart';
import '../../constants/accept_refuse_constants.dart';

class AcceptAndRefuse extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onRefuse;
  final bool isLoading;

  const AcceptAndRefuse({
    super.key,
    required this.onAccept,
    required this.onRefuse,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: LoadingButton(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// Accept button
        CustomButtonInvtaion(
          text: AcceptRefuseConstants.acceptButtonText,
          color: AppColors.bIcon,
          onTap: onAccept,
        ),

        /// Refuse button
        CustomButtonInvtaion(
          text: AcceptRefuseConstants.refuseButtonText,
          color: AppColors.red,
          onTap: onRefuse,
        ),
      ],
    );
  }
}