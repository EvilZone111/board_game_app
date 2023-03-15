import 'package:flutter/material.dart';

import '../constants.dart';

class ProfileCard extends StatelessWidget {
  Widget content;
  double? height;

  ProfileCard({required this.content, this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: kDefaultBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: content,
          ),
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}
