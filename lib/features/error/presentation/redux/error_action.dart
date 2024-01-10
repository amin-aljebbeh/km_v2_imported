import 'package:flutter/material.dart';

class NoError {}

class CatchError {
  final String errorMessage;
  final String reason;
  final bool viewError;
   Color errorColor;

  CatchError({ this.viewError = true, this.reason, this.errorMessage}) {
    errorColor =  Colors.green;
  }
}