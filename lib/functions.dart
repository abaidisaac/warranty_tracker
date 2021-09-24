import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  signIn(email, password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return '';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

class FireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  getItems(user) {
    return firestore.collection(user).orderBy('expiry').snapshots();
  }

  addItem(user, item, image) async {
    Reference file =
        firebaseStorage.ref().child(user.toString() + '/' + item['name']);
    await file.putFile(image);
    item['image'] = await file.getDownloadURL();
    firestore.collection(user).add(item);
  }

  updateItem(user, item, id) async {
    firestore.collection(user).doc(id).update(item);
  }

  deleteItem(user, id) async {
    firestore.collection(user).doc(id).delete();
  }

  shareItem(user, item) async {
    await firestore
        .collection('users')
        .doc('emails')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      dynamic data = documentSnapshot.data();
      firestore.collection(data[user]).add(item);
    });
  }
}
