import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:srn_app/utils/primary_button.dart';
import 'package:srn_app/utils/primary_textfield.dart';

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  TextEditingController barcodeController = TextEditingController();
  String _responseMessage = ''; // To display the prediction result
  bool _isLoading = false; // To show a loading indicator

  // Method to send POST request and get sales prediction
  Future<void> getSalesPrediction() async {
    setState(() {
      _isLoading = true;
      _responseMessage = ''; // Clear previous response
    });

    var barcode = barcodeController.text.trim();
    if (barcode.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a barcode')),
      );
      return;
    }

    var url = Uri.parse('https://srnapp-91e7b34fe537.herokuapp.com/predict_sales');

    // JSON body for the request
    var data = {
      "barcodes": [int.parse(barcode)],
      "weather": [
        {
          "tempmax": 30,
          "tempmin": 20,
          "temp": 25,
          "feelslikemax": 30,
          "feelslikemin": 20,
          "feelslike": 25,
          "dew": 15,
          "humidity": 60,
          "precip": 0.0,
          "precipprob": 10,
          "precipcover": 0.1,
          "snow": 0.0,
          "snowdepth": 0,
          "windgust": 10,
          "windspeed": 5,
          "winddir": 180,
          "sealevelpressure": 1010,
          "cloudcover": 20,
          "visibility": 10,
          "solarradiation": 200,
          "solarenergy": 5,
          "uvindex": 3,
          "severerisk": 0,
          "moonphase": 0.5
        }
      ]
    };

    try {
      // Send POST request
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data), // Convert data to JSON format
      );

      setState(() {
        _isLoading = false; // Stop loading indicator
      });

      // Check if the response is successful
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        // Handle the response here (assuming it returns some useful info)
        setState(() {
          _responseMessage = 'Prediction Response: ${response.body}';
        });
      } else {
        // Handle error response
        setState(() {
          _responseMessage = 'Failed to get prediction. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Prediction'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom TextField for barcode input
            PrimaryTextField('Enter Barcode', barcodeController),
            SizedBox(height: 20), // Add space between the TextField and Button

            // Custom Primary Button to trigger prediction
            PrimaryButton('Get Sales Prediction', () {
              if (!_isLoading) {
                getSalesPrediction(); // Trigger prediction request
              }
            }),

            SizedBox(height: 20),

            // Display the response or any error message
            if (_responseMessage.isNotEmpty) ...[
              Text(
                'Response:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                _responseMessage,
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
