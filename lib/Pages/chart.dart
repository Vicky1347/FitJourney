// StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(widget.uid)
//                       .collection('weight')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.active) {
//                       if (snapshot.hasData == true) {
//                         QuerySnapshot weighttable =
//                             snapshot.data! as QuerySnapshot;

//                         WeightModel weightmodel = WeightModel.fromMap(
//                             weighttable.docs[0].data() as Map<String, dynamic>);

//                         return SizedBox(
//                           height: 250,
//                           child: LineChart(
//                             LineChartData(lineBarsData: [
//                               LineChartBarData(spots: [
//                                 FlSpot(0, int.parse(weightmodel.weight!) * 1.0),
//                                 FlSpot(1, 2)
//                               ])
//                             ]
//                                 // read about it in the LineChartData section
//                                 ),
//                           ),
//                         );
//                       } else {
//                         return Text("enter weight table");
//                       }
//                     } else {
//                       return Text("loading...");
//                     }
//                   })