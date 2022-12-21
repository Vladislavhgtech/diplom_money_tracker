import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/form_type.dart';
import '../events/form_type_event.dart';
import '../states/form_type_state.dart';

class FormTypeBloc extends Bloc<FormTypeEvent, FormTypeState> {
  FormTypeBloc() : super(SignIn()) {
    on<FormTypeRequested>((event, emit) async {
      if (event.formType == FormType.signIn) {
        emit(SignUp());
      } else {
        emit(SignIn());
      }
    });
  }
}
