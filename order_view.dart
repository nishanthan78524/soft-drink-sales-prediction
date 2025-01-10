import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderedListPage extends StatefulWidget {
  @override
  _OrderedListPageState createState() => _OrderedListPageState();
}

class _OrderedListPageState extends State<OrderedListPage> {
  // This will hold the fetched data
  List<dynamic> _productList = [];
  bool _isLoading = false; // For showing a loading indicator

  @override
  void initState() {
    super.initState();
    // Fetch the product list when the page loads
    _fetchProductList();
  }

  // Function to fetch product list from API
  Future<void> _fetchProductList() async {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching
    });

    try {
      var url = Uri.parse('http://endeers.com.preview.services/get_trolly.php');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the response body into JSON format
        var jsonData = json.decode(response.body);

        setState(() {
          _productList = jsonData; // Assign the product list
          _isLoading = false; // Stop showing loading indicator
        });
      } else {
        // Handle error responses
        setState(() {
          _isLoading = false; // Stop showing loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch product list.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop showing loading indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sales Forecast List is Empty!')),
      );
    }
  }

  // Function to delete a product from the list
  /*Future<void> _deleteProduct(int index) async {
    // You can add logic here to make an API call to delete the item from the server.
    // For example:
    var url = Uri.parse('http://endeers.com.preview.services/delete_product.php');
    var response = await http.post(url, body: {
      'barcode': _productList[index]['barcode'].toString(),
    });

    if (response.statusCode == 200) {
      setState(() {
        _productList.removeAt(index); // Remove the product from the list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product.')),
      );
    }
  }*/

  // Function to delete a product from the list
  Future<void> _deleteProduct(int index) async {
    var barcode = _productList[index]['barcode'].toString();
    var product = _productList;
    var url = Uri.parse('http://endeers.com.preview.services/delete_trolly.php?barcode=$barcode');

    try {
      var response = await http.get(url); // Use GET request instead of POST

      // Log the response body for debugging
      //print('Response: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body); // Decode the response to check the message
        //print(product);
        if (data['success'] == true) {
          setState(() {
            _productList.removeAt(index); // Remove the product from the list
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product deleted successfully!')),
          );
        } else {
          // Display the failure message from the response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        centerTitle: true,
        title: const Text(
          'Sales Forecast List',
          style: TextStyle(
            fontSize: 25,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading while fetching
          : _productList.isEmpty
          ? Center(child: Text('No products available')) // Show when no data
          : ListView.builder(
        itemCount: _productList.length,
        itemBuilder: (context, index) {
          var product = _productList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['product'] ?? 'Unknown Product',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Brand: ${product['brand']?.isEmpty ?? true ? "No Brand" : product['brand']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        Text(
                          'Price: £${product['price'] ?? '0.00'}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        Text(
                          'Measure: ${product['measure']?.isEmpty ?? true ? "N/A" : product['measure']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        Text(
                          'Suggested Quantity: ${product['suggested_qty'] ?? '0'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(index), // Delete product when pressed
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
