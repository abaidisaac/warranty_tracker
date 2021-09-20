import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warranty_tracker/functions.dart';
import 'package:intl/intl.dart';
import 'package:warranty_tracker/addItems.dart';
import 'package:warranty_tracker/item.dart';
import 'package:warranty_tracker/login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  FireStore fireStore = FireStore();
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(40, 60, 0, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Items',
                      style: GoogleFonts.poppins(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm sign out?',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15)),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await AuthService()
                                              .firebaseAuth
                                              .signOut();
                                          runApp(MaterialApp(home: Login()));
                                        },
                                        child: Text('Sign out',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15))),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15)))
                                  ],
                                );
                              });
                        },
                        child: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ))
                  ])),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore.getItems(auth.firebaseAuth.currentUser?.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Text('hi');
                }
                return Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              color: snapshot.data!.docs
                                      .elementAt(index)['expiry']
                                      .toDate()
                                      .isAfter(DateTime.now())
                                  ? Colors.white
                                  : Colors.redAccent,
                              child: ListTile(
                                title: Text(snapshot.data!.docs
                                    .elementAt(index)['name']),
                                subtitle: Text(DateFormat.yMMMd().format(
                                    snapshot.data!.docs
                                        .elementAt(index)['expiry']
                                        .toDate())),
                                trailing: Image(
                                    image: CachedNetworkImageProvider(snapshot
                                        .data!.docs
                                        .elementAt(index)['image'])),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Items(
                                              item: snapshot.data!.docs
                                                  .elementAt(index))));
                                },
                              ));
                        }));
              })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Add Item'),
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddItem()));
          }),
    );
  }
}
