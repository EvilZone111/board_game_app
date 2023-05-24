import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:flutter/material.dart';

import '../instruments/constants.dart';

class InternetNotAvailable extends StatelessWidget {

  String title;
  void Function() refresh;

  InternetNotAvailable({required this.title, required this.refresh});
  @override
  Widget build(BuildContext context) {

    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: kAppBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.15,
                ),
                const Text(
                  'Упс!',
                  style: textStyle,
                ),
                SizedBox(
                  height: 200,
                  width: 300,
                  child: Image.asset(
                    'assets/images/offline.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const Text(
                  'Отсутствует подключение к интернету',
                  style: textStyle,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: CustomButton(
                      onPressed: refresh,
                      text: 'Обновить',
                      color: Colors.orange,
                      textColor: Colors.white,
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