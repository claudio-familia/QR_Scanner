
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrscanner/src/models/scan_model.dart';

launchURL(BuildContext context, ScanModel scanItem) async {  

  if(scanItem.type == 'http') {
    if (await canLaunch(scanItem.value)) {
      await launch(scanItem.value);
    } else {
      throw 'Could not launch ${scanItem.value}';
    }
  } else {
    Navigator.pushNamed(context, 'map', arguments: scanItem);
  }  
}