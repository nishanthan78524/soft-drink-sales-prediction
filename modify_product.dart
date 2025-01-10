import 'dart:convert';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/primary_button.dart';
import '../utils/primary_textfield.dart';

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({Key? key}) : super(key: key);

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  TextEditingController barcodeController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController measureController = TextEditingController();

  bool isProductFetched = false; // To track if product details are fetched

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

  Future<void> _modifyProduct() async {
    var url = Uri.parse('http://endeers.com.preview.services/modify_product.php'); // Your modify product endpoint
    try {
      var response = await http.post(url, body: {
        "barcode": barcodeController.text,
        "product_name": productController.text,
        "price": priceController.text,
        "brand": brandController.text,
        "department": departmentController.text,
        "measure": measureController.text
      });

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? 'Product modified successfully!'))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to modify product: ${jsonResponse['message']}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
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
          'Modify Product',
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
            PrimaryButton('Modify Product', () async {
              await _modifyProduct();
            }),
          ],
        ),
      ),
    );
  }
}
