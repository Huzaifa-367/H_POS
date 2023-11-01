import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VisibilityProvider with ChangeNotifier {
  bool _isReportVisible = false;

  bool get isReportVisible => _isReportVisible;

  toggleVisibility() {
    _isReportVisible = !_isReportVisible;
    notifyListeners();
    // print("is visible:$_isReportVisible");
    // return _isReportVisible; // Return the new visibility state
  }
}

