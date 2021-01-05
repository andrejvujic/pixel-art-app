import 'package:flutter/material.dart';
import 'package:pixel_art_app/screens/canvas/canvas.dart';
import 'package:pixel_art_app/screens/route_builders/slide.dart';
import 'package:pixel_art_app/widgets/alerts/info_alert.dart';
import 'package:pixel_art_app/widgets/buttons/solid_button.dart';
import 'package:pixel_art_app/widgets/slider_input/slider_input.dart';
import 'package:pixel_art_app/widgets/text_input/text_input.dart';

class CreatePixelArtCanvas extends StatefulWidget {
  @override
  _CreatePixelArtCanvasState createState() => _CreatePixelArtCanvasState();
}

class _CreatePixelArtCanvasState extends State<CreatePixelArtCanvas> {
  String _pixelArtProjectName = 'New Pixel Art';
  double _columnNumber = 4.0,
      _rowNumber = 4.0,
      _maxColumns = 20.0,
      _maxRows = 20.0;

  void _createCanvas(
    double _columns,
    double _rows,
    String _name,
  ) async {
    if (_name.isEmpty) {
      InfoAlert(
        title: 'Oops...',
        text:
            "It looks like you haven't entered a Pixel Art name. Please enter a name and try again.",
      ).showAlert(context);
    } else if (_name.length > 30) {
      InfoAlert(
        title: 'Hm...',
        text:
            "It looks like your choosen name exceedes the limit of 30 letters. Please think of a shorter name.",
      ).showAlert(context);
    } else {
      Navigator.pushReplacement(
        context,
        buildSlideRoute(
          PixelArtCanvas(
            columns: _columns.toInt(),
            rows: _rows.toInt(),
            appBarText: _name,
            initialId: '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pixelArtProjectName),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            color: Colors.deepPurple,
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(
                  16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextInput(
                      initialValue: _pixelArtProjectName,
                      labelText: 'Pixel Art name',
                      helperText: 'Enter a name',
                      hintText: 'Enter a name',
                      maxLength: 30,
                      onChanged: (String _value) =>
                          setState(() => _pixelArtProjectName = _value),
                    ),
                    /*
                    SliderInput(
                      value: _columnNumber,
                      min: 4.0,
                      max: _maxColumns,
                      labelText: (_columnNumber == 1)
                          ? '${_columnNumber.toInt()} column'
                          : '${_columnNumber.toInt()} columns',
                      onChanged: (double _value) => setState(
                        () {
                          _columnNumber = _value;
                          _rowNumber = _value;
                        },
                      ),
                    ),
                    SliderInput(
                      value: _rowNumber,
                      min: 4.0,
                      max: _maxRows,
                      labelText: (_rowNumber == 1)
                          ? '${_rowNumber.toInt()} row'
                          : '${_rowNumber.toInt()} rows',
                      onChanged: (double _value) => setState(
                        () {
                          _columnNumber = _value;
                          _rowNumber = _value;
                        },
                      ),
                    ),
                    */
                    SliderInput(
                      value: _rowNumber ?? _columnNumber,
                      min: 4.0,
                      max: _maxRows ?? _maxColumns,
                      labelText:
                          '${_rowNumber.toInt()} x ${_columnNumber.toInt()}',
                      onChanged: (double _value) => setState(
                        () {
                          _columnNumber = _value;
                          _rowNumber = _value;
                        },
                      ),
                    ),
                    SolidButton(
                      margin: EdgeInsets.all(
                        50.0,
                      ),
                      child: Text(
                        'Start Drawing',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () => _createCanvas(
                        _columnNumber,
                        _rowNumber,
                        _pixelArtProjectName,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
