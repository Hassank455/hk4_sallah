import 'package:hk4_sallah/shared/network/local/salla_States.dart';

class InitialSignInState extends SallaStates {}

class LoadingSignInState extends SallaStates {}

class SuccessSignInState extends SallaStates {}

class ErrorSignInState extends SallaStates {
  final String _error;

  ErrorSignInState(this._error);
}

class ChangeVisibilityPasswordSignInState extends SallaStates {}
