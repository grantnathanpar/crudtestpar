import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/photos.dart';
import '../models/hearts.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  Firestore _db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream<List<Photos>> getPhotos() {
    return _db
        .collection("photos")
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map(
              (doc) => Photos.fromMap(doc.data, doc.documentID),
            )
            .toList());
  }

  Stream<List<Hearts>> gethearts(String id) {
    return _db
        .collection("photos")
        .document(id)
        .collection("hearts")
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map(
              (doc) => Hearts.fromMap(doc.data, doc.documentID),
            )
            .toList());
  }

  Future<void> addphoto(Photos photos) {
    return _db.collection("photos").add(photos.toMap());
  }

  Future<void> addheart(String id, Hearts hearts) {
    return _db
        .collection("photos")
        .document(id)
        .collection("hearts")
        .add(hearts.toMap());
  }

  Future<void> updatephoto(Photos photos) {
    return _db
        .collection("photos")
        .document(photos.id)
        .updateData(photos.toMap());
  }

  Future<void> deletephoto(String id) {
    return _db.collection("photos").document(id).delete();
  }
}
