import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pixel_art_app/services/auth/auth_service.dart';
import 'package:pixel_art_app/widgets/buttons/solid_button.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SolidButton(
            width: 300.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.google,
                ),
                Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            highlightColor: Colors.deepPurple.withOpacity(
              0.4,
            ),
            splashColor: Colors.deepPurple.withOpacity(
              0.5,
            ),
            onPressed: () => context.read<AuthService>().signInWithGoogle(),
          ),
        ),
      ),
    );
  }
}
