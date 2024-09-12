//to fetch Usermodlel from the Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitjourney/Model/UserModel.dart';

class FirebaseHelper {
  //static helping to acess all function
  static Future<UserModel?> getUserModelByID(String uid) async {
    UserModel? userModel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docsnap.data() != null) {
      userModel = UserModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }

    //docsnap.data() is null return same userModel that was already null
    return userModel;
  }
}
