import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_demo_project/models/book_model.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore servisinden kitapların verisini stream olarak alıp bu  hizmeti sağlamak istiyorum.

  Stream<QuerySnapshot> getBookListApi(String referansPath) {
    return _firestore.collection(referansPath).snapshots();
  }

  //Firestore üzerinden bir veriyi silmek

  Future<void> deleteDocument(
      {required String referencePath, required String id}) async {
    await _firestore.collection(referencePath).doc(id).delete();
  }

  //Firestore a yeni veri ekleme ve güncelleme hizmeti
  Future<void> setBookData(
      String collectionPath, Map<String, dynamic> bookAsMap) async {
    await _firestore
        .collection(collectionPath)
        .doc(Book.fromMap(bookAsMap).id)
        .set(bookAsMap);
  }
}
