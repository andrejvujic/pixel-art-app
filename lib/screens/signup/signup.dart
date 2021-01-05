import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pixel_art_app/services/database/database_service.dart';
import 'package:pixel_art_app/widgets/alerts/info_alert.dart';
import 'package:pixel_art_app/widgets/buttons/solid_button.dart';
import 'package:pixel_art_app/widgets/text_input/text_input.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final DatabaseService dbService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  DateTime birthday = DateTime.now();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, DateTime _initialDate) async {
    DateTime _selectedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    setState(
      () => birthday = (_selectedDate == null) ? birthday : _selectedDate,
    );
  }

  Future<void> _addUserData(
    BuildContext context,
    TextEditingController _nameController,
    TextEditingController _bioController,
    DateTime _birthday,
    Function _setLoaderState,
  ) async {
    _setLoaderState(true);
    if (_nameController.text.isEmpty) {
      InfoAlert(
              title: 'Oops...',
              text:
                  'It looks like you haven\'t entered your name. Please enter your name and try again.')
          .showAlert(context);
    }
    try {
      await dbService.createUserProfile(
        _nameController.text,
        _bioController.text,
        _birthday,
      );
    } catch (e) {
      InfoAlert(
              title: 'Oops...',
              text:
                  'We ran into an error while we were creating your account, plase try again.')
          .showAlert(context);
    }
    _setLoaderState(false);
  }

  void _setLoaderState(bool _value) => setState(() => _isLoading = _value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create your profile',
        ),
        centerTitle: true,
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
                child: Container(
                  padding: EdgeInsets.all(
                    16.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      TextInput(
                        margin: EdgeInsets.all(
                          10.0,
                        ),
                        labelText: 'Your name*',
                        hintText: 'How do people call you?',
                        controller: _nameController,
                      ),
                      TextInput(
                        margin: EdgeInsets.all(
                          10.0,
                        ),
                        maxLength: 250,
                        maxLines: 5,
                        labelText: 'Your bio',
                        hintText: 'Tell us something about yourself',
                        controller: _bioController,
                      ),
                      SolidButton(
                        color: Colors.grey[200],
                        childPadding: EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width * 0.80,
                        highlightColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Your birthday*',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.calendarAlt,
                                ),
                                Text(
                                  '${DateFormat('MM/dd/yyyy').format(birthday)}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onPressed: () => _selectDate(
                          context,
                          birthday,
                        ),
                      ),
                      SolidButton(
                        margin: EdgeInsets.only(
                          top: 50.0,
                          bottom: 25.0,
                        ),
                        child: Text(
                          'Start drawing',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () => _addUserData(context, _nameController,
                            _bioController, birthday, _setLoaderState),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '* - required fields',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
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
