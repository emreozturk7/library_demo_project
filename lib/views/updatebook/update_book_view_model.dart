import 'package:flutter/material.dart';
import 'package:library_demo_project/models/book_model.dart';
import 'package:library_demo_project/services/calculator.dart';
import 'package:library_demo_project/services/database.dart';

class UpdateBookViewModel extends ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'books';

  Future<void> updateBook(
      {required String bookName,
      required String authorName,
      required DateTime publishDate,
      required Book book}) async {
    Book newBook = Book(
      id: book.id,
      bookName: bookName,
      authorName: authorName,
      publishDate: Calculator.dateTimeToTimestamp(publishDate),
      borrows: book.borrows,
    );

    await _database.setBookData(collectionPath, newBook.toMap());
  }
}
