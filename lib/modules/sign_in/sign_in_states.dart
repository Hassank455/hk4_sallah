import 'package:hk4_sallah/model/user_model.dart';
import 'package:hk4_sallah/shared/network/local/salla_States.dart';

class InitialSignInState extends SallaStates {}

class LoadingSignInState extends SallaStates {

}

class SuccessSignInState extends SallaStates {
  final UserModel userModel;

  SuccessSignInState(this.userModel);
}


class ErrorSignInState extends SallaStates {
  final String _error;

  ErrorSignInState(this._error);
}

class ChangeVisibilityPasswordSignInState extends SallaStates {}
