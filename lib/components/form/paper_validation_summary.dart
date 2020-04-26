import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PaperValidationSummary extends StatelessWidget {
  PaperValidationSummary(this.errors);
  final List<String> errors;
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          children: this
              .errors
              .map((error) => Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
