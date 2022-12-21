import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/exception_login.dart';
import '../../repositories/login_repository.dart';
import '../events/login_event.dart';
import '../states/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(UnAuthenticated()) {
    on<SignInRequested>((event, emit) async {
      await _onSignIn(event, emit);
    });
    on<SignUpRequested>((event, emit) async {
      await _onSignUp(event, emit);
    });
    on<SignOutRequested>((event, emit) async {
      await _onSignOut(event, emit);
    });
  }

  Future<void> _onSignIn(event, emit) async {
    emit(Loading());
    try {
      await loginRepository.signIn(
          email: event.email, password: event.password);
      emit(Authenticated());
    } catch (e) {
      emit(LoginError(e is ExceptionLogin ? e : ExceptionLogin('')));
      emit(UnAuthenticated());
    }
  }

  Future<void> _onSignUp(event, emit) async {
    emit(Loading());
    try {
      await loginRepository.signUp(
          email: event.email, password: event.password);
      emit(Authenticated());
    } catch (e) {
      emit(LoginError(e is ExceptionLogin ? e : ExceptionLogin('')));
      emit(UnAuthenticated());
    }
  }

  Future<void> _onSignOut(event, emit) async {
    await loginRepository.signOut();
  }
}
