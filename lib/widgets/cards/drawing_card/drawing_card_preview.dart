import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pixel_art_app/screens/canvas/board/board.dart';
import 'package:pixel_art_app/services/database/database_service.dart';
import 'package:pixel_art_app/widgets/cards/counter_card/counter_card.dart';

class DrawingCardPreview extends StatefulWidget {
  @override
  _DrawingCardPreviewState createState() => _DrawingCardPreviewState();

  final List<QueryDocumentSnapshot> newestDrawings;
  final int index;
  final DatabaseService dbService;
  DrawingCardPreview({
    this.newestDrawings,
    this.index,
    this.dbService,
  });
}

class _DrawingCardPreviewState extends State<DrawingCardPreview> {
  Map<String, dynamic> targetDrawing;
  bool likedByUser = false;
  bool initialLikedByUser = false;
  bool _isLoading = false;

  int _getLikes(
    int likes,
    bool likedByUser,
    bool initialLikedByUser,
  ) {
    likes = (likes == null) ? 0 : likes;

    if ((initialLikedByUser && likedByUser) ||
        (!initialLikedByUser && !likedByUser)) {
      return likes;
    } else if (initialLikedByUser && !likedByUser) {
      return likes - 1;
    } else if (!initialLikedByUser && likedByUser) {
      return likes + 1;
    }

    return likes;
  }

  void _setLoaderState(
    bool _newValue,
  ) =>
      setState(
        () => _isLoading = _newValue,
      );

  @override
  void initState() {
    targetDrawing = widget.newestDrawings[widget.index].data();

    if (targetDrawing['likes']
            ?.contains(FirebaseAuth.instance.currentUser.uid) ??
        false) {
      likedByUser = true;
      initialLikedByUser = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      color: Colors.black,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.65,
            child: SafeArea(
              child: Board(
                canEditBlockProperties: false,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                columns: targetDrawing['size']['columns'],
                rows: targetDrawing['size']['rows'],
                setBlockInformationProperty: () => null,
                blockInformation: targetDrawing['blockInformation'],
              ),
            ),
          ),
          CounterCard(
            counter: _getLikes(
              targetDrawing['likes']?.length,
              likedByUser,
              initialLikedByUser,
            ),
            onPressed: () async {
              _setLoaderState(true);
              try {
                bool _likedByUser = await widget.dbService.markDrawingAsLiked(
                      targetDrawing['drawingId'],
                    ) ??
                    false;

                setState(
                  () => likedByUser = _likedByUser,
                );
              } catch (e) {}
              _setLoaderState(false);
            },
            counterIcon: Icon(
              (likedByUser) ? Icons.favorite : Icons.favorite_border,
              size: 25.0,
              color: (likedByUser) ? Colors.red : Colors.black,
            ),
            splashColor: Colors.red,
            highlightColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
