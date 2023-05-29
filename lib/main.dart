import 'package:board_game_app/instruments/helpers.dart';
import 'package:board_game_app/view_models/login_and_register/login_view_model.dart';
import 'package:board_game_app/view_models/login_and_register/registration_additional_info_view_model.dart';
import 'package:board_game_app/view_models/login_and_register/registration_view_model.dart';
import 'package:board_game_app/views/login_and_register/login_view.dart';
import 'package:board_game_app/views/login_and_register/registration_sadditional_info_view.dart';
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
      ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
      ChangeNotifierProvider(create: (_) => RegistrationAdditionalInfoViewModel()),
    ],
    child: MaterialApp(
      home: token==null ? LoginView() : HomeScreen(userId: id!,),
      //home: RegistrationSecondPage(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/registration_second_screen': (context)=>RegistrationAdditionalInfoView(),
        // '/event_page' : (context)=>EventPage(),
      },
    ),
  ));
}


