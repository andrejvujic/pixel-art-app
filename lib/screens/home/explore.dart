import 'package:pixel_art_app/screens/canvas/paint_settings.dart';
import 'package:pixel_art_app/widgets/cards/drawing_card/drawing_card_preview.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixel_art_app/services/database/database_service.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final DatabaseService dbService = DatabaseService(
    uid: FirebaseAuth.instance.currentUser.uid,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: dbService.newestDrawings,
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            );
          }

          final QuerySnapshot querySnapshot = snapshot.data;
          final List<QueryDocumentSnapshot> newestDrawings = querySnapshot.docs;

          final PaintSettings _paintSettings = PaintSettings();

          return ChangeNotifierProvider(
            create: (BuildContext context) => _paintSettings,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: newestDrawings.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) =>
                  Container(
                key: Key(
                  newestDrawings[index].data()['drawingId'],
                ),
                child: DrawingCardPreview(
                  newestDrawings: newestDrawings,
                  index: index,
                  dbService: dbService,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
