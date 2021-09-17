import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_demo_project/models/borrow_model.dart';
import 'package:library_demo_project/services/calculator.dart';
import 'package:library_demo_project/views/borrowed_list_view_model.dart';
import 'package:provider/provider.dart';

class BorrowForm extends StatefulWidget {
  @override
  _BorrowFormState createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController surnameCtr = TextEditingController();
  TextEditingController borrowDateCtr = TextEditingController();
  TextEditingController returnDateCtr = TextEditingController();

  DateTime? _selectedBorrowDate;
  DateTime? _selectedReturnDate;

  final _formKey = GlobalKey<FormState>();

  String? _photoUrl;

  File? _image;
  final picker = ImagePicker();

  Future<String> uploadImageToStorage(File imageFile) async {
    ///Storage üzerindeki dosya adını oluştur
    String path = '${DateTime.now().millisecondsSinceEpoch}';

    TaskSnapshot uploadTask = await FirebaseStorage.instance
        .ref()
        .child('photos')
        .child(path)
        .putFile(_image!);

    String uploadedeImageUrl = await uploadTask.ref.getDownloadURL();

    return uploadedeImageUrl;
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image Selected');
      }
    });
    if (pickedFile != null) {
      _photoUrl = await uploadImageToStorage(_image!);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameCtr.dispose();
    surnameCtr.dispose();
    borrowDateCtr.dispose();
    returnDateCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BorrowedListViewModel(),
      builder: (context, _) => Container(
        padding: EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: (_image == null)
                                ? NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/library-demo-project-31d3f.appspot.com/o/photos%2Fperson-icon.png?alt=media&token=9923698b-8d8d-4845-9bc3-6df930efaa4d',
                                  ) as ImageProvider
                                : FileImage(_image!),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -10,
                            child: IconButton(
                              icon: Icon(
                                Icons.photo_camera_rounded,
                                color: Colors.grey.shade100,
                                size: 26,
                              ),
                              onPressed: () {
                                getImage();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: nameCtr,
                            decoration: InputDecoration(
                              hintText: 'Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Name';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: surnameCtr,
                            decoration: InputDecoration(
                              hintText: 'Surname',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Surname';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        onTap: () async {
                          _selectedBorrowDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));

                          borrowDateCtr.text =
                              Calculator.dateTimeToString(_selectedBorrowDate!);
                        },
                        controller: borrowDateCtr,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          hintText: 'Purchase Date',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Date';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: TextFormField(
                        onTap: () async {
                          _selectedReturnDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));

                          returnDateCtr.text =
                              Calculator.dateTimeToString(_selectedReturnDate!);
                        },
                        controller: returnDateCtr,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          hintText: 'Return Date',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Date';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BorrowInfo newBorrowInfo = BorrowInfo(
                            name: nameCtr.text,
                            surname: surnameCtr.text,
                            photoUrl: _photoUrl ??
                                'https://firebasestorage.googleapis.com/v0/b/library-demo-project-31d3f.appspot.com/o/photos%2Fperson-icon.png?alt=media&token=9923698b-8d8d-4845-9bc3-6df930efaa4d',
                            borrowDate: Calculator.dateTimeToTimestamp(
                                _selectedBorrowDate!),
                            returnDate: Calculator.dateTimeToTimestamp(
                                _selectedBorrowDate!),
                          );
                          Navigator.pop(context, newBorrowInfo);
                        }
                      },
                      child: Text('Borrowed Record List'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_photoUrl != null) {
                          context
                              .read<BorrowedListViewModel>()
                              .deletePhoto(_photoUrl!);
                        }
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
