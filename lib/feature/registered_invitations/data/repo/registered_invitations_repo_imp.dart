import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/Failure/Failure.dart';
import '../../../../core/utils/api/dio_consumer.dart';
import '../../../../core/utils/api/endpoint.dart';
import '../model/registered_invitation_model.dart';
import '../model/registered_invitations_response.dart';
import 'registered_invitations_repo.dart';

class RegisteredInvitationsRepoImp implements RegisteredInvitationsRepo {
  final DioConsumer dioConsumer;

  RegisteredInvitationsRepoImp({required this.dioConsumer});

  @override
  Future<Either<Failure, RegisteredInvitationsResponse>> getInvitations({
    required InvitationStatus status,
    String? memberName,
    DateTime? fromDate,
    DateTime? toDate,
    required int page,
    required int pageSize,
  }) async {
    try {
      final trimmedName = memberName?.trim();

      final response = await dioConsumer.get(
        EndPoint.oneTimeInvitations,
        forceRefresh: true,
        queryParameters: {
          'status': status.apiValue,
          if (trimmedName != null && trimmedName.isNotEmpty)
            'memberName': trimmedName,
          if (fromDate != null) 'fromDate': _formatDate(fromDate),
          if (toDate != null) 'toDate': _formatDate(toDate),
          'page': page,
          'pageSize': pageSize,
        },
      );

      final data = response is Response ? response.data : response;

      if (data is! Map<String, dynamic>) {
        return left(const ServerFailure('صيغة بيانات الدعاوى غير صحيحة'));
      }

      return right(RegisteredInvitationsResponse.fromJson(data));
    } on DioException catch (e) {
      return left(_handleDioError(e));
    } catch (e) {
      return left(ServerFailure('فشل تحميل الدعاوى: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> endInvitation(String invitationId) async {
    try {
      final response = await dioConsumer.put(
        EndPoint.endOneTimeInvitation(invitationId),
        data: {'invitationId': invitationId},
      );

      final data = response is Response ? response.data : response;

      String message = 'تم إنهاء الدعوة بنجاح';
      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }

      return right(message);
    } on DioException catch (e) {
      return left(_handleDioError(e));
    } catch (e) {
      return left(ServerFailure('فشل إنهاء الدعوة: ${e.toString()}'));
    }
  }

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  Failure _handleDioError(DioException error) {
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
