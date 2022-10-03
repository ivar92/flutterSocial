import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttersocial/controller/auth_controller.dart';
import 'package:fluttersocial/controller/main_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (!kIsWeb) {
  await Firebase.initializeApp();
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (BuildContext context, snapshot) {
          return (snapshot.hasData) ? MainController(memberUid: snapshot.data!.uid) : AuthController();
        },
      ),
    );
  }
}
