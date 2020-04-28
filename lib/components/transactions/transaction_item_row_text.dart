import 'package:flutter/material.dart';

class TransactionItemRowText extends StatelessWidget {

  const TransactionItemRowText({Key key, this.title, this.color, this.fontSize, this.height}) : super(key: key);

  final String title;
  final Color color;
  final double fontSize;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
            ),
          ),
        ),
      );
}
