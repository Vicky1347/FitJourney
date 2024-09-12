class UserModel {
  String? uid;
  String? fullname;
  String? email;

  //constructor function
  UserModel({
    this.uid,
    this.fullname,
    this.email,
  });

  //creating function from map to recive the values from firebase(deseralisation)
  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
  }

  //funtion to generate map  for sending data to firebase (serealisation)
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
    };
  }
}
