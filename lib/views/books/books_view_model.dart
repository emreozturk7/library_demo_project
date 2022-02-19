import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_demo_project/models/book_model.dart';
import 'package:library_demo_project/services/database.dart';

class BooksViewModel extends ChangeNotifier {
  Database _database = Database();
  String _collectionPath = 'books';

  Stream<List<Book>>? getBookList() {
    /// stream <QuerySnapshot> --> Stream<List<DocumentSnapshot>>
    Stream<List<DocumentSnapshot>> streamListDocument = _database
        .getBookListApi(_collectionPath)
        .map((querySnapshot) => querySnapshot.docs);

    /// Stream<List<DocumentSnapshot>> --> Stream<List<Book>>
    var streamListBook = streamListDocument.map((listOfDocSnap) => listOfDocSnap
        .map((docSnap) => Book.fromMap(docSnap.data() as Map<String, dynamic>))
        .toList());

    return streamListBook;
  }

  Future<void> deleteBook(Book book) async {
    await _database.deleteDocument(referencePath: _collectionPath, id: book.id);
  }
}
