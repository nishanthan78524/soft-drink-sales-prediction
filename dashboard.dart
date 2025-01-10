import 'package:flutter/material.dart';
import 'package:srn_app/pages/barcode_scanner.dart';
import 'package:srn_app/pages/modify_product.dart';
import 'package:srn_app/pages/prediction_page.dart';
import 'package:srn_app/pages/weather_page.dart';

import '../utils/primary_widget.dart';
import 'order_product.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(
              fontSize: 25, color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyWidget(widgetTitle: 'Get Sales Forecast', widgetImage: Image.asset('assets/images/prediction.jpg'), widgetFunction: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderProduct()));
              }),
              MyWidget(widgetTitle: 'Order Product', widgetImage: Image.asset('assets/images/add_item.jpg'), widgetFunction: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PredictionPage()));
              }),
              MyWidget(widgetTitle: 'Modify Product', widgetImage: Image.asset('assets/images/delete_item.jpg'), widgetFunction: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyProduct()));
              }),
              MyWidget(widgetTitle: 'Barcode Scanner', widgetImage: Image.asset('assets/images/delete_item.jpg'), widgetFunction: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BarcodeScannerPage()));
              })
            ],
          ),
        ),
      ),
    );
  }
}
