import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/roundRecButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password, emailErrorText, passErrorText;
  FirebaseAuth _auth;
  bool _isLoading = false;

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    super.initState();
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
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
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
                  textAlign: TextAlign.center,
                  obscureText: true,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kAuthFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                    errorText: passErrorText,
                  )),
              SizedBox(
                height: 24.0,
              ),
              RoundRecButton(
                text: 'Login',
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    AuthResult authResult =
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                    if (authResult != null) {
                      Navigator.pushNamed(context, ChatScreen.route);
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  } catch (e) {
                    print('Error in login page $e');
                    bool isEmailError = false;
                    if (e.code == 'ERROR_INVALID_EMAIL') {
                      setState(() {
                        isEmailError = true;
                        emailErrorText = 'Invalid Email';
                      });
                    }
                    if (e.code == 'ERROR_WRONG_PASSWORD') {
                      setState(() {
                        passErrorText = 'Wrong Password';
                      });
                    } else {
                      setState(() {
                        passErrorText = null;
                      });
                    }
                    if (e.code == 'ERROR_USER_NOT_FOUND') {
                      setState(() {
                        isEmailError = true;
                        emailErrorText = 'User Not Found';
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
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
