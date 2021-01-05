import 'package:flutter/material.dart';
import 'package:pixel_art_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pixel_art_app/widgets/buttons/solid_button.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: SolidButton(
                    color: Colors.deepPurple,
                    highlightColor: Colors.white,
                    splashColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        Text(
                          'Sign out',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => context.read<AuthService>().signOut(),
                  ),
                ),
                Text(
                  'Pixel Art v1.0.3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'Copyright © 2020 Andrej Vujić',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
