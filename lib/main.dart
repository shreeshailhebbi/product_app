import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:product_app/screens/login/LoginScreen.dart';
import 'package:product_app/utilities/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        backgroundColor: kPrimaryColor,
        animationDuration: Duration(microseconds: 150000),
        splashIconSize: 300,
        splash: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            new Expanded(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(100, 50, 100, 0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset("assets/productlogo.png",
                        fit: BoxFit.fitHeight),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Product App",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        screenFunction: () async {
          return LoginScreen();
        },
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

