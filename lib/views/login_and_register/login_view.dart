import 'package:board_game_app/view_models/login_and_register/login_view_model.dart';
import 'package:board_game_app/views/login_and_register/registration_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../instruments/components/custom_button.dart';
import '../../instruments/components/custom_form_field.dart';
import '../../instruments/constants.dart';

class LoginView extends StatefulWidget {

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kFormPadding,
          child: Form(
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 150.0),
                        child: Text(
                          'Добро пожаловать!',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomFormField(
                            controller: loginViewModel.emailController,
                            textPlaceholder: 'Email',
                            errorMsg: loginViewModel.emailErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: loginViewModel.passwordController,
                            textPlaceholder: 'Пароль',
                            isPassword: true,
                            errorMsg: loginViewModel.passwordErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            onPressed: (){
                              FocusManager.instance.primaryFocus?.unfocus();
                              loginViewModel.login(context);
                            },
                            text: 'Войти',
                            color: Colors.blue,
                            textColor: Colors.white,
                            isLoading: loginViewModel.loading,
                          ),
                          //TODO: кнопка "забыли пароль?"
                          // const Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                          //   child: Text(
                          //     'Забыли пароль?',
                          //     // textAlign: TextAlign.right,
                          //     style: TextStyle(
                          //       fontSize: 12.0,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          kHorizontalSizedBoxDivider,
                          CustomButton(
                            onPressed: (){
                              Navigator.push( context, MaterialPageRoute(
                                  builder: (context) => RegistrationView())
                              );
                            },
                            text: 'Зарегистрироваться',
                            color: Colors.white,
                            textColor: Colors.black,
                          ),
                          kHorizontalSizedBoxDivider,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


