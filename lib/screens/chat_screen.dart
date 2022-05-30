import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firestore=FirebaseFirestore.instance;
User loggedinuser;

class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textcontroller=TextEditingController();
  String messages;
  final _auth=FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser(){
   try{
     final user=_auth.currentUser;
     if(user!=null){
       loggedinuser=user;
     }
   }
   catch(e){
     print(e);
   }
  }

  // void getmessage() async{
  //   final messagetext=await _firestore.collection('messages').get();
  //   for(var message in messagetext.docs){
  //     print(message.data());
  //   }
  // }

  // void getmessage() async{
  //   await for(var snapshot in _firestore.collection('messages').snapshots()){
  //     for(var message in snapshot.docs){
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async{
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, ModalRoute.withName('/'));
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
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textcontroller,
                      onChanged: (value) {
                        messages=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textcontroller.clear();
                      _firestore.collection('messages').add({
                        'text':messages,
                        'sender':loggedinuser.email,
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final message=snapshot.data.docs.reversed;
        List<Messagebubble> messagewidget=[];
        for(var message in message){
          final messagetext=message.get('text');
          final messagesender=message.get('sender');


          final messagelay=Messagebubble(text: messagetext,sender: messagesender,isme:loggedinuser.email==messagesender);
          messagewidget.add(messagelay);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            children: messagewidget,
          ),
        );
      },
    );
  }
}


class Messagebubble extends StatelessWidget {
  Messagebubble({this.text,this.sender,this.isme});
  final String text;
  final String sender;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isme ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(fontSize: 8,color: Colors.black45),),
          Material(
            borderRadius:isme ? BorderRadius.only(topLeft:Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30),topRight:Radius.circular(0)):BorderRadius.only(topLeft: Radius.circular(0),topRight:Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30) ),
            elevation: 5,
            color:isme ? Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text(text,style: TextStyle(fontSize: 15,color:isme ? Colors.white:Colors.black),),
            ),
          ),
        ],
      ),
    );
  }
}
