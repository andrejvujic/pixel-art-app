import 'package:flutter/material.dart';

class SliderInput extends StatefulWidget {
  @override
  _SliderInputState createState() => _SliderInputState();

  final double value, min, max, width;
  final Function onChanged;
  final String labelText;

  SliderInput({
    this.value,
    this.onChanged,
    this.min,
    this.max,
    this.labelText,
    this.width,
  });
}

class _SliderInputState extends State<SliderInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        10.0,
      ),
      margin: EdgeInsets.all(
        10.0,
      ),
      color: Colors.grey[200],
      width: widget.width ?? MediaQuery.of(context).size.width * 0.80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.labelText,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Slider(
            value: widget.value,
            onChanged: (
              double _value,
            ) =>
                widget.onChanged?.call(
              _value,
            ),
            min: widget.min,
            max: widget.max,
          ),
        ],
      ),
    );
  }
}
