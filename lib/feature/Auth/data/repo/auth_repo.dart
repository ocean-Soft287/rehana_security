import 'package:dartz/dartz.dart';

import '../../../../core/Failure/Failure.dart';

import '../model/security_model.dart';

abstract class LoginRepo {
  Future<Either<Failure, SecurityUser>> login({
    required String email,
    required String password,
    required bool rememberme,
  });


}