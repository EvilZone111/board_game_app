import 'package:flutter/material.dart';

import '../constants.dart';

class IconText extends StatelessWidget {

  final IconData icon;
  final String text;



  IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: kBigIconSize,
              ),
              kVerticalSizedBoxDivider,
              Flexible(
                child: Text(
                  text,
                  style: kEventPageTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
