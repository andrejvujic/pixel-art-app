import 'package:flutter/material.dart';

class NotImplemented extends StatefulWidget {
  @override
  _NotImplementedState createState() => _NotImplementedState();
}

class _NotImplementedState extends State<NotImplemented> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Nothing to see here',
                style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 20.0,
                ),
              ),
              Text(
                'This page has not yet been implemented. It will be implemented in the later versions of the app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
