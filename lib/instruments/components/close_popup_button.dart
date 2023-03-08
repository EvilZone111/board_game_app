import 'package:flutter/material.dart';

import '../constants.dart';

class ClosePopupButton extends StatelessWidget {

  VoidCallback onTap;

  ClosePopupButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: const BoxDecoration(
              color: kDefaultButtonColor,
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(
                Icons.close,
                size: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
