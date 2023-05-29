import 'package:flutter/material.dart';
import '../../instruments/api.dart';
import '../../models/errors_model.dart';
import '../../views/choose_city_screen.dart';
import '../../views/home_screen.dart';

class RegistrationViewModel extends ChangeNotifier{
  final ApiService _apiService = ApiService();

  bool _loading = false;
  bool get loading => _loading;

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;
  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;
  final _confirmPasswordController = TextEditingController();
  TextEditingController get confirmPasswordController => _confirmPasswordController;
  final _firstNameController = TextEditingController();
  TextEditingController get firstNameController => _firstNameController;
  final _lastNameController = TextEditingController();
  TextEditingController get lastNameController => _lastNameController;
  final _cityController = TextEditingController();
  TextEditingController get cityController => _cityController;
  late int _cityId;

  String? _emailErrorMsg;
  String? get emailErrorMsg => _emailErrorMsg;
  String? _passwordErrorMsg;
  String? get passwordErrorMsg => _passwordErrorMsg;
  String? _confirmPasswordErrorMsg;
  String? get confirmPasswordErrorMsg => _confirmPasswordErrorMsg;
  String? _firstNameErrorMsg;
  String? get firstNameErrorMsg => _firstNameErrorMsg;
  String? _lastNameErrorMsg;
  String? get lastNameErrorMsg => _lastNameErrorMsg;
  String? _cityErrorMsg;
  String? get cityErrorMsg => _cityErrorMsg;

  void clearErrorMessages() {
    _emailErrorMsg = null;
    _passwordErrorMsg = null;
    _confirmPasswordErrorMsg = null;
    _firstNameErrorMsg = null;
    _lastNameErrorMsg = null;
    _cityErrorMsg = null;
  }

  void setErrorMessages(Errors errors) {
    if(errors.email!=null){
      _emailErrorMsg = errors.email![0];
    }
    if(errors.password!=null){
      _passwordErrorMsg = errors.password![0];
    }
    if(errors.confirm_password!=null){
      _confirmPasswordErrorMsg = errors.confirm_password![0];
    }
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void goToChooseCityPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseCityPage(),
        )
    );
    if(result!=null) {
      _cityController.text = result['city'];
      _cityId = result['id'];
      notifyListeners();
    }
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
      return false;
    }
    _passwordErrorMsg = isNull(_passwordController.text.isEmpty);
    _confirmPasswordErrorMsg = isNull(_confirmPasswordController.text.isEmpty);
    _firstNameErrorMsg = isNull(_firstNameController.text.isEmpty);
    _lastNameErrorMsg = isNull(_lastNameController.text.isEmpty);
    _cityErrorMsg = isNull(_cityController.text.isEmpty);
    notifyListeners();
    return isValid;
  }

  void registration(BuildContext context) async {
    setLoading(true);
    if(formIsValid()) {
      var response = await _apiService.register(
          _emailController.text,
          _passwordController.text,
          _confirmPasswordController.text,
          _firstNameController.text,
          _lastNameController.text,
          _cityController.text,
          _cityId
      );
      if (response == 200) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(
              context, '/registration_second_screen');
        }
      }
      else {
        Errors errors = Errors.fromJson(response);
        setErrorMessages(errors);
      }
    }
    setLoading(false);
  }
}