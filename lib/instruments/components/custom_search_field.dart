import 'package:flutter/material.dart';

import '../constants.dart';

class CustomSearchField extends StatefulWidget {

  Function onTextChanged;
  final String hint;
  bool readOnly;
  VoidCallback? onTap;
  TextEditingController? controller;
  Icon? suffixIcon;
  String? errorMsg;
  double height ;

  CustomSearchField({
    required this.onTextChanged,
    required this.hint,
    this.readOnly=false,
    this.onTap,
    this.controller,
    this.suffixIcon,
    this.errorMsg,
    this.height= 70,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextField(
        onChanged: (text){
          setState(() {
            widget.onTextChanged(text);
          });
        },
        controller: widget.controller,
        onTap: widget.onTap,
        autofocus: false,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide.none,
          ),
          errorText: widget.errorMsg,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.all(15.0),
          filled: true,
          fillColor: const Color(0xFF454545),
          suffixIcon: widget.suffixIcon,
          suffixIconColor: Colors.white,
        ),
      ),
    );
  }
}