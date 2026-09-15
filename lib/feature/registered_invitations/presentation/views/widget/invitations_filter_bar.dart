import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';

class InvitationsFilterBar extends StatelessWidget {
  const InvitationsFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.fromDate,
    required this.toDate,
    required this.onPickFromDate,
    required this.onPickToDate,
    required this.onClearFilters,
    required this.hasFilters,
    required this.totalItems,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final DateTime? fromDate;
  final DateTime? toDate;
  final VoidCallback onPickFromDate;
  final VoidCallback onPickToDate;
  final VoidCallback onClearFilters;
  final bool hasFilters;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            textInputAction: TextInputAction.search,
            style: TextStyle(fontSize: 14.sp, fontFamily: Font.alex),
            decoration: InputDecoration(
              hintText: 'ابحث باسم العضو',
              hintStyle: TextStyle(
                color: AppColors.circlecolor,
                fontFamily: Font.alex,
                fontSize: 13.sp,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.circlecolor,
                size: 20.r,
              ),
              suffixIcon:
                  searchController.text.isEmpty
                      ? null
                      : IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 18.r,
                          color: AppColors.circlecolor,
                        ),
                        onPressed: () {
                          searchController.clear();
                          onSearchChanged('');
                        },
                      ),
              filled: true,
              fillColor: AppColors.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.bIcon, width: 1.5),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                child: _DateFilterButton(
                  label: 'من تاريخ',
                  date: fromDate,
                  onTap: onPickFromDate,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _DateFilterButton(
                  label: 'إلى تاريخ',
                  date: toDate,
                  onTap: onPickToDate,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              Text(
                'عدد الدعاوى: $totalItems',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: Font.alex,
                  color: AppColors.circlecolor,
                ),
              ),
              const Spacer(),
              if (hasFilters)
                TextButton.icon(
                  onPressed: onClearFilters,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(Icons.filter_alt_off, size: 16.r, color: AppColors.red),
                  label: Text(
                    'مسح الفلاتر',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: Font.alex,
                      color: AppColors.red,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateFilterButton extends StatelessWidget {
  const _DateFilterButton({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasDate ? AppColors.bIcon : AppColors.grey,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16.r,
              color: hasDate ? AppColors.bIcon : AppColors.circlecolor,
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                hasDate ? DateFormat('yyyy/MM/dd').format(date!) : label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: Font.alex,
                  color: hasDate ? AppColors.black : AppColors.circlecolor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
