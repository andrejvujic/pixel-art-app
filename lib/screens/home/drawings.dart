import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixel_art_app/screens/canvas/create_canvas.dart';
import 'package:pixel_art_app/screens/route_builders/slide.dart';
import 'package:pixel_art_app/screens/signup/signup.dart';
import 'package:pixel_art_app/services/database/database_service.dart';
import 'package:pixel_art_app/widgets/buttons/solid_button.dart';
import 'package:pixel_art_app/widgets/cards/drawing_card/drawing_card.dart';

class Drawings extends StatefulWidget {
  @override
  _DrawingsState createState() => _DrawingsState();
}

class _DrawingsState extends State<Drawings> {
  DatabaseService dbService = DatabaseService(
    uid: FirebaseAuth.instance.currentUser.uid,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbService.currentUserData,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),
          );
        }

        final Map<String, dynamic> currentUserData = snapshot.data.data();

        return StreamBuilder(
          stream: dbService.currentUserDrawings,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ),
              );
            }

            final QuerySnapshot querySnapshot = snapshot.data;
            final List<QueryDocumentSnapshot> currentUserDrawings =
                querySnapshot.docs;

            return Scaffold(
              body: (currentUserData == null || currentUserData?.length == 0)
                  ? Signup()
                  : (currentUserDrawings.length > 0)
                      ? SafeArea(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: ScrollConfiguration(
                              behavior: ScrollBehavior(),
                              child: GlowingOverscrollIndicator(
                                color: Colors.deepPurple,
                                axisDirection: AxisDirection.down,
                                child: ListView.builder(
                                  itemCount: currentUserDrawings.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Map<String, dynamic> drawingData =
                                        currentUserDrawings[index].data() ?? {};
                                    return Container(
                                      key: Key(
                                        drawingData['drawingId'],
                                      ),
                                      color: Colors.transparent,
                                      child: DrawingCard(
                                        name: drawingData['name'] ?? '',
                                        columns:
                                            drawingData['size']['columns'] ?? 0,
                                        rows: drawingData['size']['rows'] ?? 0,
                                        blockInformation:
                                            drawingData['blockInformation'] ??
                                                {},
                                        lastEditedOn:
                                            drawingData['lastEditedOn'],
                                        drawingId: drawingData['drawingId'],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      : SafeArea(
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
                                  'You have no drawings',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Bold',
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  'You currently don\'t have any drawings, but when you do all of them will be displayed here. Click the button below to add your first drawing.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: SolidButton(
                                    color: Colors.deepPurple,
                                    highlightColor: Colors.white,
                                    splashColor: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.add, color: Colors.white),
                                        Text(
                                          'Add your first drawing',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      buildSlideRoute(
                                        CreatePixelArtCanvas(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              floatingActionButton:
                  (currentUserData == null || currentUserData?.length == 0)
                      ? Container()
                      : FloatingActionButton(
                          onPressed: () => Navigator.push(
                            context,
                            buildSlideRoute(
                              CreatePixelArtCanvas(),
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                          ),
                        ),
            );
          },
        );
      },
    );
  }
}
