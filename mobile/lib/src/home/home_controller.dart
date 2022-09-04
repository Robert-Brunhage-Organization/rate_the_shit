import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeControllerProvider = ChangeNotifierProvider((ref) => HomeController());

class HomeController extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
