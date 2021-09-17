import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:library_demo_project/models/book_model.dart';
import 'package:library_demo_project/models/borrow_model.dart';
import 'package:library_demo_project/services/database.dart';

class BorrowedListViewModel with ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'books';

  Future<void> updateBook(
      {required List<BorrowInfo> borrowList, required Book book}) async {
    Book newBook = Book(
      id: book.id,
      publishDate: book.publishDate,
      authorName: book.authorName,
      bookName: book.bookName,
      borrows: borrowList,
    );
    await _database.setBookData(collectionPath, newBook.toMap());
  }

  Future<void> deletePhoto(String photoUrl) async {
    Reference photoRef = FirebaseStorage.instance.refFromURL(photoUrl);
    await photoRef.delete();
  }
}
