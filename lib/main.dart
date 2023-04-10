import 'package:board_game_app/instruments/helpers.dart';
import 'package:board_game_app/views/login and register/login_screen.dart';
import 'package:board_game_app/views/login and register/registration_second_screen.dart';
import 'package:board_game_app/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await getToken();
  SharedPreferences pref = await SharedPreferences.getInstance();
  int? id = pref.getInt('id');
  runApp(MaterialApp(
    home: token==null ? LoginPage() : HomeScreen(userId: id!,),
    //home: RegistrationSecondPage(),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    routes: {
      '/registration_second_screen': (context)=>RegistrationSecondPage(),
      // '/event_page' : (context)=>EventPage(),
    },
    //
    // onGenerateRoute: (settings) {
    //   // If you push the PassArguments route
    //   if (settings.name == EventPage.routeName) {
    //     // Cast the arguments to the correct
    //     // type: ScreenArguments.
    //     final args = settings.arguments as Event;
    //
    //     // Then, extract the required data from
    //     // the arguments and pass the data to the
    //     // correct screen.
    //     return MaterialPageRoute(
    //       builder: (context) {
    //         return EventPage(
    //           event: args,
    //         );
    //       },
    //     );
    //   }
    //   return null;
    // },
  ));
}


