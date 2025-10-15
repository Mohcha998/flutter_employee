import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecase.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthCubit extends Cubit<AuthStatus> {
  final AuthUsecase usecase;
  AuthCubit(this.usecase) : super(AuthStatus.initial);

  Future<void> checkLogin() async {
    emit(AuthStatus.loading);
    final token = await usecase.getToken();
    if (token != null && token.isNotEmpty) {
      emit(AuthStatus.authenticated);
    } else {
      emit(AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthStatus.loading);
    final token = await usecase.login(email, password);
    if (token != null) {
      emit(AuthStatus.authenticated);
    } else {
      emit(AuthStatus.unauthenticated);
    }
  }

  Future<void> logout() async {
    await usecase.logout();
    emit(AuthStatus.unauthenticated);
  }
}
