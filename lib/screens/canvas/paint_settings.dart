import 'package:flutter/material.dart';

class PaintSettings extends ChangeNotifier {
  Color color = Colors.deepPurple;
  Color defaultColor = Colors.white;
  bool showBorders = true;
  bool enableColorPicker = false;

  void setColor(Color _newColor) {
    color = _newColor;
    notifyListeners();
  }

  void resetColor() {
    color = defaultColor;
    notifyListeners();
  }

  void setShowBorders(bool _newShowBordersValue) {
    showBorders = _newShowBordersValue;
    notifyListeners();
  }

  void setEnableColorPicker(bool _newEnableColorPickerValue) {
    enableColorPicker = _newEnableColorPickerValue;
    notifyListeners();
  }
}
