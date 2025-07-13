import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/images.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return          SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        height:50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.bIcon,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)


            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: (){
                    context.pop();
                  },
                  child: Image.asset(Imagesassets.arrow)),
              Expanded(
                child: Center(
                  child: Text(
                    "invitation",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Alexandria",
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
