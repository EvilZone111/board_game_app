import 'package:flutter/material.dart';

import '../constants.dart';

class CustomFormField extends StatefulWidget {

  final TextEditingController controller;
  final String textPlaceholder;
  bool isPassword;
  String? Function(String?)? validator;
  String? errorMsg;
  VoidCallback? onTap;
  bool isReadOnly;
  int maxLines;
  TextInputType? keyboardType;

  CustomFormField({
    required this.controller,
    required this.textPlaceholder,
    this.validator,
    this.errorMsg,
    this.isPassword=false,
    this.onTap,
    this.isReadOnly=false,
    this.maxLines=1,
    this.keyboardType,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.isPassword,
        controller: widget.controller,
        readOnly: widget.isReadOnly,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.textPlaceholder,
          contentPadding: const EdgeInsets.all(15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: const BorderSide(
                color: Colors.white,
                width: 2.0
            ),
          ),
          errorText: widget.errorMsg,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFF454545),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
