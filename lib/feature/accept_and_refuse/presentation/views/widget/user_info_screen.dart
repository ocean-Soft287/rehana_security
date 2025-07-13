import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rehana_security/core/images/font.dart';

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/images.dart';
import '../../../data/model/guest_model.dart';
import 'acceptandrefuse.dart';
import 'exitonly.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({
    super.key,
    required this.guestInvitationModel,
    required this.name,
    required this.onexit,
    required this.onaccept,
    required this.onexitentre,
  });
  final GuestInvitationModel guestInvitationModel;
  final String name;
  final void Function() onexit;
  final void Function() onaccept;
  final void Function() onexitentre;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final contentWidth =
            screenWidth > 600 ? 0.5 * screenWidth : 0.9 * screenWidth;

        /// ❶ كون الـ URL صح من الـ picture
        final String? picture = guestInvitationModel.picture;
        final String fullImageUrl =
            picture != null && picture.isNotEmpty
                ? 'http://78.89.159.126:9393/TheOneAPIRehana//Images/Guests/ab0e1d7b-e3d5-4805-8dc8-ab46ab2bf793-scaled_1000343469.jpg'
                : '';

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: contentWidth,
            child: Column(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 120.r,
                    height: 120.r,
                    child:
                        (picture != null && picture.isNotEmpty)
                            ? CachedNetworkImage(
                              imageUrl: fullImageUrl,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, progress) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget:
                                  (context, url, error) => Image.asset(
                                    Imagesassets.personprofile,
                                    fit: BoxFit.cover,
                                  ),
                            )
                            : Image.asset(
                              Imagesassets.personprofile,
                              fit: BoxFit.cover,
                            ),
                  ),
                ),

                const SizedBox(height: 16),

                /// بيانات الزائر
                userInfoRow("الاسم", guestInvitationModel.guestName, context),
                userInfoRow("الحالة", guestInvitationModel.status, context),
                userInfoRow("نوع الدعوه", guestInvitationModel.type, context),
                userInfoRow(
                  "من",
                  guestInvitationModel.dateFrom.toString(),
                  context,
                ),
                userInfoRow(
                  "إلى",
                  guestInvitationModel.dateTo.toString(),
                  context,
                ),
                const SizedBox(height: 40),
                if (name == 'خروج')
                  Exitonly(onTap: onexit)
                else
                  AcceptAndRefuse(onAccept: onaccept, onRefuse: onexit),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget userInfoRow(String title, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 30.sp),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                fontFamily: Font.alex,
              ),
            ),
          ),
          SizedBox(width: 0.2 * MediaQuery.of(context).size.width),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  fontFamily: Font.alex,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
