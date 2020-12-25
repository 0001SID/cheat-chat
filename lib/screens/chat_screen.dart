import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'login_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

bool isMe;
String loggedInUser;
TextEditingController chatBoxController = TextEditingController();

class ChatScreen extends StatefulWidget {
  static const String route = '/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth;
  Firestore _firestore;
  FirebaseUser _user;
  String _messageText;

  void getCurrentUser() async {
    _user = await _auth.currentUser();
    if (_user.email != null) {
      loggedInUser = _user.email;
    } else {
      Navigator.pushNamed(context, LoginScreen.route);
    }
  }

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: chatBoxController,
                      onChanged: (value) {
                        _messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      chatBoxController.clear();
                      _firestore.collection('messages').add({
                        'message': _messageText,
                        'sender': _user.email,
                        'time': DateTime.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  MessageStream({
    @required Firestore firestore,
  }) : _firestore = firestore;

  final Firestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlue,
          ));
        }
        final allDocuments = snapshot.data.documents;
        List<MessageBubble> messages = [];
        for (var message in allDocuments) {
          final newMessage = message['message'];
          final sender = message['sender'];
          if (loggedInUser == sender) {
            isMe = true;
          } else {
            isMe = false;
          }
          messages.add(MessageBubble(
            message: newMessage,
            sender: sender,
            isMe: isMe,
          ));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.all(10),
            children: messages,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message, sender;
  final bool isMe;
  MessageBubble({this.message, this.sender, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Material(
            elevation: 6,
            color: isMe ? Colors.blue : Colors.white,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
