import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String kboyText = 'KBOY';

  void changeKboyText() {
    kboyText = 'kboyさんかっこいい！！！';
    notifyListeners();
  }
}
