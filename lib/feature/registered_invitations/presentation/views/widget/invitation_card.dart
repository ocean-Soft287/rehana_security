import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';
import '../../../../../core/widget/loading_button.dart';
import '../../../data/model/registered_invitation_model.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    super.key,
    required this.invitation,
    this.onEnd,
    this.isEnding = false,
    this.isEndDisabled = false,
  });

  final RegisteredInvitationModel invitation;

  /// null يعنى الكارت فى تاب الدعاوى المنتهية (بدون زر إنهاء)
  final VoidCallback? onEnd;
  final bool isEnding;
  final bool isEndDisabled;

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '—';
    return DateFormat(
      'yyyy/MM/dd - hh:mm a',
    ).format(dateTime).replaceAll('AM', 'ص').replaceAll('PM', 'م');
  }

  @override
  Widget build(BuildContext context) {
    final isActive = invitation.isActive;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.home_outlined, size: 20.r, color: AppColors.bIcon),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'فيلا ${_valueOrDash(invitation.villaNumber)}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: Font.alex,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusChip(isActive: isActive),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1, color: AppColors.grey),
          ),

          _InfoRow(
            icon: Icons.person_outline,
            label: 'اسم الزائر',
            value: _valueOrDash(invitation.visitorName),
          ),
          if (invitation.memberName.isNotEmpty)
            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'اسم العضو',
              value: invitation.memberName,
            ),
          _InfoRow(
            icon: Icons.directions_car_outlined,
            label: 'رقم العربية',
            value: _valueOrDash(invitation.carPlateNumber),
          ),
          _InfoRow(
            icon: Icons.access_time,
            label: 'توقيت الزيارة',
            value: formatDateTime(invitation.visitTime),
          ),
          _InfoRow(
            icon: Icons.event_note_outlined,
            label: 'تاريخ التسجيل',
            value: formatDateTime(invitation.createdAt),
          ),
          if (invitation.endedAt != null)
            _InfoRow(
              icon: Icons.event_busy_outlined,
              label: 'تاريخ الإنهاء',
              value: formatDateTime(invitation.endedAt),
            ),
          if (invitation.notes.isNotEmpty)
            _InfoRow(
              icon: Icons.sticky_note_2_outlined,
              label: 'ملاحظات',
              value: invitation.notes,
            ),

          if (onEnd != null) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.red,
                  disabledBackgroundColor: AppColors.red.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: (isEnding || isEndDisabled) ? null : onEnd,
                icon:
                    isEnding
                        ? const SizedBox.shrink()
                        : Icon(
                          Icons.block,
                          size: 18.r,
                          color: AppColors.white,
                        ),
                label:
                    isEnding
                        ? SizedBox(
                          height: 24.h,
                          child: const FittedBox(
                            child: LoadingButton(color: AppColors.white),
                          ),
                        )
                        : Text(
                          'إنهاء الدعوة',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: Font.alex,
                            color: AppColors.white,
                          ),
                        ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _valueOrDash(String value) => value.trim().isEmpty ? '—' : value;
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.green : AppColors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        isActive ? 'نشطة' : 'منتهية',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          fontFamily: Font.alex,
          color: color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17.r, color: AppColors.circlecolor),
          SizedBox(width: 6.w),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: Font.alex,
              color: AppColors.circlecolor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                fontFamily: Font.alex,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
