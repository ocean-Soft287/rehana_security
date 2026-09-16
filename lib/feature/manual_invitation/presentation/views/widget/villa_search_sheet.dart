import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';
import '../../../../../core/widget/loading_button.dart';
import '../../../data/model/villa_model.dart';
import '../../manger/manual_invitation_cubit.dart';
import 'manual_invitation_field.dart';

/// بوتوم شيت لاختيار الفيلا مع بحث برقم الفيلا على السيرفر
/// يرجع الفيلا المختارة أو null لو المستخدم قفل الشيت
Future<VillaModel?> showVillaSearchSheet({
  required BuildContext context,
  required ManualInvitationCubit cubit,
  VillaModel? selectedVilla,
}) {
  return showModalBottomSheet<VillaModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder:
        (_) => BlocProvider.value(
          value: cubit,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: _VillaSearchSheet(selectedVilla: selectedVilla),
          ),
        ),
  );
}

class _VillaSearchSheet extends StatefulWidget {
  const _VillaSearchSheet({this.selectedVilla});

  final VillaModel? selectedVilla;

  @override
  State<_VillaSearchSheet> createState() => _VillaSearchSheetState();
}

class _VillaSearchSheetState extends State<_VillaSearchSheet> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ManualInvitationCubit>();
    _searchController = TextEditingController(text: cubit.villaSearchQuery);

    // لو مفيش فلل محملة (أول فتح أو فشل التحميل) نجيبها
    if (cubit.villas.isEmpty) {
      cubit.getVillas(villaNumber: cubit.villaSearchQuery);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ManualInvitationCubit>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 0.75.sh,
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'اختر رقم الفيلا',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: Font.alex,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColors.black, size: 22.r),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: 14.sp, fontFamily: Font.alex),
                onChanged: cubit.searchVillas,
                onSubmitted:
                    (value) => cubit.getVillas(
                      villaNumber: value.trim().isEmpty ? null : value.trim(),
                    ),
                decoration: manualInvitationDecoration(
                  hintText: 'ابحث برقم الفيلا',
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, _) {
                      if (value.text.isEmpty) {
                        return Icon(
                          Icons.search,
                          color: AppColors.circlecolor,
                          size: 20.r,
                        );
                      }
                      return IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.circlecolor,
                          size: 20.r,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          cubit.searchVillas('');
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: BlocBuilder<ManualInvitationCubit, ManualInvitationState>(
                buildWhen:
                    (previous, current) =>
                        current is VillasLoading ||
                        current is VillasSuccess ||
                        current is VillasFailure,
                builder: (context, state) {
                  if (state is VillasLoading) {
                    return const Center(child: LoadingButton());
                  }

                  if (state is VillasFailure) {
                    return _SheetMessage(
                      message: state.message,
                      onRetry:
                          () => cubit.getVillas(
                            villaNumber: cubit.villaSearchQuery,
                          ),
                    );
                  }

                  final villas = cubit.villas;

                  if (villas.isEmpty) {
                    return const _SheetMessage(
                      message: 'لا توجد فلل بهذا الرقم',
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    itemCount: villas.length,
                    separatorBuilder:
                        (_, __) => Divider(height: 1.h, color: AppColors.grey),
                    itemBuilder: (context, index) {
                      final villa = villas[index];
                      final isSelected =
                          widget.selectedVilla?.villaNumber == villa.villaNumber;

                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                        title: Text(
                          villa.displayName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: Font.alex,
                            color: AppColors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                        trailing:
                            isSelected
                                ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.bIcon,
                                  size: 20.r,
                                )
                                : null,
                        onTap: () => Navigator.pop(context, villa),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetMessage extends StatelessWidget {
  const _SheetMessage({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: Font.alex,
                color: AppColors.circlecolor,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 8.h),
              TextButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, color: AppColors.bIcon),
                label: Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontFamily: Font.alex,
                    fontSize: 13.sp,
                    color: AppColors.bIcon,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
