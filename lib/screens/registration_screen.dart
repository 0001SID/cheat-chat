import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/roundRecButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String route = '/registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email, password, emailErrorText, passErrorText;
  bool _isLoading = false;
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
                onChanged: (value) {
                  email = value;
                },
                decoration: kAuthFieldDecoration.copyWith(
                    hintText: 'Enter your email', errorText: emailErrorText),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kAuthFieldDecoration.copyWith(
                    hintText: 'Enter your password', errorText: passErrorText),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundRecButton(
                text: 'Register',
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    AuthResult authResult =
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                    if (authResult != null) {
                      Navigator.pushNamed(context, ChatScreen.route);
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  } catch (e) {
                    print('Error in register page $e');
                    bool isEmailError = false;
                    if (e.code == 'ERROR_INVALID_EMAIL') {
                      setState(() {
                        isEmailError = true;
                        emailErrorText = 'Invalid Email';
                      });
                    }
                    if (e.code == 'ERROR_USER_NOT_FOUND') {
                      setState(() {
                        isEmailError = true;
                        emailErrorText = 'User Not Found';
                      });
                    }
                    if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                      setState(() {
                        isEmailError = true;
                        emailErrorText = 'Email already exists';
                      });
                    }
                    if (e.code == 'ERROR_WEAK_PASSWORD') {
                      setState(() {
                        passErrorText =
                            'Password is too weak. Six Character must.';
                      });
                    } else {
                      setState(() {
                        passErrorText = null;
                      });
                    }

                    if (!isEmailError) {
                      setState(() {
                        emailErrorText = null;
                      });
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
