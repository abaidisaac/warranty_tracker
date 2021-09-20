import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'functions.dart';

class Item {
  final dynamic item;
  const Item(this.item);
}

class Items extends StatefulWidget {
  final dynamic item;
  const Items({Key? key, required this.item}) : super(key: key);

  @override
  ItemsState createState() => ItemsState();
}

class ItemsState extends State<Items> {
  dynamic name, value, date;
  final _formkey = GlobalKey<FormState>();
  FireStore fireStore = FireStore();
  AuthService auth = AuthService();

  Widget build(BuildContext context) {
    if (date == null) {
      date = widget.item['expiry'].toDate();
    }
    if (name == null) {
      name = widget.item['name'];
    }
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(60, 60, 60, 60),
                      child: CachedNetworkImage(
                        imageUrl: widget.item['image'],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                        child: field(name, null)),
                    Container(
                      padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                      child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            value = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000, 1),
                              lastDate: DateTime(2040, 12),
                            );
                            if (value != null) {
                              setState(() {
                                date = value;
                              });
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
                                  '' +
                                      DateFormat.yMMMd()
                                          .format(date)
                                          .toString(),
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
                          fireStore.updateItem(
                              AuthService().firebaseAuth.currentUser?.uid,
                              {
                                'name': name,
                                'expiry': date,
                                'image': widget.item['image']
                              },
                              widget.item.id);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'UPDATE',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.5, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          fireStore.deleteItem(
                              AuthService().firebaseAuth.currentUser?.uid,
                              widget.item.id);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'DELETE',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ))));
  }

  Widget field(item, icon) {
    return TextFormField(
      initialValue: item,
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
