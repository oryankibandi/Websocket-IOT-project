import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Home Temperature Monitor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //connect();
  }

  List<double> temps = [];

  final Stream<QuerySnapshot> tempData = FirebaseFirestore.instance
      .collection('data')
      .orderBy('timestamp', descending: true)
      .snapshots();

  LineGraph dataGraph(double height, double width, List<Feature> features) {
    return LineGraph(
      features: features,
      size: Size(height, width),
      labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6'],
      labelY: ['25', '45', '65', '75', '85', '100'],
      graphOpacity: 0.5,
      verticalFeatureDirection: true,
      showDescription: true,
      graphColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: tempData,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('oops \n Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue[800],
                  ),
                );
              }

              List<Feature> features = [
                Feature(
                    data: temps.isNotEmpty ? temps : [0.0, 0.2, 0.1, 0.2, 0.3],
                    title: 'Temperature Data',
                    color: Colors.blue)
              ];
              print('>>>>>>');
              Iterable<dynamic> temperatures =
                  snapshot.data!.docs.map((e) => e['temperature']);
              //check if iterable temperatures is not empty

              print(temperatures.first);
              if (temps.length > 6) {
                temps.removeAt(0);
              }
              temps.add((temperatures.first.toDouble() / 100));
              print('temps List>> ${temps}');
              print('<<<<<<<');

              return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1,
                          color: Colors.grey,
                        )
                      ]),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  child:
                      dataGraph(size.height * 0.6, size.width * 0.8, features));
            }));
  }
}
