import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatefulWidget {

  final VoidCallback onPressed;
  String text;
  final Color color;
  Color textColor;
  bool isLoading;
  Widget? icon;

  CustomButton({required this.onPressed, required this.text,
    required this.color, required this.textColor, this.isLoading=false, this.icon});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46.0,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(widget.color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            )
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: widget.isLoading==false ? Stack(
            children: [
              Align(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                  ),
                ),
              ),
              if(widget.icon!=null)
                Positioned(right: 0, child: widget.icon!)
            ],
          ) :
          const SizedBox(
            height: 16.0,
            width: 16.0,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        )
      ),
    );
  }
}
