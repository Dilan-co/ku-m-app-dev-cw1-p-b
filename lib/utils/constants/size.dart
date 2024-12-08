import 'package:flutter/material.dart';

class CFGSize {
  static double bodyLRPadding = 20;
  static double bodyTBPadding = 10;
  static double buttonRadius = 8;
  static double tileRadius = 15;

  void init(BuildContext context) {
    bodyLRPadding = MediaQuery.of(context).size.width * 0.04;
    debugPrint('bodyLRPadding: $bodyLRPadding');
  }
}
