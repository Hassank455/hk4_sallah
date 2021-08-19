import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hk4_sallah/model/user_model.dart';
import 'package:hk4_sallah/modules/sign_up/sign_up_states.dart';
import 'package:hk4_sallah/shared/components/constants.dart';
import 'package:hk4_sallah/shared/network/local/salla_States.dart';
import 'package:hk4_sallah/shared/network/remot/dio_helper.dart';

class SignUpc extends Cubit<SallaStates> {
  SignUpc() : super(InitialSignUpState());

  static SignUpc get(context) => BlocProvider.of(context);

  bool isSecure = true;
  Icon icon = Icon(Icons.visibility_off_outlined);

  UserModel? userList;



/*  void changeVisibilityIcon(SallaStates state) {
    isSecure = !isSecure;
    isSecure
        ? icon = Icon(Icons.visibility_off_outlined)
        : icon = Icon(Icons.visibility_outlined);
    if (state is ChangeVisibilityPasswordSignInState) {
      emit(ChangeVisibilityPasswordSignInState());
    } else {
      emit(ChangeVisibilityPasswordSignUpState());
    }
  }*/

/*  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(ChangeVisibilityPasswordSignInState());
    emit(ChangeVisibilityPasswordSignUpState());
  }*/

  // بسبب مشابهة ال 2 Screen لبعضهم
  // قمنا بعمل باراميتر وهو ال route ومهمته هي
  // معرفة ال screen القادمة لل cubit ليقوم بعمل emit لل state المحدده فقط
/*  void postUserLogin({
    required BuildContext context,
    required String route,
    required String email,
    required String password,
    required String url,
    String? phone,
    String? userName,
  }) {
    if (route == SignIn.SIGN_IN_SCREEN)
      emit(LoadingSignInState());
    else if (route == SignUp.SIGN_UP_SCREEN) emit(LoadingSignUpState());

    SallaDioHelper.postData(endPointUrl: url, data: {
      'email': email,
      'password': password,
      'name': userName,
      'phone': phone,
    }).then((value) {
      if (route == SignIn.SIGN_IN_SCREEN) {
        userList = UserModel.fromJsonLogin(value.data);
        if (userList!.status!) {
          StoragePref.setValue('token', userList!.dataLogin!.token).then((value) {
            if (value) {
              String key = StoragePref.getValue(key: 'token');
              print('Shared Pref: ---> ${key}');
            }
          });
          token = userList!.dataLogin!.token!;
          print(userList!.dataLogin!.token);
        }
        emit(SuccessSignInState());
      } else if (route == SignUp.SIGN_UP_SCREEN) {
        userList = UserModel.fromJsonRegister(value.data);
        if (userList!.status!) {
          StoragePref.setValue('token', userList!.dataRegister!.token);
          token = userList!.dataRegister!.token!;
          *//*.then((value) => pushAndReplace(context, SignIn.SIGN_IN_SCREEN));*//*
        }
        emit(SuccessSignUpState());
      }
    }).catchError((error) {
      if (route == SignIn.SIGN_IN_SCREEN)
        emit(ErrorSignInState(error.toString()));
      else if (route == SignUp.SIGN_UP_SCREEN)
        emit(ErrorSignUpState(error.toString()));
      print(error.toString());
    });
  }*/

  void registerLogin({
    required String email,
    required String password,
    required String phone,
    required String userName,
  })
  {
    emit(InitialSignUpState());

    SallaDioHelper.postData(
      endPointUrl: END_POINT_SIGN_UP,
      data:
      {
        'email': email,
        'password': password,
        'name': userName,
        'phone': phone,
      },
    ).then((value)
    {
      print(value.data);
      // loginModel = ShopLoginModel.fromJson(value.data);
      userList = UserModel.fromJsonRegister(value.data);
      emit(SuccessSignUpState(userList!));
    }).catchError((error)
    {
      print(error.toString());
      emit(ErrorSignUpState(error.toString()));
    });
  }


}
