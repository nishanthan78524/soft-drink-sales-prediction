/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/primary_button.dart';
import '../utils/primary_textfield.dart';
import '../utils/resources.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({Key? key}) : super(key: key);

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  TextEditingController barcodeController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController measureController = TextEditingController();
  TextEditingController orderQtyController = TextEditingController();

  List<Purchase> _items = [];

  /*_scan() {
    FlutterBarcodeScanner.scanBarcode(
        '#000000', 'Cancel', true, ScanMode.BARCODE)
        .then((value) {
      setState(() {
        barcodeController.text = value;
      });
      print(value);
    });
  }*/

  Future<void> _addTrolly() async {
    var url = Uri.parse('http://endeers.com.preview.services/add_trolly.php');
    try {
      var response = await http.post(url, body: {
        "brand": brandController.text,
        "barcode": barcodeController.text,
        "product": productController.text,
        "price": priceController.text,
        "measure": measureController.text,
        "suggested_qty": orderQtyController.text
      });

      var responseBody = response.body;
      var jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? 'Product Ordered successfully!'))
        );
      } else {
        // Show the error returned by the server
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add product: ${jsonResponse['message']}'))
        );
      }
    } catch (e) {
      // Handle connection or request errors
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
  }

  // Fetch product details by barcode
  _fetchProductDetails() async {
    var barcode = barcodeController.text.trim();

    // Handle empty barcode
    if (barcode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or scan a barcode')),
      );
      return;
    }

    var url = Uri.parse(
        'http://endeers.com.preview.services/get_product.php?barcode=$barcode');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var productData = json.decode(response.body);

        if (productData.containsKey('error')) {
          // Show error message if product not found
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(productData['error'])));
        } else {
          // Populate the text fields with the product data
          setState(() {
            productController.text = productData['product_name'] ?? 'Unknown';
            priceController.text = productData['price']?.toString() ?? '0';
            brandController.text = productData['brand'] ?? 'Unknown';
            measureController.text = productData['measure'] ?? 'Unknown';
            departmentController.text = productData['department'] ?? 'Unknown';
          });
        }
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch product details')));
        print('Error: ${response.body}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
      print('Exception: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.blueGrey,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Order Stock',
          style: TextStyle(
              fontSize: 25, color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryTextField('Bar Code', barcodeController),
                ),
                IconButton(
                  icon: const Icon(Icons.barcode_reader),
                  onPressed: () async {
                    //_scan();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    _fetchProductDetails();
                  },
                ),
              ],
            ),
            PrimaryTextField('Product', productController),
            PrimaryTextField('Price', priceController),
            PrimaryTextField('Brand', brandController),
            PrimaryTextField('Department', departmentController),
            PrimaryTextField('Measure', measureController),
            PrimaryTextField('Order Quantity', orderQtyController),
            PrimaryButton('Add to Trolley', () async {
              _addTrolly();
            }),
            PrimaryButton('View Order List', (){
              //Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListPage()));
            }),
          ],
        ),
      ),
    );
  }
}*/

import 'dart:convert';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/primary_button.dart';
import '../utils/primary_textfield.dart';
import '../utils/resources.dart';
import 'order_view.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({Key? key}) : super(key: key);

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  TextEditingController barcodeController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController measureController = TextEditingController();
  TextEditingController suggestedQtyController = TextEditingController();

  String _responseMessage = ''; // To display the prediction result
  bool _isLoading = false; // To show a loading indicator

  String scannedBarcode = 'No barcode scanned';

  // Function to start barcode scanning
  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();  // Start the barcode scanning
      if (result.rawContent.isNotEmpty) {
        setState(() {
          barcodeController.text = result.rawContent;  // Update the barcode text
          _fetchProductDetails();
        });
      }
    } catch (e) {
      setState(() {
        scannedBarcode = 'Failed to scan barcode: $e';
      });
    }
  }

  Future<void> _addTrolly() async {
    var url = Uri.parse('http://endeers.com.preview.services/add_trolly.php');
    try {
      var response = await http.post(url, body: {
        "brand": brandController.text,
        "barcode": barcodeController.text,
        "product": productController.text,
        "price": priceController.text,
        "measure": measureController.text,
        "suggested_qty": suggestedQtyController.text
      });

      var responseBody = response.body;
      var jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? 'Product Ordered successfully!'))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add product: ${jsonResponse['message']}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
  }

  // Fetch product details by barcode
  _fetchProductDetails() async {
    var barcode = barcodeController.text.trim();

    if (barcode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or scan a barcode')),
      );
      return;
    }

    var url = Uri.parse(
        'http://endeers.com.preview.services/get_product.php?barcode=$barcode');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var productData = json.decode(response.body);

        if (productData.containsKey('error')) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(productData['error'])));
        } else {
          setState(() {
            productController.text = productData['product_name'] ?? 'Unknown';
            priceController.text = productData['price']?.toString() ?? '0';
            brandController.text = productData['brand'] ?? 'Unknown';
            measureController.text = productData['measure'] ?? 'Unknown';
            departmentController.text = productData['department'] ?? 'Unknown';
          });

          // Wait for the prediction result, then update the suggested quantity
          await getSalesPrediction();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch product details')));
        print('Error: ${response.body}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
      print('Exception: $error');
    }
  }

  // Method to send POST request and get sales prediction
  /*Future<void> getSalesPrediction() async {
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

    var data = {
      "barcodes": [int.parse(barcode)]
    };

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var predictedQuantity = responseData[barcode];

        // Set the response message or predicted quantity
        setState(() {
          _responseMessage = predictedQuantity != null
              ? predictedQuantity.toString()
              : 'No prediction available';
          suggestedQtyController.text = _responseMessage; // Update the text field
        });
      } else {
        setState(() {
          _responseMessage =
          'Failed to get prediction. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseMessage = 'Error: $e';
      });
    }
  }*/

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

    var data = {
      "barcodes": [int.parse(barcode)]
    };

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var predictedQuantity = responseData[barcode];

        // Set the response message or predicted quantity
        setState(() {
          _responseMessage = predictedQuantity != null
              ? predictedQuantity.toString()
              : 'App cannot predict suggestion';  // Change here for invalid prediction
          suggestedQtyController.text = _responseMessage; // Update the text field
        });
      } else {
        // Change here for when status code is not 200
        setState(() {
          _responseMessage = 'App cannot predict suggestion';  // Change here
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseMessage = 'App cannot predict suggestion';  // Change here for general error
      });
    }
  }

  void clearTextFields(){
    setState(() {
      barcodeController.clear();
      productController.clear();
      priceController.clear();
      brandController.clear();
      departmentController.clear();
      measureController.clear();
      suggestedQtyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.blueGrey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Get Prediction',
          style: TextStyle(
              fontSize: 25, color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryTextField('Bar Code', barcodeController),
                ),
                IconButton(
                  icon: const Icon(Icons.barcode_reader),
                  onPressed: () async {
                    scanBarcode();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    _fetchProductDetails();
                  },
                ),
              ],
            ),
            PrimaryTextField('Product', productController),
            PrimaryTextField('Price', priceController),
            PrimaryTextField('Brand', brandController),
            PrimaryTextField('Department', departmentController),
            PrimaryTextField('Measure', measureController),
            PrimaryTextField('Suggested Quantity', suggestedQtyController),
            PrimaryButton('Add to Forecast List', () async {
              _addTrolly();
              clearTextFields();
            }),
            PrimaryButton('View Forecast List', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderedListPage()));
            }),
          ],
        ),
      ),
    );
  }
}
