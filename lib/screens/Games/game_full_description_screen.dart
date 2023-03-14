import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../instruments/constants.dart';

class GameFullDescriptionPage extends StatelessWidget {
  String description;
  String bggUrl;

  GameFullDescriptionPage({required this.description, required this.bggUrl});

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
            child: Column(
              children: [
                Text(
                  description,
                  style: kTextStyle,
                ),
                kWideHorizontalSizedBoxDivider,
                Link(
                  uri: Uri.parse(bggUrl),
                  builder: (_, followLink) {
                    return  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: followLink,
                      child: Row(
                        children: const [
                          Text(
                            'Страница игры на BoardGameGeek.com',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
