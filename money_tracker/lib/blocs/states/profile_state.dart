import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class ProfileState extends Equatable {
  final bool isSave;
  final bool isLoading;
  final String imageFile;

  const ProfileState({required this.isSave, required this.isLoading, required this.imageFile});

  @override
  List<Object> get props => [isSave, isLoading, imageFile];
}