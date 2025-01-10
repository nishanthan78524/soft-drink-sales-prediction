import 'package:flutter/material.dart';

class PrimaryLabel extends StatefulWidget {
  //const PrimaryLabel({Key? key}) : super(key: key);

  String labelText;

  PrimaryLabel(this.labelText);

  @override
  State<PrimaryLabel> createState() => _PrimaryLabelState();
}

class _PrimaryLabelState extends State<PrimaryLabel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 20,
          right: 20
      ),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
      child: Text(widget.labelText, style: TextStyle(color: Colors.white, fontSize: 15),),
    );
  }
}
