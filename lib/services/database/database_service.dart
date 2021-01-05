import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    this.uid,
  });

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference drawingsCollection =
      FirebaseFirestore.instance.collection('drawings');

  Future<String> addDrawing(
    String _name,
    int _columns,
    int _rows,
    String _authorId,
    String _drawingId,
    Map<String, dynamic> _blockInformation,
  ) async {
    /// Adds a new drawing to the database

    final Map<String, dynamic> _drawingData = {
      'name': _name,
      'size': {
        'columns': _columns,
        'rows': _rows,
      },
      'authorId': _authorId,
      'blockInformation': _blockInformation,
      'createdOn': Timestamp.now(),
      'lastEditedOn': Timestamp.now(),
      'drawingId': _drawingId,
      'likes': [],
    };

    if (await drawingExists(_drawingId)) {
      await setDrawingData(_drawingId, _drawingData);
      return _drawingId;
    } else {
      final String _id =
          await drawingsCollection.add(_drawingData).then((value) => value.id);
      await updateDrawingId(_id);
      return _id;
    }
  }

  Future<bool> setDrawingProperty(
    String _property,
    String _value,
    String _id,
  ) async {
    Map _data = await getDrawingData(_id);
    if (_data == null)
      return false;
    else if (_data.containsKey(_property)) {
      _data[_property] = _value;
      await setDrawingData(
        _id,
        _data,
      );
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteDrawing(String _id) async {
    await drawingsCollection.doc(_id).delete();
  }

  Future<void> updateDrawingId(String _id) async {
    final Map _data = await getDrawingData(_id);
    _data['drawingId'] = _id;
    await setDrawingData(_id, _data);
  }

  Future<void> updateDrawing(
    String _name,
    int _columns,
    int _rows,
    String _authorId,
    String _drawingId,
    Map<String, dynamic> _blockInformation,
  ) async {
    final Map _drawingData = await getDrawingData(_drawingId);

    _drawingData['name'] = _name;
    _drawingData['size'] = {'columns': _columns, 'rows': _rows};
    _drawingData['authorId'] = _authorId;
    _drawingData['blockInformation'] = _blockInformation;
    _drawingData['lastEditedOn'] = Timestamp.now();
    _drawingData['id'] = _drawingId;

    await setDrawingData(_drawingId, _drawingData);
  }

  Future<bool> markDrawingAsLiked(
    String _drawingId,
  ) async {
    final Map _drawingData = await getDrawingData(_drawingId);

    if (_drawingData == null ||
        _drawingData.length == 0 ||
        _drawingData['likes'] == null) {
      _drawingData['likes'] = <String>[
        uid,
      ];
    } else if (_drawingData['likes']?.contains(uid) ?? false) {
      _drawingData['likes'].remove(
        uid,
      );
    } else {
      _drawingData['likes'].add(
        uid,
      );
    }

    await setDrawingData(_drawingId, _drawingData);
    return _drawingData['likes'].contains(uid);
  }

  Future<bool> drawingExists(
    String _drawingId,
  ) async {
    return !(await getDrawingData(_drawingId) == null);
  }

  Future<Map> getDrawingData(
    String _drawingId,
  ) async {
    return await drawingsCollection
        .doc(_drawingId)
        .get()
        .then((value) => value.data());
  }

  Future<void> setDrawingData(
    String _drawingId,
    Map _drawingData,
  ) async {
    await drawingsCollection.doc(_drawingId).set(_drawingData);
  }

  Future<Map<String, dynamic>> getUserData(
    String _userId,
  ) async {
    return await usersCollection
        .doc(_userId)
        .get()
        .then((value) => value.data());
  }

  Future<void> createUserProfile(
    String _name,
    String _bio,
    DateTime _birthday,
  ) async {
    final Map<String, dynamic> _userData = {
      'name': _name,
      'bio': _bio,
      'bornOn': _birthday,
      'joinedOn': Timestamp.now(),
    };
    await setUserData(_userData);
  }

  Future<void> setUserData(
    Map<String, dynamic> _userData,
  ) async {
    await usersCollection.doc(uid).set(_userData);
  }

  Future<QuerySnapshot> get newestDrawings => drawingsCollection
      .orderBy(
        'createdOn',
        descending: true,
      )
      .get();

  /*
  Stream<QuerySnapshot> get newestDrawings => drawingsCollection
      .orderBy(
        'createdOn',
        descending: true,
      )
      .snapshots();
  */

  Stream<DocumentSnapshot> get currentUserData =>
      usersCollection.doc(uid).snapshots();

  Stream<QuerySnapshot> get currentUserDrawings => drawingsCollection
      .orderBy(
        'lastEditedOn',
        descending: true,
      )
      .where(
        'authorId',
        isEqualTo: uid,
      )
      .snapshots();
}
