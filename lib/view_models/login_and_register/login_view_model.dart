import 'package:flutter/material.dart';
import '../../instruments/api.dart';
import '../../views/home_screen.dart';

class LoginViewModel extends ChangeNotifier{
  final ApiService _apiService = ApiService();

  bool _loading = false;
  bool get loading => _loading;

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;
  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  String? _emailErrorMsg;
  String? get emailErrorMsg => _emailErrorMsg;
  String? _passwordErrorMsg;
  String? get passwordErrorMsg => _passwordErrorMsg;

  clearErrorMessages() {
    _emailErrorMsg = null;
    _passwordErrorMsg = null;
    notifyListeners();
  }

  setErrorMessages() {
    _emailErrorMsg = '';
    _passwordErrorMsg = 'Неверный логин или пароль';
    notifyListeners();
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool formIsValid(){
    clearErrorMessages();
    bool isValid = true;
    String? isNull(bool condition){
      if(condition) {
        isValid = false;
        return 'Поле обязательно для заполнения';
      }
      return null;
    }

    _emailErrorMsg = isNull(_emailController.text.isEmpty);
    if(!_emailController.text.contains('@')){
      _emailErrorMsg = 'Неверный формат электронной почты';
    }
    _passwordErrorMsg = isNull(_passwordController.text.isEmpty);
    notifyListeners();
    return isValid;
  }


  void login(BuildContext context) async{
    setLoading(true);
    if(formIsValid()) {
      var response = await _apiService.authenticate(
        _emailController.text,
        _passwordController.text,
      );
      if (response['statusCode'] == 200) {
        if (context.mounted) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => HomeScreen(userId: response['id'],))
          );
        }
      }
      else {
        setErrorMessages();
      }
    }
    setLoading(false);
  }
}