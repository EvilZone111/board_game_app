import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:board_game_app/instruments/constants.dart';
import 'package:board_game_app/screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

//TODO: страница настроек
class _SettingsPageState extends State<SettingsPage> {

  void logout(context) async{
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Выход'),
          content: const Text('Вы уверены, что хотите выйти?'),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                await prefs.remove('id');
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => LoginPage()
                  ),
                );
              },
              child: const Text(
                'Да',
                style: kDialogButtonsTextStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text(
                'Нет',
                style: kDialogButtonsTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки',
          style: kAppBarTextStyle,
        ),
      ),
      body: Padding(
        padding: kFormPadding,
        child: CustomButton(
          onPressed: (){
            logout(context);
          },
          text: 'Выйти из аккаунта',
          color: Colors.red,
          textColor: Colors.white,
        ),
      ),
    );
  }
}


