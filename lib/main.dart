import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitjourney/Model/UserModel.dart';
import 'package:fitjourney/Pages/Home.dart';
import 'package:fitjourney/Pages/signup.dart';
import 'package:fitjourney/firebase_options.dart';
import 'package:fitjourney/widgets/firebase_healper.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid(); //can be use in whole app

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const MyApp());
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelByID(currentUser.uid);
    if (thisUserModel != null) {
      runApp(MyAppLoggindIn(
        firebaseUser: currentUser,
        userModel: thisUserModel,
      ));
    }
  } else {
    //Not logged in
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.light(),
        useMaterial3: true,
      ),
      home: SignUpPage(),
    );
  }
}

class MyAppLoggindIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggindIn(
      {super.key, required this.userModel, required this.firebaseUser});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(
        //     seedColor: Colors.blue,
        //     primary: Colors.blue[500], // Set primary color (darker shade)
        //     secondary: Colors.teal[300]),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: HomePage(
        uid: firebaseUser.uid,
      ),
    );
  }
}
