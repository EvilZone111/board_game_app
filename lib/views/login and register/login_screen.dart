import 'package:board_game_app/instruments/api.dart';
import 'package:board_game_app/views/login and register/registration_screen.dart';
import 'package:board_game_app/views/home_screen.dart';
import 'package:flutter/material.dart';

import '../../instruments/components/custom_button.dart';
import '../../instruments/components/custom_form_field.dart';
import '../../instruments/constants.dart';

class LoginPage extends StatefulWidget {

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  String? emailErrorMsg;
  String? passwordErrorMsg;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool loadingToggle=false;
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  void login(context) async{
    setState(() {
      widget.emailErrorMsg = null;
      widget.passwordErrorMsg = null;
      loadingToggle = true;
    });
    if(widget._emailController.text.isNotEmpty && widget._passwordController.text.isNotEmpty) {
      var response = await _apiService.authenticate(widget._emailController.text.toString(), widget._passwordController.text.toString());
      if(response['statusCode'] == 200){
        Navigator.push( context, MaterialPageRoute(
            builder: (context) => HomeScreen(userId: response['id'],))
        );
      }
      else{
        setState(() {
          widget.emailErrorMsg = '';
          widget.passwordErrorMsg = 'Неверный логин или пароль';
        });
      }
    }
    setState(() {
      loadingToggle = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kFormPadding,
          child: Form(
            key: _formKey,
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
                            controller: widget._emailController,
                            textPlaceholder: 'Email',
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                widget.emailErrorMsg = 'Поле обязательно для заполнения';
                                return widget.emailErrorMsg;
                              }
                              else if(!value.contains('@')){
                                widget.emailErrorMsg = 'Неверный формат электронной почты';
                                return widget.emailErrorMsg;
                              }
                              return null;
                            },
                            errorMsg: widget.emailErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: widget._passwordController,
                            textPlaceholder: 'Пароль',
                            isPassword: true,
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                widget.passwordErrorMsg = 'Поле обязательно для заполнения';
                                return widget.passwordErrorMsg;
                              }
                              return null;
                            },
                            errorMsg: widget.passwordErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            onPressed: (){
                              if(_formKey.currentState!.validate()) {
                                login(context);
                              }
                            },
                            text: 'Войти',
                            color: Colors.blue,
                            textColor: Colors.white,
                            isLoading: loadingToggle,
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
                                  builder: (context) => RegistrationPage())
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


