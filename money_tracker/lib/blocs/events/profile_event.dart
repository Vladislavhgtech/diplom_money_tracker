import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProfileRequested extends ProfileEvent {
  final bool isSave;
  final bool isLoading;
  final String imageFile;

  ProfileRequested(this.isSave, this.isLoading, this.imageFile);
}