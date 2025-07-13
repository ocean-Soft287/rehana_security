import 'package:bloc/bloc.dart';
import 'package:rehana_security/feature/Auth/data/model/security_model.dart';
import '../../data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginRepo loginRepo;

  AuthCubit(this.loginRepo) : super(AuthInitial());

  Future<void> login({required String email, required String password, required remberme}) async {
    emit(AuthLoading());

    final response = await loginRepo.login(email: email, password: password, rememberme: remberme);

    response.fold(
          (failure) {
            // print("failure.message${failure.message}");
        emit(AuthFailure(failure.message));

      },
          (data) {

        emit(AuthSuccess(data: data));
      },
    );
  }




}