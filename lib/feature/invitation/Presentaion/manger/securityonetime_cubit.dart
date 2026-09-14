import 'dart:io';
import 'package:bloc/bloc.dart';
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
    response.fold((failure) => emit(SecurityonetimeFailure(failure.message)), (
      invitation,
    ) {
      imageEditProfilePhoto = null;

      emit(SecurityonetimeSuccess(invitation));
    });
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

  void getvilanumber() async {
    emit(GetVillaNumberLoading());
    final response = await invitationRepo.getVillaNumbers();
    response.fold(
      (failure) => emit(GetVillaNumberError(failure.message)),
      (villaNumbers) => emit(GetVillaNumberSuccess(villaNumbers)),
    );
  }

  Future<void> handleInvitationSuccess(
    BuildContext context,
    SecurityonetimeSuccess state,
  ) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("تم ارسال الدعوي بنجاح")));

    await Future.delayed(const Duration(milliseconds: 400));

    final qr = state.invitation.qrCode;
    if (qr.isNotEmpty) {
      Share.share(qr);
    }
  }
}
