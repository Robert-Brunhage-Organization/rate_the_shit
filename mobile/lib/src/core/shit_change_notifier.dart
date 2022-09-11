import 'package:flutter/foundation.dart';

class ShitChangeNotifier extends ChangeNotifier {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void setBusy([bool value = true]) {
    _isBusy = value;
    notifyListeners();
  }
}
