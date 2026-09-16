import 'package:dartz/dartz.dart';

import '../../../../core/Failure/Failure.dart';
import '../model/manual_invitation_request.dart';
import '../model/villa_model.dart';

abstract class ManualInvitationRepo {
  /// [villaNumber] بحث اختيارى برقم الفيلا على السيرفر
  Future<Either<Failure, List<VillaModel>>> getVillas({String? villaNumber});

  Future<Either<Failure, String>> sendOneTimeInvitation(
    ManualInvitationRequest request,
  );
}
