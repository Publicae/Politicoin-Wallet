import 'package:flutter/material.dart';

class PaperInput extends StatelessWidget {
  PaperInput({
    this.labelText,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.controller,
    this.maxLines,
    this.obscureText = false,
    this.filled = false,
    this.fillColor = Colors.transparent,
    this.style,
  });

  final ValueChanged<String> onChanged;
  final String errorText;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final int maxLines;
  final TextEditingController controller;
  final bool filled;
  final Color fillColor;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: this.obscureText,
      controller: this.controller,
      onChanged: this.onChanged,
      maxLines: this.maxLines,
      style: this.style,
      decoration: InputDecoration(
        labelText: this.labelText,
        labelStyle: TextStyle(color: Color(0xff818181)),
        hintText: this.hintText,
        hintStyle: TextStyle(fontSize: 14, color: Color(0xff818181)),
        errorText: this.errorText,
        filled: this.filled,
        fillColor: this.fillColor,
        contentPadding:
            const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 5.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
