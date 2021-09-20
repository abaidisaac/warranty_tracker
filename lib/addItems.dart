import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warranty_tracker/functions.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);
  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  dynamic date = DateTime.now(), name, value, image;
  final imagePicker = ImagePicker();
  final _formkey = GlobalKey<FormState>();
  final firestore = FireStore();
  final auth = AuthService();

  Future getImage() async {
    dynamic file = await imagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() {
        image = File(file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(60, 40, 60, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text(
                  'Add Item',
                  style: GoogleFonts.poppins(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: Container(
                          child: image != null
                              ? Image.file(image)
                              : Icon(Icons.image, color: Colors.black)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    field('Name', null),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          value = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000, 1),
                            lastDate: DateTime(2040, 12),
                          );
                          if (value != null) {
                            date = value;
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Expiry',
                                style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600)),
                            Text(':',
                                style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600)),
                            Text(
                                '' + DateFormat.yMMMd().format(date).toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))))),
                    ElevatedButton(
                        onPressed: () {
                          getImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Image',
                                style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600)),
                            image != null
                                ? Text('Added',
                                    style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600))
                                : Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.black,
                                  ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))))),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.5, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          Navigator.pop(context);
                          await firestore.addItem(
                              auth.firebaseAuth.currentUser?.uid,
                              {'name': name, 'expiry': date},
                              image);
                          setState(() {});
                        }
                      },
                      child: Text(
                        'ADD',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget field(field, icon) {
    return TextFormField(
      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          labelStyle: GoogleFonts.poppins(),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: icon,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: field,
          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Empty';
        }
      },
      onSaved: (value) {
        setState(() {
          name = value.toString();
        });
      },
    );
  }
}

        // fireStore.addItem(auth.firebaseAuth.currentUser?.uid,
        //     {'name': 'abaid', 'expiry': DateTime.now()});
