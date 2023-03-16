import 'package:board_game_app/instruments/constants.dart';
import 'package:board_game_app/screens/Events/Create%20Event/create_event_screen.dart';
import 'package:board_game_app/screens/Events/Search%20Events/search_events_screen.dart';
import 'package:flutter/material.dart';
import '../../instruments/components/custom_button.dart';

class MainEventsPage extends StatefulWidget {
  const MainEventsPage({Key? key}) : super(key: key);
  static const String id = 'events_page';

  @override
  State<MainEventsPage> createState() => _MainEventsPageState();
}

class _MainEventsPageState extends State<MainEventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мероприятия'),
      ),
      body: Padding(
        padding: kDefaultPagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.people,
            // ),
            CustomButton(
              onPressed: () {
                Navigator.push( context, MaterialPageRoute(
                    builder: (context) => SearchEventsPage()
                ));
              },
              text: 'Найти',
              textColor: Colors.white,
              color: Colors.blue,
            ),
            kHorizontalSizedBoxDivider,
            // kWideVerticalSizedBoxDivider,
            // Row(
            //   children: const [
            //     Expanded(
            //       child: Divider(
            //         thickness: 3.0,
            //         endIndent: 10.0,
            //       ),
            //     ),
            //     Text(
            //       "ИЛИ",
            //       style: kTextStyle,
            //     ),
            //     Expanded(
            //       child: Divider(
            //         thickness: 3.0,
            //         indent: 10.0,
            //       ),
            //     ),
            //   ],
            // ),
            // kWideVerticalSizedBoxDivider,
            CustomButton(
              onPressed: () {
                Navigator.push( context, MaterialPageRoute(
                    builder: (context) => CreateEventScreen()
                ));
              },
              text: 'Создать',
              textColor: Colors.black,
              color: Colors.white,
            ),
          ],
        ),
      ),
      // body: ElevatedButton(
      //   onPressed: () {
      //     Navigator.push( context, MaterialPageRoute(
      //         builder: (context) => SearchGamesPage()
      //     ));
      //   },
      //   child: Text('test'),
      // ),
    );
  }
}
