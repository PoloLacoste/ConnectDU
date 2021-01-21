import 'package:flutter/foundation.dart';

class TimerProvider extends ChangeNotifier {
  bool _canCollect;

  bool get canCollect => _canCollect;
  set canCollect(bool collect) {
    _canCollect = true;
    notifyListeners();
  }
}