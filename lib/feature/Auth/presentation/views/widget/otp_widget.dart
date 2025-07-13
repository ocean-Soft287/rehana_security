import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({super.key, required this.controller}); // Store the controller

  final TextEditingController controller; // Add this field to store the controller

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 55,
      child: TextFormField(
        controller: controller, // Assign the controller to the TextFormField
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFD0D0D0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFD0D0D0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFD0D0D0)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}