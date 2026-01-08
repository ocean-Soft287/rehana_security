import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:rehana_security/core/images/font.dart';
import '../../../../../core/color/colors.dart';
import '../../../../../core/images/images.dart';
import '../../../data/model/guest_model.dart';
import '../../constants/accept_refuse_constants.dart';
import 'acceptandrefuse.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({
    super.key,
    required this.guestInvitationModel,
    required this.name,
    required this.onexit,
    required this.onaccept,
    required this.onexitentre,
    this.isLoading = false,
  });

  final GuestInvitationModel guestInvitationModel;
  final String name;
  final void Function() onexit;
  final void Function() onaccept;
  final void Function() onexitentre;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    String formatDateTime(DateTime dateTime) {
      return DateFormat('MM:dd:yyyy hh:mm a')
          .format(dateTime)
          .replaceAll('AM', AcceptRefuseConstants.amLabel)
          .replaceAll('PM', AcceptRefuseConstants.pmLabel);
    }

    final bool isExpired = guestInvitationModel.dateTo.isBefore(DateTime.now());
    final bool isExit = name == AcceptRefuseConstants.exitActionName;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final contentWidth = screenWidth > AcceptRefuseConstants.tabletBreakpoint
            ? AcceptRefuseConstants.tabletContentWidthRatio * screenWidth
            : AcceptRefuseConstants.mobileContentWidthRatio * screenWidth;

        final String picture = guestInvitationModel.picture;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: contentWidth,
            child: Column(
              children: [
                if (isExpired)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red.withAlpha(25),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.red),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: AppColors.red),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              AcceptRefuseConstants.expiryWarning,
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: Font.alex,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ClipOval(
                  child: SizedBox(
                    width: AcceptRefuseConstants.profileImageSize.r,
                    height: AcceptRefuseConstants.profileImageSize.r,
                    child: (picture.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: picture,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) =>
                                const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
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
                SizedBox(height: AcceptRefuseConstants.itemSpacing),

                /// Guest data
                userInfoRow(
                  AcceptRefuseConstants.labelName,
                  guestInvitationModel.guestName,
                  context,
                ),
                userInfoRow(
                  AcceptRefuseConstants.labelStatus,
                  guestInvitationModel.status,
                  context,
                ),
                userInfoRow(
                  AcceptRefuseConstants.labelType,
                  guestInvitationModel.type,
                  context,
                ),
                userInfoRow(
                  AcceptRefuseConstants.labelFrom,
                  formatDateTime(guestInvitationModel.dateFrom),
                  context,
                ),
                userInfoRow(
                  AcceptRefuseConstants.labelTo,
                  formatDateTime(guestInvitationModel.dateTo),
                  context,
                ),
                SizedBox(height: AcceptRefuseConstants.bottomSpacing),
                AcceptAndRefuse(
                  onAccept: onaccept,
                  onRefuse: onexit,
                  isLoading: isLoading,
                  isExit: isExit,
                ),
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
