import 'package:dartz/dartz.dart';
import 'package:rehana_security/core/Failure/Failure.dart';

import '../model/guest_model.dart';
import '../model/security_invitation.dart';

abstract class Acceptrepo{
  Future<Either<Failure,GuestInvitationModel>>decryption( String data);
Future<Either<Failure,SecurityInvitation>>isvalid(bool isvalidid,String id);

}