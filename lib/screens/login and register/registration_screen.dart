import 'package:flutter/material.dart';
import '../../instruments/api.dart';
import '../../instruments/components/custom_button.dart';
import '../../instruments/components/custom_form_field.dart';
import '../../instruments/components/custom_search_field.dart';
import '../../instruments/constants.dart';
import '../../models/errors_model.dart';
import '../choose_city_screen.dart';

class RegistrationPage extends StatefulWidget {

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  String? emailErrorMsg;
  String? passwordErrorMsg;
  String? confirmPasswordErrorMsg;
  String? firstNameErrorMsg;
  String? lastNameErrorMsg;
  String? cityErrorMsg;

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _cityController = TextEditingController();
  int? _cityId;

  String? isNotNullValidator(String? value) {
    if (value == null || value.isEmpty) {
      String errorMsg = 'Поле обязательно для заполнения';
      return errorMsg;
    }
    return null;
  }

  final ApiService _apiService = ApiService();

  bool loadingToggle=false;
  final _formKey = GlobalKey<FormState>();

  void goToChooseCityPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseCityPage(),
        )
    );
    print(result);
    if(result!=null) {
      setState(() {
        _cityController.text = result['city'];
        _cityId = result['id'];
      });
    }
  }

  void registration(context) async{
    setState(() {
      emailErrorMsg = null;
      passwordErrorMsg = null;
      confirmPasswordErrorMsg = null;
      firstNameErrorMsg = null;
      lastNameErrorMsg = null;
      cityErrorMsg = null;
      loadingToggle = true;
    });
    if(_emailController.text.isNotEmpty
        && _passwordController.text.isNotEmpty
        && _confirmPasswordController.text.isNotEmpty
        && _lastNameController.text.isNotEmpty
        && _firstNameController.text.isNotEmpty
        && _cityController.text.isNotEmpty
    ) {
      var response = await _apiService.register(
        _emailController.text.toString(),
        _passwordController.text.toString(),
        _confirmPasswordController.text.toString(),
        _firstNameController.text.toString(),
        _lastNameController.text.toString(),
        _cityController.text.toString(),
        _cityId,
      );
      if(response == 200){
        Navigator.pushReplacementNamed( context, '/registration_second_screen');
      }
      else {
        Errors errors = Errors.fromJson(response);
        setState(() {
          if(errors.email!=null){
            emailErrorMsg = errors.email![0];
          }
          if(errors.password!=null){
            passwordErrorMsg = errors.password![0];
          }
          if(errors.confirm_password!=null){
            confirmPasswordErrorMsg = errors.confirm_password![0];
          }
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
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 50),
                          CustomFormField(
                            controller: _emailController,
                            textPlaceholder: 'Email',
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                emailErrorMsg = 'Поле обязательно для заполнения';
                                return emailErrorMsg;
                              }
                              else if(!value.contains('@')){
                                emailErrorMsg = 'Неверный формат электронной почты';
                                return emailErrorMsg;
                              }
                              return null;
                            },
                            errorMsg: emailErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: _passwordController,
                            textPlaceholder: 'Пароль',
                            isPassword: true,
                            validator: (value) {
                              passwordErrorMsg = isNotNullValidator(value);
                              return passwordErrorMsg;
                            },
                            errorMsg: passwordErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: _confirmPasswordController,
                            textPlaceholder: 'Подтвердите пароль',
                            isPassword: true,
                            validator: (value) {
                              confirmPasswordErrorMsg=isNotNullValidator(value);
                              return confirmPasswordErrorMsg;
                            },
                            errorMsg: confirmPasswordErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: _firstNameController,
                            textPlaceholder: 'Имя',
                            validator: (value) {
                              firstNameErrorMsg=isNotNullValidator(value);
                              return firstNameErrorMsg;
                            },
                            errorMsg: firstNameErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: _lastNameController,
                            textPlaceholder: 'Фамилия',
                            validator: (value) {
                              lastNameErrorMsg=isNotNullValidator(value);
                              return lastNameErrorMsg;
                            },
                            errorMsg: lastNameErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomSearchField(
                            onTextChanged: (){},
                            hint: 'Город',
                            readOnly: true,
                            controller: _cityController,
                            onTap: (){
                              goToChooseCityPage(context);
                            },
                            suffixIcon: const Icon(
                              Icons.arrow_forward_ios,
                            ),
                            errorMsg: 'Поле обязательно для заполнения',
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: CustomButton(
                          onPressed: (){
                            setState((){
                              if(_formKey.currentState!.validate()) {
                                registration(context);
                              }
                            });
                          },
                          text: 'Регистрация',
                          color: Colors.blue,
                          textColor: Colors.white,
                          isLoading: loadingToggle,
                        ),
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
