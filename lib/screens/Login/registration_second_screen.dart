import 'package:board_game_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../instruments/api.dart';
import '../../instruments/components/custom_button.dart';
import '../../instruments/components/custom_form_field.dart';
import '../../instruments/constants.dart';
import 'package:intl/intl.dart';

class RegistrationSecondPage extends StatefulWidget {

  @override
  State<RegistrationSecondPage> createState() => _RegistrationSecondPageState();
}
class _RegistrationSecondPageState extends State<RegistrationSecondPage> {
  var _birthdateController = TextEditingController();
  String? _dateToServer;
  String? _sex;
  String? _sexText;
  var _bioController = TextEditingController();

  bool loadingToggle=false;
  final ApiService _apiService = ApiService();

  Future<void> finish(context) async {
    setState(() {
      loadingToggle = true;
    });
    if( _birthdateController.text.isNotEmpty
        || _sex!=null
        || _bioController.text.isNotEmpty) {
      var response = await _apiService.updateUserInfo(
          _dateToServer,
          _sex,
          _bioController.text.toString());
      if(response['statusCode'] == 200){
        moveToHomeScreen();
      }
    }
    setState(() {
      loadingToggle = false;
    });
  }

  void moveToHomeScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('id')!;
    if (context.mounted){
      Navigator.push( context, MaterialPageRoute(
          builder: (context) => HomeScreen(userId: id)));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          // CustomFormField(
                          //   controller: _cityController,
                          //   textPlaceholder: 'Город',
                          // ),
                          // kHorizontalSizedBoxDivider,
                          CustomFormField(
                            controller: _birthdateController,
                            textPlaceholder: 'Дата рождения',
                            isReadOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2008),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2008)
                              );
                              if (pickedDate!=null){
                                String date = DateFormat('yyyy-MM-dd')
                                    .format(pickedDate);
                                String formattedDate = DateFormat('dd.MM.yyyy')
                                    .format(pickedDate);
                                _dateToServer = date;
                                // String formattedDate = DateFormat('yyyy-MM-dd').
                                setState(() {
                                  _birthdateController.text = formattedDate;
                                });
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
                                hint: _sex == null
                                    ? const Text('Пол')
                                    : Text(_sexText!, style: const TextStyle(color: Colors.white),),
                                underline: const SizedBox(),
                                isExpanded: true,
                                icon: kArrowDownIcon,
                                // dropdownColor: const Color(0xFF454545),
                                elevation: 0,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _sex = value;
                                      _sex == 'U' ? _sexText='Не указывать'
                                          : _sex == 'M' ? _sexText='Мужской'
                                          : _sexText='Женский';
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          kHorizontalSizedBoxDivider,
                          CustomFormField(
                            controller: _bioController,
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
                                setState((){
                                  finish(context);
                                });
                              },
                              text: 'Завершить',
                              color: Colors.blue,
                              textColor: Colors.white,
                              isLoading: loadingToggle,
                            ),
                          ),
                          kHorizontalSizedBoxDivider,
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomButton(
                              onPressed: (){
                                setState((){
                                  moveToHomeScreen();
                                });
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
