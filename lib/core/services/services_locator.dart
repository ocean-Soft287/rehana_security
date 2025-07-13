import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rehana_security/feature/accept_and_refuse/data/repo/acceptrepoimp.dart';

import '../../feature/Auth/data/repo/auth_repo.dart';
import '../../feature/Auth/data/repo/auth_repo_imp.dart';
import '../../feature/Auth/presentation/Manger/auth_cubit.dart';
import '../../feature/accept_and_refuse/data/repo/acceptrepo.dart';
import '../../feature/accept_and_refuse/presentation/manger/entre_exit_cubit.dart';
import '../../feature/invitation/Presentaion/manger/securityonetime_cubit.dart';
import '../../feature/invitation/data/repo/invitation_repo.dart';
import '../../feature/invitation/data/repo/invitation_repo_imp.dart';
import '../utils/api/endpoint.dart';
import '../utils/api/api_consumer.dart';
import '../utils/api/dio_consumer.dart';

final sl = GetIt.instance;
void setup() {
  // Dio instance registration
  sl.registerLazySingleton<Dio>(
          () => Dio(BaseOptions(baseUrl: EndPoint.baseUrl))
        ..interceptors.add(LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        )));

  /// Register DioConsumer
  sl.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: sl<Dio>()));
  sl.registerLazySingleton<ApiConsumer>(() => sl<DioConsumer>());

  /// Registering login
  sl.registerLazySingleton<LoginRepo>(
          () => Loginrepoimp(dioConsumer: sl<DioConsumer>()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<LoginRepo>()));
//sendinvitation
  sl.registerLazySingleton<InvitationRepo>(() => Invitationrepoimp(dioConsumer: sl<DioConsumer>()),);
  sl.registerFactory<SecurityonetimeCubit>(() => SecurityonetimeCubit(sl<InvitationRepo>()));
//qr read
  sl.registerLazySingleton<Acceptrepo>(() => AcceptRepoImp(dioConsumer: sl<DioConsumer>()),);
  sl.registerFactory<EntreExitCubit>(() => EntreExitCubit(sl<Acceptrepo>()));

}