import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rehana_security/feature/accept_and_refuse/data/model/security_invitation.dart';

import '../../../../core/Failure/Failure.dart';
import '../../../../core/utils/api/dio_consumer.dart';
import '../../../../core/utils/api/endpoint.dart';
import '../model/guest_model.dart';
import 'acceptrepo.dart';

class AcceptRepoImp implements Acceptrepo {
  final DioConsumer dioConsumer;

  AcceptRepoImp({required this.dioConsumer});

  @override
  @override
  Future<Either<Failure, GuestInvitationModel>> decryption(String data) async {
    try {
      final response = await dioConsumer.post(
        EndPoint.encryption,
        data: {'encryptedData': data},
      );

      final Map<String, dynamic> json =
          response is Response
              ? response.data as Map<String, dynamic>
              : response;

      final model = GuestInvitationModel.fromJson(json);
      return right(model);
    } on DioException catch (e) {
      return left(handleDioError(e));
    } catch (e) {
      return left(ServerFailure('Decryption failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, SecurityInvitation>> isvalid(
    bool isvalidid,
    String id,
  ) async {
    try {
      final response = await dioConsumer.post(
        EndPoint.acceptionValidation,
        data: {"invitationId": id, "action": isvalidid},
      );

      final Map<String, dynamic> json =
          response is Response
              ? response.data as Map<String, dynamic>
              : response;

      final model = SecurityInvitation.fromJson(json);
      return right(model);
    } on DioException catch (e) {
      return left(handleDioError(e));
    } catch (e) {
      return left(ServerFailure('Decryption failed: ${e.toString()}'));
    }
  }

  Failure handleDioError(DioException error) {
    String message = "Unknown error occurred";

    if (error.response != null) {
      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response?.data as Map<String, dynamic>;
        if (data.containsKey('message')) {
          message = data['message'];
        } else {
          message = error.response?.data.toString() ?? message;
        }
      } else if (error.response?.data is String) {
        message = error.response?.data;
      }

      // أو fallback إلى status code
      message = message;
    }

    return ServerFailure(message);
  }
}
