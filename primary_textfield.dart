import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  //const PrimaryTextField({Key? key}) : super(key: key);

  final String labelText;
  final TextEditingController controller;

  PrimaryTextField(this.labelText, this.controller);

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 10
      ),
      child: TextFormField(
        validator: (value){
          if (value!.isEmpty){
            return 'Field can not be empty...';
          }
        },
        controller: widget.controller,
        decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Colors.blueGrey),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blueGrey)
            )
        ),
      ),
    );
  }
}
