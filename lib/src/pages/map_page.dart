import 'package:flutter/material.dart';

import 'package:qrscanner/src/utils/utils_helpers.dart' as Helpers;
import 'package:qrscanner/src/blocs/scan_bloc.dart';
import 'package:qrscanner/src/providers/db_provider.dart';

class MapPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.getScans('geo');

    return StreamBuilder(
      stream: scansBloc.scansStream,      
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        
        if( !snapshot.hasData ) return Center(child: CircularProgressIndicator(),);

        final scans = snapshot.data;
      
        if(scans.length == 0) return Center(child: Text('No data saved'),);

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.redAccent,
                child: Center(
                  child: Text('Delete item', style: TextStyle(color: Colors.white, fontSize: 16.0),),
                ),
              ),
              onDismissed: ( direction ) => scansBloc.deleteScan(scans[index].id),              
              child: ListTile(
                leading: Icon(Icons.map, color: Theme.of(context).primaryColor,),
                title: Text(scans[index].value),
                onTap: () {
                  Helpers.launchURL(context, scans[index]);
                },
                subtitle: Text('ID: ${scans[index].id}'),
                trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).primaryColor),              
              ),
            );
          },
        );
      },
    );
  }
}