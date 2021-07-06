import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product_app/screens/login/LoginScreen.dart';
import 'package:product_app/screens/product/AddProductScreen.dart';
import 'package:product_app/utilities/Shimmer.dart';

import 'package:product_app/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QueryDocumentSnapshot> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('product');
    collectionReference.snapshots().listen((snapshot) {
      setState(() {
        _isLoading = false;
        _products = snapshot.docs;
      });
    });
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Product App"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                getToastBar("Successfully Logged Out!");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              })
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return fetchData();
          },
          child: !_isLoading
              ? _products.length > 0
                  ? Container(
                      padding: EdgeInsets.only(top: 5, right: 3, left: 3),
                      child: ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2),
                                      child: Image.network(
                                        _products[index]['image'],
                                        fit: BoxFit.cover,
                                        width: 180,
                                        height: 150,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _products[index]['name']
                                                  .toString()
                                                  .toUpperCase(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Price :- ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: "\$" +
                                                          _products[index]
                                                              ['price'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Description :- ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: _products[index]
                                                          ['description'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          }))
                  : Container(
                      child: Center(
                        child: Text(
                          "No Products Available!",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    )
              : ShimmerScreen(
                  height: 200,
                  width: width -20,
                  vertical: false,
                  listView: true,
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProductScreen()));
        },
      ),
    );
  }
}
