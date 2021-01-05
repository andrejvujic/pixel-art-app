import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pixel_art_app/services/database/database_service.dart';
import 'package:pixel_art_app/widgets/alerts/info_alert.dart';
import 'package:pixel_art_app/widgets/alerts/input_alert.dart';
import 'package:pixel_art_app/widgets/text_input/text_input.dart';
import 'package:provider/provider.dart';
import 'package:pixel_art_app/screens/canvas/board/board.dart';
import 'package:pixel_art_app/screens/canvas/paint_settings.dart';
import 'package:pixel_art_app/widgets/buttons/solid_button.dart';
import 'package:pixel_art_app/widgets/color_chooser/current_color.dart';

class PixelArtCanvas extends StatefulWidget {
  @override
  _PixelArtCanvasState createState() => _PixelArtCanvasState();

  final Color scaffoldColor;
  final double width, height;
  final int rows, columns;
  final String appBarText, initialId;
  final Map<String, dynamic> initialBlockInformation;
  PixelArtCanvas({
    this.scaffoldColor = Colors.white,
    this.appBarText = 'New Pixel Art',
    this.initialId = 'initial-drawing-id',
    this.width = 0.0,
    this.height = 0.0,
    this.rows = 4,
    this.columns = 4,
    this.initialBlockInformation = const {},
  });
}

class _PixelArtCanvasState extends State<PixelArtCanvas>
    with WidgetsBindingObserver {
  TextEditingController _controller = TextEditingController();

  Map<String, dynamic> _blockInformation;
  String _drawingId, _drawingName;
  DatabaseService dbService = DatabaseService(
    uid: FirebaseAuth.instance.currentUser.uid,
  );
  bool _isLoading = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print('[AppLifecycleState] Active');
    } else if (state == AppLifecycleState.inactive) {
      print('[AppLifecycleState] Inactive');
      await _saveToCloud(
        widget.appBarText,
        widget.columns,
        widget.rows,
        FirebaseAuth.instance.currentUser.uid,
        _drawingId,
        _blockInformation,
        null,
        null,
        null,
        saveNewId: false,
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _drawingName = widget.appBarText;

    _drawingId = (widget.initialId.length == 0)
        ? 'initial-drawing-id'
        : widget.initialId;

    _blockInformation = (widget.initialBlockInformation.length == 0)
        ? _setUpBlockInformation(
            widget.columns,
            widget.rows,
          )
        : widget.initialBlockInformation;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _setLoaderState(bool _value) => setState(() => _isLoading = _value);

  Map<String, dynamic> _setUpBlockInformation(
    int rows,
    int columns,
  ) {
    Map<String, dynamic> _blockInformation = {};
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        _blockInformation['$i-$j'] = {
          'color': {
            'red': 255,
            'green': 255,
            'blue': 255,
            'alpha': 255,
          },
        };
      }
    }
    return _blockInformation;
  }

  void _setBlockInformationProperty(
    String _position,
    String _property,
    Color _value,
  ) {
    if (_blockInformation.containsKey(_position)) {
      if (_blockInformation[_position].containsKey(_property)) {
        if (_property == 'color') {
          final int red = _value.red,
              green = _value.green,
              blue = _value.blue,
              alpha = _value.alpha;
          final _colorRGBA = {
            'red': red,
            'green': green,
            'blue': blue,
            'alpha': alpha
          };
          _blockInformation[_position][_property] = _colorRGBA;
        } else {
          _blockInformation[_position][_property] = _value;
        }
      }
    }
  }

  void _showSaveFailedAlert() => InfoAlert(
        title: 'Oops...',
        text:
            'It looks like there was an error while trying to save your drawing. Please try again later.',
      ).showAlert(context);

  Future<void> _saveToCloud(
    String _name,
    int _columns,
    int _rows,
    String _authorUid,
    String _currentDrawingId,
    Map _blockInformation,
    Function _showSaveFailedAlert,
    Function _onStarted,
    Function _onFinished, {
    bool saveNewId = true,
  }) async {
    _onStarted?.call();
    try {
      final String _newDrawingId = await dbService.addDrawing(_name, _columns,
          _rows, _authorUid, _currentDrawingId, _blockInformation);
      if (saveNewId) setState(() => _drawingId = _newDrawingId);
    } catch (e) {
      _showSaveFailedAlert?.call();
    }
    _onFinished?.call();
  }

  void _renameDrawing(
    String _drawingId,
    String _currentDrawingName,
    TextEditingController _controller,
  ) {
    _controller.text = _currentDrawingName;

    InputAlert(
        title: 'Rename drawing',
        children: <Widget>[
          TextInput(
            controller: _controller,
            labelText: 'Pixel Art name',
            helperText: 'Enter a name',
            hintText: 'Enter a name',
            maxLength: 30,
          ),
        ],
        buttonText: 'CONFIRM',
        onButtonPressed: () async {
          _setLoaderState(true);

          if (_controller.text.isEmpty) {
            InfoAlert(
              title: 'Oops...',
              text:
                  "It looks like you haven't entered a Pixel Art name. Please enter a name and try again.",
            ).showAlert(context);
          } else if (_controller.text.length > 30) {
            InfoAlert(
              title: 'Hm...',
              text:
                  "It looks like your choosen name exceedes the limit of 30 letters. Please think of a shorter name.",
            ).showAlert(context);
          } else {
            if (await dbService.setDrawingProperty(
                'name', _controller.text, _drawingId)) {
              InfoAlert(
                      title: 'Success',
                      text:
                          'The drawing was successfully renamed to ${_controller.text}.')
                  .showAlert(context);

              setState(
                () => _drawingName = _controller.text,
              );
            } else {
              InfoAlert(
                      title: 'Oops...',
                      text:
                          'We ran into an error while renaming your drawing. Please try again later.')
                  .showAlert(context);
            }
          }

          _setLoaderState(false);
        }).showAlert(context);
  }

  double _getWidth() =>
      (widget.width > 0.0) ? widget.width : MediaQuery.of(context).size.width;
  double _getHeight() => (widget.height > 0.0)
      ? widget.height
      : MediaQuery.of(context).size.height;

  final appBarPopMenuItems = <String>[
    'Rename drawing',
  ];

  final PaintSettings _paintSettings = PaintSettings();
  bool _showBordersSwitchValue = true;
  bool _enableColorPicker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.scaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: !_isLoading,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context) {
                return appBarPopMenuItems
                    .map(
                      (item) => PopupMenuItem<String>(
                        key: Key(
                          item,
                        ),
                        child: SolidButton(
                          height: 30.0,
                          width: 300.0,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.edit,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                item,
                              ),
                            ],
                          ),
                          onPressed: () => _renameDrawing(
                            _drawingId,
                            widget.appBarText,
                            _controller,
                          ),
                        ),
                        height: 30.0,
                      ),
                    )
                    .toList();
              }),
        ],
        title: Text(
          _drawingName,
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        color: Colors.black,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              color: Colors.deepPurple,
              axisDirection: AxisDirection.down,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: ChangeNotifierProvider(
                  create: (BuildContext context) => _paintSettings,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _getWidth(),
                        height: _getHeight() * 0.70,
                        child: SafeArea(
                          child: Board(
                            width: _getWidth(),
                            height: _getHeight() * 0.70,
                            setBlockInformationProperty:
                                _setBlockInformationProperty,
                            rows: widget.rows,
                            columns: widget.columns,
                            blockInformation: widget.initialBlockInformation,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CurrentColor(),
                            SolidButton(
                              width: 240.0,
                              color: Colors.deepPurple,
                              highlightColor: Colors.white,
                              splashColor: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.cloud,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Save to Cloud',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => _saveToCloud(
                                widget.appBarText,
                                widget.columns,
                                widget.rows,
                                FirebaseAuth.instance.currentUser.uid,
                                _drawingId,
                                _blockInformation,
                                _showSaveFailedAlert,
                                () => _setLoaderState(true),
                                () => _setLoaderState(false),
                                saveNewId: (widget.initialId.length == 0)
                                    ? true
                                    : false,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Switch(
                                  value: _showBordersSwitchValue,
                                  onChanged: (bool _newSwitchValue) {
                                    _paintSettings.setShowBorders(
                                      _newSwitchValue,
                                    );
                                    setState(
                                      () {
                                        _showBordersSwitchValue =
                                            _newSwitchValue;
                                      },
                                    );
                                  },
                                ),
                                Text(
                                  'Show borders',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Switch(
                                  value: _enableColorPicker,
                                  onChanged: (bool _newSwitchValue) {
                                    _paintSettings.setEnableColorPicker(
                                      _newSwitchValue,
                                    );
                                    setState(
                                      () {
                                        _enableColorPicker = _newSwitchValue;
                                      },
                                    );
                                  },
                                ),
                                Text(
                                  'Pick color on tap',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
