class WeightModel {
  String? uid;
  String? date;
  String? weight;

  //constructor function
  WeightModel({
    this.uid,
    this.date,
    this.weight,
  });

  //creating function from map to recive the values from firebase(deseralisation)
  WeightModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    date = map["date"];
    weight = map["weight"];
  }

  //funtion to generate map  for sending data to firebase (serealisation)
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "date": date,
      "weight": weight,
    };
  }
}
