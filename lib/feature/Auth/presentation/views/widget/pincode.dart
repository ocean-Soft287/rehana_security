import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/color/colors.dart';

class Pincodeform extends StatefulWidget {
  const Pincodeform({super.key, required this.controller, required this.currentOtp});

  final TextEditingController controller;
  final String currentOtp;

  @override
  State<Pincodeform> createState() => _PincodeformState();
}

class _PincodeformState extends State<Pincodeform> {
  late String currentOtp; // تعريف متغير لحفظ الـ OTP

  @override
  void initState() {
    super.initState();
    currentOtp = widget.currentOtp; // تهيئة المتغير
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      keyboardType: TextInputType.number,
      controller: widget.controller,
      onChanged: (value) {
        setState(() {
          currentOtp = value; // تحديث المتغير عند الإدخال
        });
      },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        borderWidth: 1.5,
        inactiveFillColor: AppColors.white,
        activeFillColor: AppColors.white,
        selectedFillColor: AppColors.white,
        inactiveColor: Colors.grey,
        activeColor: AppColors.circlecolor,
        selectedColor: AppColors.black,
        fieldHeight: 50,
        fieldWidth: 50,
      ),
      textStyle: TextStyle(
        color: AppColors.bIcon,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
