import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/color/colors.dart';
import '../../../../../core/images/font.dart';
import '../../manger/securityonetime_cubit.dart';
import '../widget/custom_button_invtaion.dart';
import '../widget/customdatepicker.dart';
import '../widget/fromto_widget.dart';
import '../widget/invtaion_textformfield.dart';
import '../widget/picturewidget.dart';


class OneTimeInvitation extends StatefulWidget {
  const OneTimeInvitation({super.key});

  @override
  State<OneTimeInvitation> createState() => _OneTimeInvitationState();
}

class _OneTimeInvitationState extends State<OneTimeInvitation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _reasonController;
  DateTime? _selectedDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  List<int> villaNumbers = [];
  int? selectedVilla;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _reasonController = TextEditingController();
    context.read<SecurityonetimeCubit>().getvilanumber();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invitationCubit = context.read<SecurityonetimeCubit>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InvtaionTextformfield(
                name: "الاسم",
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "برجاء ادخال الاسم";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),
              InvtaionTextformfield(
                name: "رقم التليفون",
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "برجاء ادخال رقم الهاتف";
                  }
                  final phoneRegex = RegExp(r'^[0-9]{8,15}$');
                  if (!phoneRegex.hasMatch(value.trim())) {
                    return "رقم الهاتف غير صحيح";
                  }
                  if (value.trim().length != 12) {
                    return "رقم الهاتف يجب ان يحتوي علي 12 رقم فقط";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CustomDatePicker(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 20),
              FromtoWidget(
                fromTime: _fromTime,
                toTime: _toTime,
                selectedDate: _selectedDate,
                onTimeSelected: (from, to) {
                  setState(() {
                    _fromTime = from;
                    _toTime = to;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "سبب الزيارة",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      fontFamily: Font.alex,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.bIcon),
                ),
                child: TextFormField(
                  controller: _reasonController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "برجاء ادخال سبب الزيارة";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "رقم الفيلا",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      fontFamily: Font.alex,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BlocBuilder<SecurityonetimeCubit, SecurityonetimeState>(
                builder: (context, state) {
                  if (state is GetVillaNumberLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetVillaNumberSuccess) {
                    villaNumbers = state.villaNumbers;
                  }
                  return DropdownButtonFormField2<int>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppColors.bIcon, width: 2),
                      ),
                    ),
                    hint: const Text('اختار رقم الفيلا', style: TextStyle(fontSize: 14)),
                    value: selectedVilla,
                    items: villaNumbers
                        .map((item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(item.toString(), style: const TextStyle(fontSize: 14)),
                    ))
                        .toList(),
                    validator: (value) => value == null ? 'برجاء اختيار رقم فيلا' : null,
                    onChanged: (value) => setState(() => selectedVilla = value),
                  );
                },
              ),
              const SizedBox(height: 26),
              const Picturewidget(),
              const SizedBox(height: 26),
              Row(
                children: [
                  const Spacer(),
                  BlocConsumer<SecurityonetimeCubit, SecurityonetimeState>(
  listener: (context, state) {
    if (state is SecurityonetimeSuccess) {
      _nameController.clear();
      _phoneController.clear();
      _reasonController.clear();
      _selectedDate = null;
      _fromTime = null;
      _toTime = null;
      selectedVilla = null;

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return Dialog(
      //         insetPadding: EdgeInsets.zero, // يخليها تاخد حجم الشاشة كله
      //         child: Container(
      //           width: MediaQuery.of(context).size.width,
      //           height: MediaQuery.of(context).size.height,
      //           padding: const EdgeInsets.all(24),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //
      //               const SizedBox(height: 20),
      //               Image.network(
      //                 state.invitation.qrCode,
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 height: MediaQuery.of(context).size.height * 0.5,
      //                 fit: BoxFit.contain,
      //                 errorBuilder: (context, error, stackTrace) {
      //                   return Text(
      //                     "فشل تحميل صورة الـ QR",
      //                     style: TextStyle(color: Colors.red),
      //                   );
      //                 },
      //               ),
      //
      //               const SizedBox(height: 30),
      //               ElevatedButton(
      //                 onPressed: () => Navigator.of(context).pop(),
      //                 child: Text("Close"),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   );
      // });
    }


  },
  builder: (context, state) {
    return CustomButtonInvtaion(
                    text: 'إرسال',
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;

                      if (_selectedDate == null || _fromTime == null || _toTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("برجاء اختيار التاريخ والوقت")),
                        );
                        return;
                      }

                      final dateFrom = DateTime(
                        _selectedDate!.year,
                        _selectedDate!.month,
                        _selectedDate!.day,
                        _fromTime!.hour,
                        _fromTime!.minute,
                      );
                      final dateTo = DateTime(
                        _selectedDate!.year,
                        _selectedDate!.month,
                        _selectedDate!.day,
                        _toTime!.hour,
                        _toTime!.minute,
                      );

                      invitationCubit.sendinvitation(
                        reasonForVisit: _reasonController.text.trim(),
                        dateFrom: dateFrom,
                        dateTo: dateTo,
                        guestName: _nameController.text.trim(),
                        guestPhoneNumber: _phoneController.text.trim(),
                        vilaNumber: selectedVilla!,
                        guestPicture: invitationCubit.imageEditProfilePhoto != null
                            ? File(invitationCubit.imageEditProfilePhoto!.path)
                            : null,
                      );
                    },
                  );
  },
),
                  const Spacer(),
                  CustomButtonInvtaion(
                    text: 'رجوع',
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
