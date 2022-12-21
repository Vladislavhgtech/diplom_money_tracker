import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/profile_event.dart';
import '../states/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc():super(const ProfileState(isSave: false, isLoading: false, imageFile: '')) {
    on<ProfileRequested>((event, emit) async {
      emit(ProfileState(isSave: event.isSave, isLoading: event.isLoading, imageFile: event.imageFile));
    });
  }
}
