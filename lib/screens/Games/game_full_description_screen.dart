import 'package:flutter/material.dart';

import '../../instruments/constants.dart';

class GameFullDescriptionPage extends StatelessWidget {
  String description;

  GameFullDescriptionPage({required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Описание',
          style: kAppBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: kDefaultPagePadding,
            child: Text(
              description,
              style: kTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
