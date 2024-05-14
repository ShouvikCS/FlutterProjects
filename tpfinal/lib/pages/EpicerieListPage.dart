import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/epicerie.dart';

class EpicerieListPage extends StatefulWidget {
  @override
  _EpicerieListPageState createState() => _EpicerieListPageState();
}

class _EpicerieListPageState extends State<EpicerieListPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Epicerie List"),
      ),
      body: StreamBuilder(
        stream: _db.collection('Epicerie').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<dynamic> epiceries = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return Epicerie.fromJson(data);
          }).toList();

          return ListView.builder(
            itemCount: epiceries.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(epiceries[index].nom),
                subtitle:
                    Text(epiceries[index].dateDeCreation.toIso8601String()),
                onTap: () {
                  // Navigate to a detail page or perform another action
                },
              );
            },
          );
        },
      ),
    );
  }
}
