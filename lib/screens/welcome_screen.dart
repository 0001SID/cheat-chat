import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:flash_chat/components/roundRecButton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String route = '/welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.5,
    );
    _animation =
        ColorTween(begin: Colors.blue, end: Colors.white).animate(_controller);

    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  repeatForever: true,
                  speed: Duration(milliseconds: 200),
                  text: ['Cheat Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundRecButton(
              onPressed: () {
                //Go to login screen.
                Navigator.pushNamed(context, LoginScreen.route);
              },
              color: Colors.lightBlueAccent,
              text: 'Login',
            ),
            RoundRecButton(
              text: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
