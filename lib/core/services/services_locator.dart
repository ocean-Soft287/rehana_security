import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rehana_security/feature/accept_and_refuse/data/repo/acceptrepoimp.dart';

import '../../feature/Auth/data/repo/auth_repo.dart';
import '../../feature/Auth/data/repo/auth_repo_imp.dart';
import '../../feature/Auth/presentation/Manger/auth_cubit.dart';
import '../../feature/accept_and_refuse/data/repo/acceptrepo.dart';
import '../../feature/accept_and_refuse/presentation/manger/entre_exit_cubit.dart';
import '../../feature/manual_invitation/data/repo/manual_invitation_repo.dart';
import '../../feature/manual_invitation/data/repo/manual_invitation_repo_imp.dart';
import '../../feature/manual_invitation/presentation/manger/manual_invitation_cubit.dart';
import '../../feature/registered_invitations/data/repo/registered_invitations_repo.dart';
import '../../feature/registered_invitations/data/repo/registered_invitations_repo_imp.dart';
import '../../feature/registered_invitations/presentation/manger/registered_invitations_cubit.dart';
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
//qr read
  sl.registerLazySingleton<Acceptrepo>(() => AcceptRepoImp(dioConsumer: sl<DioConsumer>()),);
  sl.registerFactory<EntreExitCubit>(() => EntreExitCubit(sl<Acceptrepo>()));

  /// manual invitation
  sl.registerLazySingleton<ManualInvitationRepo>(
      () => ManualInvitationRepoImp(dioConsumer: sl<DioConsumer>()));
  sl.registerFactory<ManualInvitationCubit>(
      () => ManualInvitationCubit(sl<ManualInvitationRepo>()));

  /// registered invitations
  sl.registerLazySingleton<RegisteredInvitationsRepo>(
      () => RegisteredInvitationsRepoImp(dioConsumer: sl<DioConsumer>()));
  sl.registerFactory<RegisteredInvitationsCubit>(
      () => RegisteredInvitationsCubit(sl<RegisteredInvitationsRepo>()));

}