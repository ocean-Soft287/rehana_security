import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/invitation_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repo/invitation_repo.dart';
part 'securityonetime_state.dart';

class SecurityonetimeCubit extends Cubit<SecurityonetimeState> {
  SecurityonetimeCubit(this.invitationRepo) : super(SecurityonetimeInitial());

  final InvitationRepo invitationRepo;

  void sendinvitation({
    required String reasonForVisit,
    required DateTime dateFrom,
    required DateTime dateTo,
    required String guestName,
    required String guestPhoneNumber,
    required int vilaNumber,
    File? guestPicture,
  }) async {
    emit(SecurityonetimeLoading());
    final response = await invitationRepo.sendOneTimeInvitation(
      reasonForVisit: reasonForVisit,
      dateFrom: dateFrom,
      dateTo: dateTo,
      guestName: guestName,
      guestPhoneNumber: guestPhoneNumber,
      vilaNumber: vilaNumber,
      guestPicture: guestPicture,
    );
    response.fold(
          (failure) => emit(SecurityonetimeFailure(failure.message)),
          (invitation) {
            imageEditProfilePhoto=null;

            emit(SecurityonetimeSuccess(invitation));
          }
    );
  }

  XFile? imageEditProfilePhoto;

  var pickerPhoto = ImagePicker();

  Future<void> getProfileImageByGallery() async {
    try {
      emit(EditImagePickerProfileViewLoading());

      final pickedFile = await pickerPhoto.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        imageEditProfilePhoto = XFile(pickedFile.path);

        emit(EditImagePickerProfileViewSuccess());
      } else {
        emit(EditImagePickerProfileViewError());
      }
    } catch (e) {
      emit(EditImagePickerProfileViewError());
    }
  }

  final List<int> vilanumber=[];

  void getvilanumber() async {
    emit(GetVillaNumberLoading());
    try {
      final Dio dio = Dio();
      final response = await dio.get("http://78.89.159.126:9393/TheOneAPIRehana/api/Member/villaNumbers");

      if (response.statusCode == 200 && response.data is List) {
        vilanumber
          ..clear()
          ..addAll(List<int>.from(response.data));
        emit(GetVillaNumberSuccess(vilanumber));
      } else {
        emit(GetVillaNumberError("Unexpected response format"));
      }
    } catch (e) {
      emit(GetVillaNumberError(e.toString()));
    }
  }
  Future<void> handleInvitationSuccess(BuildContext context, SecurityonetimeSuccess state) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم ارسال الدعوي بنجاح")),
    );

    await Future.delayed(const Duration(milliseconds: 400));

    final qr = state.invitation.qrCode;
    if (qr.isNotEmpty) {
      Share.share(qr);
    }
  }
  }