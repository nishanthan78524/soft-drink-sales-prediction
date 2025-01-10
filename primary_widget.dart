import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  final String widgetTitle;
  final Image widgetImage; // Using Image widget directly
  final Function widgetFunction; // Function to be executed on tap

  // Constructor with super
  const MyWidget({
    Key? key,
    required this.widgetTitle,
    required this.widgetImage,
    required this.widgetFunction,
  }) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.widgetTitle, // Use widgetTitle or some unique identifier
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 250,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: widget.widgetImage.image, // Use widgetImage directly
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Positioned widget to place the text at bottom-left
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    widget.widgetTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey, // Ensuring visibility against image
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          // Call the widgetFunction when tapped
          widget.widgetFunction();
        },
      ),
    );
  }
}