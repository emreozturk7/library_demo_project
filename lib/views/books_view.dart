import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:library_demo_project/models/book_model.dart';
import 'package:library_demo_project/views/add_book_view.dart';
import 'package:library_demo_project/views/books_view_model.dart';
import 'package:library_demo_project/views/borrowed_list_view.dart';
import 'package:library_demo_project/views/update_book_view.dart';
import 'package:provider/provider.dart';

class BooksView extends StatefulWidget {
  @override
  _BooksViewState createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BooksViewModel>(
      create: (_) => BooksViewModel(),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('Book List'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<Book>>(
                stream: Provider.of<BooksViewModel>(context, listen: false)
                    .getBookList(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(
                      child: Text(
                        asyncSnapshot.error.toString(),
                        style: TextStyle(fontSize: 25),
                      ),
                    );
                  } else {
                    if (!asyncSnapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      List? bookList = asyncSnapshot.data;
                      return BuildListView(bookList: bookList);
                    }
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBookView()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class BuildListView extends StatefulWidget {
  const BuildListView({
    Key? key,
    required this.bookList,
  }) : super(key: key);

  final List? bookList;

  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  bool isFiltering = false;
  var filteredList;

  @override
  Widget build(BuildContext context) {
    var fullList = widget.bookList;
    return Flexible(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              onChanged: (query) {
                if (query.isNotEmpty) {
                  isFiltering = true;
                  setState(() {
                    filteredList = fullList!
                        .where((book) => book.bookName
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                } else {
                  WidgetsBinding.instance!.focusManager.primaryFocus!.unfocus();
                  setState(() {
                    isFiltering = false;
                  });
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search: Book name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: isFiltering ? filteredList.length : fullList!.length,
              itemBuilder: (context, index) {
                var list = isFiltering ? filteredList : fullList;
                return Slidable(
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.2,
                  child: Card(
                    child: ListTile(
                      title: Text(list![index].bookName),
                      subtitle: Text(list![index].authorName),
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Registration',
                      color: Colors.blue,
                      icon: Icons.account_circle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BorrowedListView(
                              book: list[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.orangeAccent,
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateBookView(
                              book: list[index],
                            ),
                          ),
                        );
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        await Provider.of<BooksViewModel>(context,
                                listen: false)
                            .deleteBook(list[index]);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
