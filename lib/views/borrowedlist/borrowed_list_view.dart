import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:library_demo_project/models/book_model.dart';
import 'package:library_demo_project/models/borrow_model.dart';
import 'package:library_demo_project/views/borrowedlist/borrowed_list_view_model.dart';
import 'package:provider/provider.dart';

import 'borrow_form_view.dart';

class BorrowedListView extends StatefulWidget {
  final Book book;

  const BorrowedListView({Key? key, required this.book}) : super(key: key);

  @override
  _BorrowedListViewState createState() => _BorrowedListViewState();
}

class _BorrowedListViewState extends State<BorrowedListView> {
  @override
  Widget build(BuildContext context) {
    Future<bool> _willPopCallback() async {
      exit(0);
    }

    List<BorrowInfo> borrowList = widget.book.borrows;
    return ChangeNotifierProvider<BorrowedListViewModel>(
      create: (context) => BorrowedListViewModel(),
      builder: (context, _) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            FirebaseStorage _storage = FirebaseStorage.instance;
            Reference refPhotos = _storage.ref().child('photos');
            var photoUrl =
                await refPhotos.child('person-icon.png').getDownloadURL();
            print(photoUrl);
          },
        ),
        appBar: AppBar(
          title: Text('${widget.book.bookName} Borrowed Record'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  itemCount: borrowList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        '${borrowList[index].name} ${borrowList[index].surname}',
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          '${borrowList[index].photoUrl}',
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, _) => Divider(),
                ),
              ),
              InkWell(
                onTap: () async {
                  BorrowInfo? newBorrowInfo =
                      await showModalBottomSheet<BorrowInfo>(
                          enableDrag: false,
                          isDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: _willPopCallback,
                              child: BorrowForm(),
                            );
                          },
                          context: context);
                  if (newBorrowInfo == null) {
                    ///storageden fotoyu sil
                    ///url -> ref.ref.delete()
                  }
                  print('modabottomsheet $newBorrowInfo');
                  if (newBorrowInfo != null) {
                    setState(() {
                      borrowList.add(newBorrowInfo);
                    });
                    context.read<BorrowedListViewModel>().updateBook(
                          borrowList: borrowList,
                          book: widget.book,
                        );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 80,
                  color: Colors.blueAccent,
                  child: Text(
                    'New',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
