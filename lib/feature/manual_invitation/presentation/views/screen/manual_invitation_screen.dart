import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widget/context_show.dart';
import '../../../../../core/widget/loading_button.dart';
import '../../../data/model/villa_model.dart';
import '../../manger/manual_invitation_cubit.dart';
import '../widget/manual_invitation_field.dart';

class ManualInvitationScreen extends StatelessWidget {
  const ManualInvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ManualInvitationCubit>()..getVillas(),
      child: const ManualInvitationView(),
    );
  }
}

class ManualInvitationView extends StatefulWidget {
  const ManualInvitationView({super.key});

  @override
  State<ManualInvitationView> createState() => _ManualInvitationViewState();
}

class _ManualInvitationViewState extends State<ManualInvitationView> {
  final _formKey = GlobalKey<FormState>();
  final _visitorNameController = TextEditingController();
  final _carPlateController = TextEditingController();
  final _notesController = TextEditingController();

  VillaModel? _selectedVilla;
  DateTime? _visitTime;

  @override
  void dispose() {
    _visitorNameController.dispose();
    _carPlateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatVisitTime(DateTime dateTime) {
    return DateFormat(
      'yyyy/MM/dd - hh:mm a',
    ).format(dateTime).replaceAll('AM', 'ص').replaceAll('PM', 'م');
  }

  Future<void> _pickVisitTime() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _visitTime ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      builder:
          (context, child) =>
              Directionality(textDirection: TextDirection.rtl, child: child!),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_visitTime ?? now),
      builder:
          (context, child) =>
              Directionality(textDirection: TextDirection.rtl, child: child!),
    );

    if (time == null) return;

    setState(() {
      _visitTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedVilla == null) {
      context.showErrorMessage('من فضلك اختر رقم الفيلا');
      return;
    }

    if (_visitTime == null) {
      context.showErrorMessage('من فضلك اختر توقيت الزيارة');
      return;
    }

    final visitorName = _visitorNameController.text.trim();
    final carPlate = _carPlateController.text.trim();
    final notes = _notesController.text.trim();

    context.read<ManualInvitationCubit>().sendInvitation(
      // يتم إرسال رقم الفيلا فقط بدون اسم المالك
      villaNumber: _selectedVilla!.villaNumber,
      visitorName: visitorName.isEmpty ? null : visitorName,
      carPlateNumber: carPlate,
      visitTime: _visitTime!,
      notes: notes.isEmpty ? null : notes,
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _visitorNameController.clear();
    _carPlateController.clear();
    _notesController.clear();
    setState(() {
      _selectedVilla = null;
      _visitTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.bIcon,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.black),
          title: Text(
            'تسجيل دعوة يدوى',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              fontFamily: Font.alex,
              color: AppColors.black,
            ),
          ),
        ),
        body: BlocConsumer<ManualInvitationCubit, ManualInvitationState>(
          listener: (context, state) {
            if (state is SendInvitationSuccess) {
              context.showSuccessMessage(state.message);
              _resetForm();
            } else if (state is SendInvitationFailure) {
              context.showErrorMessage(state.message);
            } else if (state is VillasFailure) {
              context.showErrorMessage(state.message);
            }
          },
          builder: (context, state) {
            final cubit = context.read<ManualInvitationCubit>();
            final isSending = state is SendInvitationLoading;
            final isLoadingVillas = state is VillasLoading;

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// رقم الفيلا + اسم المالك
                      const FieldLabel(text: 'رقم الفيلا', isRequired: true),
                      if (isLoadingVillas)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: const LoadingButton(),
                          ),
                        )
                      else
                        DropdownButtonFormField<VillaModel>(
                          initialValue: _selectedVilla,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.circlecolor,
                          ),
                          decoration: manualInvitationDecoration(
                            hintText: 'اختر رقم الفيلا',
                          ),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: Font.alex,
                            color: AppColors.black,
                          ),
                          items:
                              cubit.villas
                                  .map(
                                    (villa) => DropdownMenuItem<VillaModel>(
                                      value: villa,
                                      child: Text(
                                        villa.displayName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: Font.alex,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              isSending
                                  ? null
                                  : (villa) {
                                    setState(() => _selectedVilla = villa);
                                  },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'من فضلك اختر رقم الفيلا'
                                      : null,
                        ),

                      if (state is VillasFailure) ...[
                        SizedBox(height: 8.h),
                        TextButton.icon(
                          onPressed: cubit.getVillas,
                          icon: Icon(Icons.refresh, color: AppColors.bIcon),
                          label: Text(
                            'إعادة تحميل الفلل',
                            style: TextStyle(
                              fontFamily: Font.alex,
                              fontSize: 13.sp,
                              color: AppColors.bIcon,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 18.h),

                      /// اسم الزائر (اختيارى)
                      const FieldLabel(text: 'اسم الزائر (اختيارى)'),
                      ManualInvitationField(
                        controller: _visitorNameController,
                        hintText: 'أدخل اسم الزائر',
                        keyboardType: TextInputType.name,
                      ),

                      SizedBox(height: 18.h),

                      /// رقم العربية
                      const FieldLabel(text: 'رقم العربية', isRequired: true),
                      ManualInvitationField(
                        controller: _carPlateController,
                        hintText: 'أدخل رقم العربية',
                        keyboardType: TextInputType.text,
                        validator:
                            (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? 'من فضلك أدخل رقم العربية'
                                    : null,
                      ),

                      SizedBox(height: 18.h),

                      /// توقيت الزيارة
                      const FieldLabel(text: 'توقيت الزيارة', isRequired: true),
                      InkWell(
                        onTap: isSending ? null : _pickVisitTime,
                        borderRadius: BorderRadius.circular(12.r),
                        child: InputDecorator(
                          decoration: manualInvitationDecoration(
                            hintText: 'اختر توقيت الزيارة',
                            suffixIcon: Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.circlecolor,
                              size: 20.r,
                            ),
                          ),
                          child: Text(
                            _visitTime == null
                                ? 'اختر توقيت الزيارة'
                                : _formatVisitTime(_visitTime!),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: Font.alex,
                              color:
                                  _visitTime == null
                                      ? AppColors.circlecolor
                                      : AppColors.black,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      /// ملاحظات (اختيارى)
                      const FieldLabel(text: 'ملاحظات (اختيارى)'),
                      ManualInvitationField(
                        controller: _notesController,
                        hintText: 'أضف ملاحظات',
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                      ),

                      SizedBox(height: 30.h),

                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.bIcon,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                          ),
                          onPressed: isSending ? null : _submit,
                          child:
                              isSending
                                  ? SizedBox(
                                    height: 28.h,
                                    child: const FittedBox(
                                      child: LoadingButton(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    'تسجيل الدعوة',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: Font.alex,
                                      color: AppColors.white,
                                    ),
                                  ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
