import 'package:hk4_sallah/model/user_model.dart';
import 'package:hk4_sallah/shared/network/local/salla_States.dart';

class InitialSignUpState extends SallaStates {}

class SuccessSignUpState extends SallaStates {
  final UserModel userModel;

  SuccessSignUpState(this.userModel);
}

class ErrorSignUpState extends SallaStates {
  final _error;

  ErrorSignUpState(this._error);
}

class LoadingSignUpState extends SallaStates {}

class ChangeVisibilityPasswordSignUpState extends SallaStates {}
