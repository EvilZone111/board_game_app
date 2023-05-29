import 'package:board_game_app/view_models/login_and_register/registration_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../instruments/components/custom_button.dart';
import '../../instruments/components/custom_form_field.dart';
import '../../instruments/components/custom_search_field.dart';
import '../../instruments/constants.dart';
import '../choose_city_screen.dart';

class RegistrationView extends StatefulWidget {

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {

  @override
  Widget build(BuildContext context) {
    RegistrationViewModel registrationViewModel = Provider.of<RegistrationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 50),
                          CustomFormField(
                            controller: registrationViewModel.emailController,
                            textPlaceholder: 'Email',
                            errorMsg: registrationViewModel.emailErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: registrationViewModel.passwordController,
                            textPlaceholder: 'Пароль',
                            isPassword: true,
                            errorMsg: registrationViewModel.passwordErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: registrationViewModel.confirmPasswordController,
                            textPlaceholder: 'Подтвердите пароль',
                            isPassword: true,
                            errorMsg: registrationViewModel.confirmPasswordErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: registrationViewModel.firstNameController,
                            textPlaceholder: 'Имя',
                            errorMsg: registrationViewModel.firstNameErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: registrationViewModel.lastNameController,
                            textPlaceholder: 'Фамилия',
                            errorMsg: registrationViewModel.lastNameErrorMsg,
                          ),
                          const SizedBox(height: 10),
                          CustomSearchField(
                            onTextChanged: (){},
                            hint: 'Город',
                            readOnly: true,
                            controller: registrationViewModel.cityController,
                            onTap: (){
                              registrationViewModel.goToChooseCityPage(context);
                            },
                            suffixIcon: const Icon(
                              Icons.arrow_forward_ios,
                            ),
                            errorMsg: registrationViewModel.cityErrorMsg,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: CustomButton(
                          onPressed: (){
                            FocusManager.instance.primaryFocus?.unfocus();
                            registrationViewModel.registration(context);
                          },
                          text: 'Регистрация',
                          color: Colors.blue,
                          textColor: Colors.white,
                          isLoading: registrationViewModel.loading,
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
