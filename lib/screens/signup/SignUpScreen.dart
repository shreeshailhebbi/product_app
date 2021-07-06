import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product_app/Loader/Loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/screens/login/LoginScreen.dart';
import 'package:product_app/utilities/constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _emailError = false;
  bool _passwordError = false;
  bool _isLoading = false;
  bool _confirmPasswordError = false;
  String confirmErrorText = "Confirm Password can\'t be empty";

  signUp() async {
    FocusScope.of(context).unfocus();
    var email = _emailController.text;
    var password = _passwordController.text;
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = true;
      });
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = true;
      });
    }
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = true;
      });
    } else {
      if (_confirmPasswordController.text == _passwordController.text) {
        setState(() {
          _isLoading = true;
        });
        try {
          UserCredential user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          getToastBar("Email and Password Registered Successfully..!");

          if (user.user != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          getToastBar("Enter valid Email and Password");
          print(e.message);
        }
      }
      setState(() {
        _confirmPasswordError = true;
        confirmErrorText = "Password and Confirm Password Does'nt Match!";
      });
    }
  }

  getToastBar(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewPortConstraints) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                      kPrimaryColor,
                      kPrimaryColor2,
                      kPrimaryLightColor
                    ])),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: MediaQuery.of(context).padding,
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Product App",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Sign Up",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60))),
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 30, right: 30, left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    255, 95, 27, 0.3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ]),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 18),
                                        onChanged: (text) {
                                          setState(() {
                                            text.isEmpty
                                                ? _emailError = true
                                                : _emailError = false;
                                          });
                                        },
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: buildInputDecoration(
                                          Icons.email,
                                          "Email",
                                        ),
                                        validator: (value) {
                                          if (value.length == null) {
                                            return 'Email must not be null';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    _emailError
                                        ? Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Email can\'t be empty",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(height: 15),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    255, 95, 27, 0.3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ]),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 18),
                                        onChanged: (text) {
                                          setState(() {
                                            text.isEmpty
                                                ? _passwordError = true
                                                : _passwordError = false;
                                          });
                                        },
                                        controller: _passwordController,
                                        keyboardType: TextInputType.text,
                                        decoration: buildInputDecoration(
                                            Icons.lock, "Password"),
                                      ),
                                    ),
                                    _passwordError
                                        ? Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Password can\'t be empty",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(height: 15),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    255, 95, 27, 0.3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ]),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 18),
                                        onChanged: (text) {
                                          setState(() {
                                            text.isEmpty
                                                ? _confirmPasswordError = true
                                                : _confirmPasswordError = false;
                                          });
                                        },
                                        controller: _confirmPasswordController,
                                        keyboardType: TextInputType.text,
                                        decoration: buildInputDecoration(
                                            Icons.lock, "Confirm Password"),
                                      ),
                                    ),
                                    _confirmPasswordError
                                        ? Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              confirmErrorText,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  signUp();
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: kPrimaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: kPrimaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          Container(
              child: _isLoading
                  ? Loader(
                      isCustom: true, loadingTxt: 'Logging In...', opacity: 0.7)
                  : Container())
        ]));
  }

  InputDecoration buildInputDecoration(IconData icon, String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16),
        prefixIcon: Icon(icon),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
        ),
        border: InputBorder.none);
  }
}
