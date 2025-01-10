import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  //const PrimaryButton({Key? key}) : super(key: key);

  final String buttonTitle;
  final Function buttonFunction;

  PrimaryButton(this.buttonTitle, this.buttonFunction);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.buttonFunction();
      },
      child: Container(
        margin: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 20,
            right: 20
        ),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(widget.buttonTitle, style: TextStyle(color: Colors.white, fontSize: 15),),
        ),
      ),
    );
  }
}
