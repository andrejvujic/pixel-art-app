import 'package:flutter/material.dart';
import 'package:pixel_art_app/screens/canvas/board/board_block.dart';

class BoardRow extends StatefulWidget {
  @override
  _BoardRowState createState() => _BoardRowState();

  final int rows, columnIndex;
  final double horizontalBlockSize, verticalBlockSize;
  final Map<String, dynamic> blockInformation;
  final Function setBlockInformationProperty;
  final bool canEditBlockProperties;

  BoardRow({
    this.rows,
    this.columnIndex,
    this.horizontalBlockSize,
    this.verticalBlockSize,
    this.blockInformation,
    this.setBlockInformationProperty,
    this.canEditBlockProperties = true,
  });
}

class _BoardRowState extends State<BoardRow> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _getRowBlocks(
    int columnIndex,
    int rows,
    double horizontalBlockSize,
    double verticalBlockSize,
    Map<String, dynamic> blockInformation,
    Function setBlockInformationProperty,
    bool canEditBlockProperties,
  ) {
    List<Widget> _rowBlocks = <Widget>[];
    for (int i = 0; i < rows; i++) {
      _rowBlocks.add(
        Container(
          key: Key('board-block-$columnIndex-$i'),
          child: BoardBlock(
            columnIndex: columnIndex,
            rowIndex: i,
            horizontalBlockSize: horizontalBlockSize,
            verticalBlockSize: verticalBlockSize,
            blockInformation: widget.blockInformation,
            setBlockInformationProperty: setBlockInformationProperty,
            canEditBlockProperties: canEditBlockProperties,
          ),
        ),
      );
    }
    return _rowBlocks;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: _getRowBlocks(
      widget.columnIndex,
      widget.rows,
      widget.horizontalBlockSize,
      widget.verticalBlockSize,
      widget.blockInformation,
      widget.setBlockInformationProperty,
      widget.canEditBlockProperties,
    ));
  }
}
