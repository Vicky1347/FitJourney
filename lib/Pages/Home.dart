// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:fitjourney/Model/weightModel.dart';
import 'package:fitjourney/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // -----
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('weight')
        .orderBy("date")
        .limit(7)
        .get();

    setState(() {
      chartData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FlSpot(
          //  day=data['date'].toString().substring(8);
          int.parse(data['date'].toString().substring(8)) * 1.0,
          int.parse(data['weight']) * 1.0, // Assuming timestamp is a double
        );
      }).toList();
      print(chartData[0]);
      print(chartData[1]);
    });
  }

  LineChartData sampleData() {
    return LineChartData(
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: chartData,
          isCurved: true,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }

  //----

  TextEditingController weightcontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  DateTime? selectedDate;

  void upload() async {
    print("Uploading...");
    String? date = selectedDate.toString().substring(0, 10);
    String? weight = weightcontroller.text;

    WeightModel weightModel = WeightModel(
      date: date,
      uid: widget.uid,
      weight: weight,
    );
    print("${widget.uid}");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('weight')
        .doc(uuid.v1())
        .set(weightModel.toMap())
        .then((value) => {print("-----sucessfully uploaded----")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [Icon(Icons.logout)],
      //   backgroundColor: Colors.deepPurple.shade200,
      // ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 15,
                shadowColor: const Color.fromARGB(255, 130, 130, 130),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 15, 15),
                  height: 280,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, interval: 1),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, interval: 1),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      //minX: 1,
                      //maxX: 7,
                      //minY: 0,
                      //maxY: 200,
                      lineBarsData: [
                        LineChartBarData(
                            spots: chartData,
                            barWidth: 4,
                            isCurved: true,
                            preventCurveOverShooting: true,
                            belowBarData: BarAreaData(
                                show: true,
                                color: Colors.lightBlue.withOpacity(0.1)),

                            //color: Colors.blue.shade600,
                            gradient: LinearGradient(colors: [
                              //Colors.red,
                              Colors.deepPurpleAccent,
                              Colors.lightBlueAccent
                            ])),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Your Progress",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.uid)
                        .collection('weight')
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData == true) {
                          QuerySnapshot weighttable =
                              snapshot.data as QuerySnapshot;

                          return SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemCount: weighttable.docs.length,
                              itemBuilder: (context, index) {
                                WeightModel weightmodel = WeightModel.fromMap(
                                    weighttable.docs[index].data()
                                        as Map<String, dynamic>);

                                return Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      //color: Colors.amber,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 245, 246, 247),
                                              Colors.lightBlue.shade50,
                                              Colors.lightBlue.shade100
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      //margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "${weightmodel.date}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: const Color.fromARGB(
                                                      255, 51, 48, 48),
                                                ),
                                                //style: TextStyle(color: Colors.white),
                                              )
                                            ],
                                          ),
                                          Expanded(child: Text("")),
                                          Container(
                                            //padding: EdgeInsets.all(15),
                                            //decoration: BoxDecoration(color: Colors.blue),
                                            child: Column(children: [
                                              Text(
                                                "${weightmodel.weight}" + " Kg",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: const Color.fromARGB(
                                                        255, 51, 48, 48)),
                                              ),
                                            ]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                // return ListTile(
                                //   title: Text("${weightmodel.date}"),
                                //   subtitle: Text("${weightmodel.weight}"),
                                // );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Text("Tap on + icon to add record"),
                          );
                        }
                      } else {
                        return Center(
                          child: Text("Plese cheak your connection"),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Details'), // Add a title for clarity
                content: Column(
                  mainAxisSize: MainAxisSize.min, // Constrain content size
                  children: [
                    CupertinoButton(
                      child: Text("Select Date"),
                      onPressed: () async {
                        selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2090));
                      },
                    ),
                    TextField(
                      controller: weightcontroller,
// Add a label for the second TextField if needed
                      decoration: InputDecoration(
                        labelText: "Enter weight",
// Add a label if necessary
                      ),
                    ),
                    CupertinoButton(
                      child: Text("Submit"),
                      onPressed: () async {
                        upload();
                        fetchData();
// Handle the form submission logic here
// Validate user input if necessary
// Close the dialog after successful submission
                        datecontroller.clear();
                        weightcontroller.clear();

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
