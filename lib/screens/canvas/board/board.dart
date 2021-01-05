import 'package:flutter/material.dart';
import 'package:pixel_art_app/screens/canvas/board/board_row.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();

  final double width, height;
  final int rows, columns;
  final Map<String, dynamic> blockInformation;
  final Function setBlockInformationProperty;
  final bool canEditBlockProperties;
  Board({
    this.width,
    this.height,
    this.rows,
    this.columns,
    this.blockInformation,
    this.setBlockInformationProperty,
    this.canEditBlockProperties = true,
  });
}

class _BoardState extends State<Board> {
  double horizontalBlockSize, verticalBlockSize;

  void _getBoardBlockSize(
    double width,
    int rows,
    double height,
    int columns,
  ) {
    setState(() {
      horizontalBlockSize = width / rows;
      verticalBlockSize = height / columns;
    });
  }

  List<Widget> _getBoardRows(
    int columns,
    Map<String, dynamic> blockInformation,
    Function _setBlockInformationProperty,
    bool _canEditBlockProperties,
  ) {
    List<Widget> _boardRows = <Widget>[];
    for (int i = 0; i < columns; i++) {
      _boardRows.add(
        Container(
          key: Key('board-row-$i'),
          child: BoardRow(
            rows: widget.rows,
            columnIndex: i,
            horizontalBlockSize: horizontalBlockSize,
            verticalBlockSize: verticalBlockSize,
            blockInformation: blockInformation,
            setBlockInformationProperty: _setBlockInformationProperty,
            canEditBlockProperties: _canEditBlockProperties,
          ),
        ),
      );
    }

    return _boardRows;
  }

  @override
  void initState() {
    _getBoardBlockSize(
      widget.width,
      widget.rows,
      widget.height,
      widget.columns,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _getBoardRows(
        widget.columns,
        widget.blockInformation,
        widget.setBlockInformationProperty,
        widget.canEditBlockProperties,
      ),
    );
  }
}
