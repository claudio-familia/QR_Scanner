import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner/src/models/scan_model.dart';

class MapVisorPage extends StatefulWidget {

  @override
  _MapVisorPageState createState() => _MapVisorPageState();
}

class _MapVisorPageState extends State<MapVisorPage> {
  MapController _mapController = new MapController();  
  int index = 0;
  String mapType = '';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordinates'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_searching), 
            onPressed: (){
              setState(() {                
                _mapController.move(scan.getLatLng(), 15);
              });
            }
          )
        ],
      ),
      body: _setMapView(scan),
    );
  }

  Widget _setMapView(ScanModel scan) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(        
        center: scan.getLatLng(),
        zoom: 15,            
      ),      
      layers: [
        _createMaps(),
        _createMaker(scan)
      ],
    );
  }

  _toggleMap() {
    var mapList = ['satellite'];

    setState(() {
      //index += index == (mapList.length - 1) ? -(mapList.length - 1) : 1;
      mapType = 'mapbox.${mapList[index]}';
    });
  }

  _createMaps() {
    _toggleMap();

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        "accessToken" : "pk.eyJ1IjoiY2xhdWRpby1mYW1pbGlhIiwiYSI6ImNrYm1oMGdsczFpbngydG15eWgyZjFnMXcifQ.0pPrlnPSuWlGqbJXRuKkWA",
        "id"          : mapType
        // streets, dark, light, outdoors, satellite
      }
    );
  }

  _createMaker(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          point: scan.getLatLng(),
          width: 100.0,
          height: 100.0,
          builder: (context) => Container(
            child: Icon(Icons.location_on, size: 70.0, color: Theme.of(context).primaryColor,),
          )
        )
      ]
    );
  }
}