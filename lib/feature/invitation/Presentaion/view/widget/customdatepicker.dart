import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../core/color/colors.dart';
import 'package:flutter/material.dart';
import '../../../../../core/images/font.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _focusedDate;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      final d = widget.selectedDate!;
      _focusedDate = DateTime(d.year, d.month, d.day);
    } else {
      final now = DateTime.now();
      _focusedDate = DateTime(now.year, now.month, now.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "التاريخ",
              style: const TextStyle(          fontSize: 17,
                fontWeight: FontWeight.w400,
                fontFamily: Font.alex,
                color: AppColors.black,),
            ),
          ],
        ),
        const SizedBox(height: 8),
        EasyTheme(
          data: EasyTheme.of(context).copyWithState(
            selectedDayTheme: DayThemeData(backgroundColor: AppColors.bIcon),
            unselectedDayTheme: DayThemeData(backgroundColor: AppColors.white),
            disabledDayTheme: DayThemeData(backgroundColor: AppColors.white),
          ),
          child: EasyDateTimeLinePicker(
            focusedDate: _focusedDate,
            firstDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            lastDate: DateTime(2900, 3, 18),
            onDateChange: (date) {
              final picked = DateTime(date.year, date.month, date.day);
              setState(() {
                _focusedDate = picked;
              });
              widget.onDateSelected(picked); // نرسل للـ parent التاريخ بدون زمن
            },
            locale: Locale('ar'),

            disableStrategy: DisableStrategy.beforeToday(),
          ),
        ),
      ],
    );
  }
}