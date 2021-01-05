import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_art_app/screens/canvas/canvas.dart';
import 'package:pixel_art_app/screens/route_builders/slide.dart';
import 'package:pixel_art_app/services/database/database_service.dart';
import 'package:pixel_art_app/widgets/alerts/yes_no_alert.dart';

class DrawingCard extends StatefulWidget {
  @override
  _DrawingCardState createState() => _DrawingCardState();

  final String name, drawingId;
  final int columns, rows;
  final Map<String, dynamic> blockInformation;
  final Timestamp lastEditedOn;
  DrawingCard({
    this.name = '',
    this.drawingId = '',
    this.columns = 0,
    this.rows = 0,
    this.blockInformation = const {},
    this.lastEditedOn,
  });
}

class _DrawingCardState extends State<DrawingCard>
    with SingleTickerProviderStateMixin {
  final DatabaseService dbService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

  AnimationController _controller;
  Animation<double> _animation;
  double _horizontalOffset = 0.0;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 750,
      ),
      vsync: this,
    );

    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        dbService.deleteDrawing(
          widget.drawingId,
        );
      }
    });

    _animation = Tween<double>(
      begin: 0.0,
      end: 999.0,
    ).animate(_controller)
      ..addListener(() {
        setState(() {
          _horizontalOffset = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        _horizontalOffset,
        0.0,
      ),
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              buildSlideRoute(
                PixelArtCanvas(
                  columns: widget.columns,
                  rows: widget.rows,
                  appBarText: widget.name,
                  initialBlockInformation: widget.blockInformation,
                  initialId: widget.drawingId,
                ),
              ),
            );
          },
          title: Text(
            widget.name,
          ),
          subtitle: Text(
              'Last edited on ${DateFormat('dd/MM/yyyy').format(widget.lastEditedOn.toDate())} at ${DateFormat('HH:mm').format(widget.lastEditedOn.toDate())}'),
          trailing: Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: IconButton(
              icon: Icon(
                Icons.close,
              ),
              onPressed: () => YesNoAlert(
                  title: 'Delete drawing?',
                  text:
                      'Are you sure that you want to delete this drawing? It will be lost forever.',
                  onYesPressed: () {
                    _controller.forward();
                  }).showAlert(context),
            ),
          ),
        ),
      ),
    );
  }
}
