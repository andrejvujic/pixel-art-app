import 'package:flutter/material.dart';
import 'package:pixel_art_app/widgets/buttons/solid_button.dart';

class InputAlert {
  final String title, buttonText;
  final List<Widget> children;
  final Function onButtonPressed;

  InputAlert({
    this.title,
    this.children,
    this.buttonText,
    this.onButtonPressed,
  });

  Future<void> showAlert(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 20.0, fontFamily: 'Poppins-Bold'),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: children,
              ),
            ),
            actions: <Widget>[
              SolidButton(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onButtonPressed?.call();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
