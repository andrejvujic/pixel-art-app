import 'package:flutter/material.dart';
import 'package:pixel_art_app/screens/canvas/paint_settings.dart';
import 'package:provider/provider.dart';

class BoardBlock extends StatefulWidget {
  @override
  _BoardBlockState createState() => _BoardBlockState();

  final int columnIndex, rowIndex;
  final double horizontalBlockSize, verticalBlockSize;
  final Function setBlockInformationProperty;
  final Map<String, dynamic> blockInformation;
  final bool canEditBlockProperties;
  BoardBlock({
    this.columnIndex,
    this.rowIndex,
    this.horizontalBlockSize,
    this.verticalBlockSize,
    this.setBlockInformationProperty,
    this.blockInformation,
    this.canEditBlockProperties = true,
  });
}

class _BoardBlockState extends State<BoardBlock> {
  String _position;
  Color _blockColor;

  @override
  void initState() {
    super.initState();
    _position = _getPosition(
      widget.columnIndex,
      widget.rowIndex,
    );

    _blockColor = (widget.blockInformation.length == 0)
        ? Color.fromARGB(255, 255, 255, 255)
        : Color.fromARGB(
            widget.blockInformation[_position]['color']['alpha'],
            widget.blockInformation[_position]['color']['red'],
            widget.blockInformation[_position]['color']['green'],
            widget.blockInformation[_position]['color']['blue'],
          );
  }

  String _getPosition(
    int columnIndex,
    int row,
  ) =>
      '$columnIndex-$row';

  void _setBlockColor(Color _color) => setState(() => _blockColor = _color);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaintSettings>(
      builder: (context, value, child) {
        return FlatButton(
          key: Key(
            _position,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minWidth: widget.horizontalBlockSize,
          height: widget.verticalBlockSize,
          padding: EdgeInsets.all(
            0.0,
          ),
          onPressed: (widget.canEditBlockProperties)
              ? () {
                  if (value.enableColorPicker) {
                    value.setColor(_blockColor ?? value.color);
                    return;
                  }

                  _setBlockColor(
                    value.color,
                  );
                  widget.setBlockInformationProperty(
                    _getPosition(widget.columnIndex, widget.rowIndex),
                    'color',
                    value.color,
                  );
                }
              : () {},
          child: Container(
            decoration: BoxDecoration(
              color: _blockColor,
              border: (value.showBorders)
                  ? Border.all(
                      color: Colors.black,
                    )
                  : null,
            ),
            width: widget.horizontalBlockSize,
            height: widget.verticalBlockSize,
            child: Text(''),
          ),
        );
      },
    );
  }
}
