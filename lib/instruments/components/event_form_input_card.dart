import 'package:flutter/material.dart';

import '../constants.dart';
// import 'custom_search_field.dart';

class EventFormInputCard extends StatefulWidget {

  int number;
  String text;
  Widget childWidget;

  EventFormInputCard({required this.number, required this.text, required this.childWidget});

  @override
  State<EventFormInputCard> createState() => _EventFormInputCardState();
}

class _EventFormInputCardState extends State<EventFormInputCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              child: Text(
                '${widget.number}',
                style: kTextStyle,
              ),
            ),
            kVerticalSizedBoxDivider,
            Flexible(
              child: Text(
                widget.text,
                style: kTextStyle,
              ),
            ),
          ],
        ),
        kHorizontalSizedBoxDivider,
        widget.childWidget,
      ],
    );
  }
}

class TextInCard extends StatelessWidget {
  String text;
  TextInCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Text(text, style: kTextStyle),
    );
  }
}


