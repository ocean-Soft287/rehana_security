import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/Failure/Failure.dart';
import '../../../../core/network/local/flutter_secure_storage.dart';
import '../../../../core/utils/api/endpoint.dart';
import '../../../../core/utils/api/dio_consumer.dart';
import '../model/security_model.dart';
import 'auth_repo.dart';



class Loginrepoimp implements LoginRepo {
  final DioConsumer dioConsumer;

  Loginrepoimp({required this.dioConsumer});

  @override
  Future<Either<Failure, SecurityUser>> login({
    required String email,
    required String password,
    required bool rememberme,
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken(
          vapidKey: "BF4pFQe9Hn3uvUQvIxdcu1CKhF-B3knjSggQE30Vut-wy_YtvELbn5LCIwIP4_jMYEOVTnLgIxlxVT2nm_Poiuo"
      );
      final response = await dioConsumer.post(
        EndPoint.login,
        data: {
          'email': email,
          'password': password,
          'rememberMe': rememberme,
          'deviceToken': fcmToken,
        },
      );
      final json = response as Map<String, dynamic>;
      final model = SecurityUser.fromJson(json);

      if (model.token.isEmpty) {
        return left(ServerFailure("Missing token in response."));
      }

      // حفظ البيانات في Secure Storage
      await SecureStorageService.write(
        SecureStorageService.token,
        model.token,
      );
      await SecureStorageService.write(SecureStorageService.rememberme,
          rememberme.toString());
      await SecureStorageService.write(
        SecureStorageService.name,
        model.userName,
      );
      await SecureStorageService.write(
        SecureStorageService.mobile,
        model.phoneNumber ,
      );
      await SecureStorageService.write(
        SecureStorageService.image,
        model.pictureUrl ?? '',
      );

      return right(model);
    } on DioException catch (e) {
      return left(handleDioError(e));
    } catch (e) {
      return left(ServerFailure("Login failed: ${e.toString()}"));
    }
  }

  Failure handleDioError(DioException error) {
    String message = "Unknown error occurred";

    if (error.response != null) {
      // حاول استخراج رسالة الخطأ من body
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
