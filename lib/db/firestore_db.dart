import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDB {
  static FireStoreDB _fireStoreDB;
  FirebaseFirestore firebaseInstance;
  String contentsCollection = 'Contents';
  FireStoreDB._() {
    firebaseInstance = FirebaseFirestore.instance;
  }

  static getInstance() {
    if (_fireStoreDB == null) _fireStoreDB = FireStoreDB._();
    return _fireStoreDB;
  }

  // SERIE OPERATIONS
  getSeries() {
    return firebaseInstance
        .collection(contentsCollection)
        .orderBy('watch_count', descending: true)
        .where("type", isEqualTo: 0)
        .limit(30);
  }

  getNextSeries(lastVisible) {
    return firebaseInstance
        .collection(contentsCollection)
        .orderBy('watch_count', descending: true)
        .where("type", isEqualTo: 0)
        .startAfterDocument(lastVisible)
        .limit(30);
  }

  getEpisodes(String documentID, String seasonID) {
    return firebaseInstance
        .collection(contentsCollection)
        .doc(documentID)
        .collection("Seasons")
        .doc(seasonID)
        .collection("Episodes")
        .orderBy("episode_seq")
        .limit(10);
  }

  getNextEpisodes(String documentID, String seasonID, lastVisible) {
    return firebaseInstance
        .collection(contentsCollection)
        .doc(documentID)
        .collection("Seasons")
        .doc(seasonID)
        .collection("Episodes")
        .orderBy("episode_seq")
        .startAfterDocument(lastVisible)
        .limit(10);
  }

  // MOVIE OPERATIONS
  getMovies() {
    return firebaseInstance
        .collection(contentsCollection)
        .orderBy('watch_count', descending: true)
        .where("type", isEqualTo: 1)
        .limit(30);
  }

  getNextMovies(lastVisible) {
    return firebaseInstance
        .collection(contentsCollection)
        .orderBy('watch_count', descending: true)
        .where("type", isEqualTo: 1)
        .startAfterDocument(lastVisible)
        .limit(30);
  }

  addViewCount(String documentID, int viewCount) {
    firebaseInstance
        .collection(contentsCollection)
        .doc(documentID)
        .update({'watch_count': viewCount + 1});
  }

  searchDefaultResults() {
    return FirebaseFirestore.instance
        .collection(contentsCollection)
        .limit(10)
        .orderBy('watch_count', descending: true)
        .snapshots();
  }

  searchOnChanged(String searchKey) {
    return FirebaseFirestore.instance
        .collection(contentsCollection)
        .where('search_key', isGreaterThan: searchKey)
        .where('search_key', isLessThan: searchKey + 'z')
        .limit(10)
        .snapshots();
  }

  getRecommendedMovies(List genre) {
    return FirebaseFirestore.instance
        .collection(contentsCollection)
        .where("genre",
            arrayContainsAny:
                genre.isNotEmpty ? genre : ["Fantasy", "Adventure"])
        .orderBy("watch_count", descending: true)
        .limit(10)
        .snapshots();
  }
}
