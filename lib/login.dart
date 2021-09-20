import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warranty_tracker/functions.dart';
import 'package:warranty_tracker/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final authService = AuthService();
  final _formkey = GlobalKey<FormState>();
  String username = '', password = '', error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(40, 65, 0, 0),
          child: Text(
            'Warranty Tracker',
            style:
                GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 300, 0, 10),
          child: Text(
            'Login',
            style:
                GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  usernameField(),
                  SizedBox(height: 10),
                  passwordField(),
                  SizedBox(height: 10),
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
                        error = await authService.signIn(username, password);
                        setState(() {});
                        if (authService.firebaseAuth.currentUser != null) {
                          runApp(MaterialApp(home: Home()));
                        }
                      }
                    },
                    child: Text(
                      'LOGIN',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    error,
                    style: GoogleFonts.poppins(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ))
      ],
    )));
  }

  Widget usernameField() {
    return TextFormField(
      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        filled: true,
        labelStyle: GoogleFonts.poppins(),
        fillColor: Colors.white,
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: InputBorder.none,
        labelText: 'Email',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Empty';
        }
        if (!value.contains('.com') || !value.contains('@')) {
          return 'Wrong Email format';
        }
      },
      onSaved: (value) {
        setState(() {
          username = value.toString();
        });
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      style: GoogleFonts.poppins(),
      obscureText: true,
      decoration: InputDecoration(
        labelStyle: GoogleFonts.poppins(),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.lock),
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
        labelText: 'Password',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Empty';
        }
      },
      onSaved: (value) {
        setState(() {
          password = value.toString();
        });
      },
    );
  }
}
