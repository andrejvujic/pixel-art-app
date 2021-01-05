import 'package:flutter/material.dart';
import 'package:pixel_art_app/screens/canvas/paint_settings.dart';
import 'package:pixel_art_app/widgets/color_chooser/color_chooser.dart';
import 'package:provider/provider.dart';

class CurrentColor extends StatefulWidget {
  @override
  _CurrentColorState createState() => _CurrentColorState();
}

class _CurrentColorState extends State<CurrentColor> {
  String _getRGBFormat(Color _color) {
    return 'rgba(${_color.red}, ${_color.green}, ${_color.blue}, ${_color.alpha})';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaintSettings>(
      builder:
          (BuildContext context, PaintSettings _paintSettings, Widget _child) {
        return Row(
          children: <Widget>[
            FlatButton(
              minWidth: 0.0,
              padding: EdgeInsets.all(
                0.0,
              ),
              onPressed: () => ColorChooser().show(
                context,
                (Color _color) {
                  _paintSettings.setColor(_color);
                },
              ),
              child: Container(
                margin: EdgeInsets.only(right: 5.0),
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: _paintSettings.color,
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Text(
              _getRGBFormat(
                _paintSettings.color,
              ),
              style: TextStyle(
                fontSize: 20.0,
              ),
            )
          ],
        );
      },
    );
  }
}
