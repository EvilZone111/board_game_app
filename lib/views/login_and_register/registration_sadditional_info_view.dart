import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../instruments/components/custom_button.dart';
import '../../instruments/components/custom_form_field.dart';
import '../../instruments/constants.dart';
import '../../view_models/login_and_register/registration_additional_info_view_model.dart';

class RegistrationAdditionalInfoView extends StatefulWidget {

  @override
  State<RegistrationAdditionalInfoView> createState() => _RegistrationAdditionalInfoViewState();
}
class _RegistrationAdditionalInfoViewState extends State<RegistrationAdditionalInfoView> {

  @override
  Widget build(BuildContext context) {
    RegistrationAdditionalInfoViewModel registrationAdditionalInfoViewModel = Provider.of<RegistrationAdditionalInfoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дополнительная информация'),
      ),
      body: SafeArea(
        child: Padding(
          padding: kFormPadding,
          child: Form(
            // key: _formKey,
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
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: registrationAdditionalInfoViewModel.birthdateController,
                            textPlaceholder: 'Дата рождения',
                            isReadOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2008),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2008)
                              );
                              if(pickedDate!=null){
                                registrationAdditionalInfoViewModel.fillBirthdate(pickedDate);
                              }
                            },
                          ),
                          kHorizontalSizedBoxDivider,
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF454545),
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            height: 49.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: DropdownButton<String>(
                                items: const [
                                  DropdownMenuItem(
                                    value: 'U',
                                    child: Text('Не указывать'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'M',
                                    child: Text('Мужской'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'F',
                                    child: Text('Женский'),
                                  ),
                                ],
                                hint: registrationAdditionalInfoViewModel.sexFullText == null
                                    ? const Text('Пол')
                                    : Text(
                                        registrationAdditionalInfoViewModel.sexFullText!,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                underline: const SizedBox(),
                                isExpanded: true,
                                icon: kArrowDownIcon,
                                elevation: 0,
                                onChanged: registrationAdditionalInfoViewModel.chooseSex,
                              ),
                            ),
                          ),
                          kHorizontalSizedBoxDivider,
                          CustomFormField(
                            controller: registrationAdditionalInfoViewModel.bioController,
                            textPlaceholder: 'Расскажите о себе',
                            maxLines: 1,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: CustomButton(
                              onPressed: (){
                                registrationAdditionalInfoViewModel.finish(context);
                              },
                              text: 'Завершить',
                              color: Colors.blue,
                              textColor: Colors.white,
                              isLoading: registrationAdditionalInfoViewModel.loading,
                            ),
                          ),
                          kHorizontalSizedBoxDivider,
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomButton(
                              onPressed: (){
                                registrationAdditionalInfoViewModel.moveToHomeScreen(context);
                              },
                              text: 'Заполнить позднее',
                              color: Colors.white,
                              textColor: Colors.black,
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 16.0,
                              ),
                            ),
                          ),
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
