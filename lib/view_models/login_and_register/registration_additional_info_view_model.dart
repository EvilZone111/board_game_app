import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../instruments/api.dart';
import '../../views/home_screen.dart';

class RegistrationAdditionalInfoViewModel extends ChangeNotifier{
  final ApiService _apiService = ApiService();

  bool _loading = false;
  bool get loading => _loading;

  final _birthdateController = TextEditingController();
  TextEditingController get birthdateController => _birthdateController;
  String? _sexFullText;
  String? get sexFullText => _sexFullText;
  final _bioController = TextEditingController();
  TextEditingController get bioController => _bioController;

  String? _dateToServer;
  String? _sex;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void fillBirthdate(DateTime pickedDate) {
    String date = DateFormat('yyyy-MM-dd').format(pickedDate);
    String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
    _dateToServer = date;
    _birthdateController.text = formattedDate;
    notifyListeners();
  }

  void chooseSex(value) {
    _sex = value;
    _sex == 'U' ? _sexFullText = 'Не указывать'
        : _sex == 'M' ? _sexFullText = 'Мужской'
        : _sexFullText = 'Женский';
    notifyListeners();
  }

  void moveToHomeScreen(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('id')!;
    if (context.mounted){
      Navigator.push( context, MaterialPageRoute(
          builder: (context) => HomeScreen(userId: id)));
    }
  }

  bool isSomethingFilled(){
    if( _dateToServer != null || _sex != null || _bioController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> finish(context) async {
    setLoading(true);
    if(isSomethingFilled()) {
      var response = await _apiService.updateUserInfo(
          _dateToServer,
          _sex,
          _bioController.text.toString());
      if(response['statusCode'] == 200){
        moveToHomeScreen(context);
      }
    }
    setLoading(false);
  }
}