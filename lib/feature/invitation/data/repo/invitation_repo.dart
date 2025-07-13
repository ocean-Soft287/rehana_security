import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/Failure/failure.dart';
import '../model/invitation_model.dart';

abstract class InvitationRepo {
  Future<Either<Failure, Invitation>> sendOneTimeInvitation({
    required String reasonForVisit,
    required DateTime dateFrom,
    required DateTime dateTo,
    required String guestName,
    required String guestPhoneNumber,
    required int vilaNumber,
    File? guestPicture,
  });

}