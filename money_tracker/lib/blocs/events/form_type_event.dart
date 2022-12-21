import 'package:equatable/equatable.dart';

import '../../models/form_type.dart';

abstract class FormTypeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FormTypeRequested extends FormTypeEvent {
  final FormType formType;

  FormTypeRequested(this.formType);
}