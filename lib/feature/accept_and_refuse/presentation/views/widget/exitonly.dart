import 'package:flutter/material.dart';

import '../../../../../core/widget/custom_button_invtaion.dart';

class Exitonly extends StatelessWidget {
  const Exitonly({super.key, required this.onTap, });
final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return           Row(
      children: [
        Spacer(),  Align(
          alignment: Alignment.bottomCenter,
          child: CustomButtonInvtaion(
            text: "خروج",
            onTap: onTap,
          ),
        ),
        Spacer(),
      ],
    );
  }
}
