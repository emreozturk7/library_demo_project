import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_demo_project/models/borrow_model.dart';

class Book {
  final String id;
  final String bookName;
  final String authorName;
  final Timestamp publishDate;
  final List<BorrowInfo> borrows;

  Book({
    required this.id,
    required this.bookName,
    required this.authorName,
    required this.publishDate,
    required this.borrows,
  });

  //Objeden map oluşturan method
  Map<String, dynamic> toMap() {
    //List<BookInfo> ----> List<Map>
    List<Map<String, dynamic>> borrows =
        this.borrows.map((borrowInfo) => borrowInfo.toMap()).toList();
    return {
      'id': id,
      'bookName': bookName,
      'authorName': authorName,
      'publishDate': publishDate,
      'borrows': borrows,
    };
  }

  // mapten obje oluşturan yapıcı
  factory Book.fromMap(Map map) {
    var borrowListAsMap = map['borrows'] as List;
    List<BorrowInfo> borrows = borrowListAsMap
        .map((borrowAsMap) => BorrowInfo.fromMap(borrowAsMap))
        .toList();
    return Book(
        id: map['id'],
        bookName: map['bookName'],
        authorName: map['authorName'],
        publishDate: map['publishDate'],
        borrows: borrows);
  }
}
