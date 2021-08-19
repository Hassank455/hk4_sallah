import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hk4_sallah/layout/navigation_bar/navigation_bar.dart';
import 'package:hk4_sallah/model/user_model.dart';
import 'package:hk4_sallah/modules/sign_in/cubit.dart';
import 'package:hk4_sallah/modules/sign_in/sign_in.dart';
import 'package:hk4_sallah/modules/sign_up/cubit.dart';
import 'package:hk4_sallah/modules/sign_up/sign_up_states.dart';
import 'package:hk4_sallah/shared/components/components.dart';
import 'package:hk4_sallah/shared/components/constants.dart';
import 'package:hk4_sallah/shared/network/local/salla_States.dart';
import 'package:hk4_sallah/shared/network/local/storage_pref.dart';

class SignUp extends StatefulWidget {
  static const String SIGN_UP_SCREEN = 'sign_up';

  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _userController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _userController.dispose();
    _passController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user;
    return BlocProvider(
      create: (BuildContext context) => SignUpc(),
      child: BlocConsumer<SignUpc, SallaStates>(
        listener: (context, state) {
          /*user = SignUpc.get(context).userList;
          if (state is SuccessSignUpState) {
            if (user!.status!) {
              pushAndReplace(context, SignIn.SIGN_IN_SCREEN);
              Flushbar(
                title: 'Alert!',
                message: user!.message,
                duration: Duration(seconds: 3),
              )..show(context);
            } else {
              Flushbar(
                title: 'Alert!',
                message: user!.message,
                duration: Duration(seconds: 3),
              )..show(context);
            }
          }*/
          if (state is SuccessSignUpState) {
            if (state.userModel.status!) {
              print(state.userModel.message);
              print(state.userModel.dataRegister!.token);
              print('3333333333333333333333');

              StoragePref.setValue(
                key: 'token',
                value: state.userModel.dataRegister!.token,

              ).then((value) {
                token = state.userModel.dataRegister!.token!;
                print('44444444444444444');
                Navigator.pushNamedAndRemoveUntil(
                    context, NavigationBar.NAVIGATION_BAR_SCREEN, (route) => false);
                Flushbar(
                  title: 'Alert!',
                  message: state.userModel.message,
                  duration: Duration(seconds: 3),
                )..show(context);
              });
            } else {
              print(state.userModel.message);

              Flushbar(
                title: 'Alert!',
                message: state.userModel.message,
                duration: Duration(seconds: 3),
              )..show(context);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            body: Center(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height * 0.15,
                          // ),
                          Text(
                            'Register',
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          customTextEditing(
                            label: 'User Name',
                            controller: _userController,
                            icon: Icon(Icons.account_circle_outlined),
                            valid: ( value) {
                              if (value!.isEmpty) {
                                return 'This field should not be empty';
                              }
                              return null;
                            },
                            keyboard: TextInputType.text,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          customTextEditing(
                            label: 'Phone Number',
                            controller: _phoneController,
                            icon: Icon(Icons.phone_android_outlined),
                            valid: ( value) {
                              if (value!.isEmpty) {
                                return 'This field should not be empty';
                              }
                              return null;
                            },
                            keyboard: TextInputType.phone,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          customTextEditing(
                            label: 'Email Address',
                            controller: _emailController,
                            icon: Icon(Icons.email_outlined),
                            valid: ( value) {
                              if (value!.isEmpty) {
                                return 'This field should not be empty';
                              }
                              return null;
                            },
                            keyboard: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          customTextEditing(
                            label: 'Password',
                            controller: _passController,
                            icon: Icon(Icons.vpn_key_outlined),
                            valid: ( value) {
                              if (value!.isEmpty) {
                                return 'This field should not be empty';
                              }
                              return null;
                            },
                            keyboard: TextInputType.text,
                            obscureText: LoginCubit.get(context).isSecure,
                            suffixIcon: IconButton(
                              icon: LoginCubit.get(context).icon,
                              onPressed: () {
                                LoginCubit.get(context)
                                    .changeVisibilityIcon(state);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: state is! LoadingSignUpState
                                ? ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        /*LoginCubit.get(context).postUserLogin(
                                          route: SignUp.SIGN_UP_SCREEN,
                                          email: _emailController.text,
                                          password: _passController.text,
                                          userName: _userController.text,
                                          phone: _phoneController.text,
                                          url: END_POINT_SIGN_UP,
                                          context: context,
                                        );*/
                                        SignUpc.get(context).registerLogin(email: _emailController.text,
                                            password: _passController.text,
                                            phone: _phoneController.text,
                                            userName: _userController.text);
                                      }
                                    },
                                    child: Text(
                                      'REGISTER',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          !.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                    ),
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
