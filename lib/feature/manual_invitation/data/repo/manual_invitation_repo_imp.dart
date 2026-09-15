import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/Failure/Failure.dart';
import '../../../../core/utils/api/dio_consumer.dart';
import '../../../../core/utils/api/endpoint.dart';
import '../model/manual_invitation_request.dart';
import '../model/villa_model.dart';
import 'manual_invitation_repo.dart';

class ManualInvitationRepoImp implements ManualInvitationRepo {
  final DioConsumer dioConsumer;

  ManualInvitationRepoImp({required this.dioConsumer});

  @override
  Future<Either<Failure, List<VillaModel>>> getVillas() async {
    try {
      final response = await dioConsumer.get(EndPoint.villaList);

      final data = response is Response ? response.data : response;

      if (data is! List) {
        return left(const ServerFailure('صيغة بيانات الفلل غير صحيحة'));
      }

      final villas =
          data
              .whereType<Map<String, dynamic>>()
              .map(VillaModel.fromJson)
              .toList();

      return right(villas);
    } on DioException catch (e) {
      return left(handleDioError(e));
    } catch (e) {
      return left(ServerFailure('فشل تحميل الفلل: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOneTimeInvitation(
    ManualInvitationRequest request,
  ) async {
    try {
      final response = await dioConsumer.post(
        EndPoint.oneTimeInvitation,
        data: request.toJson(),
      );

      final data = response is Response ? response.data : response;

      String message = 'تم تسجيل الدعوة بنجاح';
      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }

      return right(message);
    } on DioException catch (e) {
      return left(handleDioError(e));
    } catch (e) {
      return left(ServerFailure('فشل إرسال الدعوة: ${e.toString()}'));
    }
  }

  Failure handleDioError(DioException error) {
    String message = "Unknown error occurred";

    if (error.response != null) {
      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response?.data as Map<String, dynamic>;
        if (data.containsKey('message')) {
          message = data['message'].toString();
        } else {
          message = error.response?.data.toString() ?? message;
        }
      } else if (error.response?.data is String) {
        message = error.response?.data;
      }
    }

    return ServerFailure(message);
  }
}
