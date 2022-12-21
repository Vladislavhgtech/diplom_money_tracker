import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FormTypeState extends Equatable {}

class SignIn extends FormTypeState {
  @override
  List<Object?> get props => [];
}

class SignUp extends FormTypeState {
  @override
  List<Object?> get props => [];
}