import 'package:board_game_app/instruments/helpers.dart';
import 'package:board_game_app/viewmodels/login%20and%20register/login_view_model.dart';
import 'package:board_game_app/views/login and register/login_screen.dart';
import 'package:board_game_app/views/login and register/registration_second_screen.dart';
import 'package:board_game_app/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await getToken();
  SharedPreferences pref = await SharedPreferences.getInstance();
  int? id = pref.getInt('id');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
    ],
    child: MaterialApp(
      home: token==null ? LoginPage() : HomeScreen(userId: id!,),
      //home: RegistrationSecondPage(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/registration_second_screen': (context)=>RegistrationSecondPage(),
        // '/event_page' : (context)=>EventPage(),
      },
    ),
  ));
}


