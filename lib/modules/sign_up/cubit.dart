import 'package:bloc/bloc.dart';
import 'package:hk4_sallah/modules/sign_up/sign_up_states.dart';
import 'package:hk4_sallah/shared/network/local/salla_States.dart';

class SignUp extends Cubit<SallaStates> {
  SignUp() : super(InitialSignUpState());
}
