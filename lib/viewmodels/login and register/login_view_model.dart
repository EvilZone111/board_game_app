import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../instruments/api.dart';

class LoginViewModel extends ChangeNotifier{
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
}