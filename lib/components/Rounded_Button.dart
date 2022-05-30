import 'package:flutter/material.dart';

class Roundedbutton extends StatelessWidget {
 final Color colour;
 final Function onpressed;
 final String text;

 Roundedbutton({this.colour,this.onpressed,this.text});

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed:onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            '$text',
          ),
        ),
      ),
    );
  }
}
