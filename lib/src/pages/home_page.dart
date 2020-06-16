import 'package:flutter/material.dart';

import 'package:super_qr_reader/super_qr_reader.dart';
import 'package:qrscanner/src/pages/address_page.dart';
import 'package:qrscanner/src/pages/map_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;  
  String qrScanned = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        centerTitle: true,
        toolbarOpacity: 0.8,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete_forever), onPressed: () {})
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _setBottomNavigationBar(),
      floatingActionButton: _setFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }    

  Widget _setBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
         BottomNavigationBarItem(
           icon: Icon(Icons.map),
           title: Text('Maps')
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.settings),
           title: Text('Addresses')
         )
      ],
    );
  }

  Widget _callPage(int indexPage) {

    switch(indexPage) {
      case 0: return MapPage();
      case 1: return AddressPage();

      default: return MapPage();
    }

  }

  Widget _setFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        scanQR(context);
      },
      child: Icon(Icons.camera_enhance),
      backgroundColor: Theme.of(context).primaryColor,   
    );
  }

  void scanQR(BuildContext context) async {    
    try {                  
      String results = await Navigator.push( // waiting for the scan results
        context,
        MaterialPageRoute(
          builder: (context) => ScanView(),
        ),
      );

      if (results != null) {
        setState(() {
          qrScanned = results;
        });
      }
    }catch (e) {
      qrScanned = e.toString();
    }

    print('Future string: '+qrScanned);

    if( qrScanned != null) {
      print('we got info');
    }
  }
}