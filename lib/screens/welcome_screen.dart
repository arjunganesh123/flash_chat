import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/Rounded_Button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id='Welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  Animation animate;
  // bool note=false;
  @override
  void initState() {
    super.initState();
    controller=AnimationController(
        vsync: this,
        duration: Duration(seconds: 3));
    
    animation=CurvedAnimation(parent: controller, curve: Curves.bounceOut);

    animate=ColorTween(begin: Colors.red,end: Colors.blue).animate(controller);

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animate.value,
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
                    height: animation.value*60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text:['Flash Chat'],
                  textStyle:const TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Roundedbutton(colour: Colors.lightBlueAccent,onpressed: (){Navigator.pushNamed(context, LoginScreen.id);},text:'Log In',),
            Roundedbutton(colour: Colors.blueAccent,onpressed: (){Navigator.pushNamed(context, RegistrationScreen.id);},text:'Register',),
          ],
        ),
      ),
    );
  }
}