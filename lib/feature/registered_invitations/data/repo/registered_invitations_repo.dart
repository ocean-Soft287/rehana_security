import 'package:dartz/dartz.dart';

import '../../../../core/Failure/Failure.dart';
import '../model/registered_invitation_model.dart';
import '../model/registered_invitations_response.dart';

abstract class RegisteredInvitationsRepo {
  Future<Either<Failure, RegisteredInvitationsResponse>> getInvitations({
    required InvitationStatus status,
    String? memberName,
    DateTime? fromDate,
    DateTime? toDate,
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, String>> endInvitation(String invitationId);
}
