import 'package:flutter/material.dart';
import 'package:library_demo_project/models/book_model.dart';
import 'package:library_demo_project/services/calculator.dart';
import 'package:library_demo_project/services/database.dart';

class AddBookViewModel extends ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'books';

  Future<void> addNewBook({
    required String bookName,
    required String authorName,
    required DateTime publishDate,
  }) async {
    ///Form Alanındaki verileri ilk önce bir book objesi oluşturulması
    Book newBook = Book(
      id: DateTime.now().toIso8601String(),
      bookName: bookName,
      authorName: authorName,
      publishDate: Calculator.dateTimeToTimestamp(publishDate),
      borrows: [],
    );

    await _database.setBookData(collectionPath, newBook.toMap());
  }
}
