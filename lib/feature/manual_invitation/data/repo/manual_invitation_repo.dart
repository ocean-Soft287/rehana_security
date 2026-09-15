import 'package:dartz/dartz.dart';

import '../../../../core/Failure/Failure.dart';
import '../model/manual_invitation_request.dart';
import '../model/villa_model.dart';

abstract class ManualInvitationRepo {
  Future<Either<Failure, List<VillaModel>>> getVillas();

  Future<Either<Failure, String>> sendOneTimeInvitation(
    ManualInvitationRequest request,
  );
}
