import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/models/exception_login.dart';

@immutable
abstract class LoginState extends Equatable {}

class Loading extends LoginState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends LoginState {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginError extends LoginState {
  final ExceptionLogin error;

  LoginError(this.error);

  @override
  List<Object?> get props => [error];
}