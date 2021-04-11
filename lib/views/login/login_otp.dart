import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/views/home/HomePage.dart';
import 'package:movie_app/views/login/otp_verify.dart';
import 'package:movie_app/widgets/button.dart';

class LoginOtp extends StatefulWidget {
  @override
  _LoginOtpState createState() => _LoginOtpState();
}

class _LoginOtpState extends State<LoginOtp> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("firebase initialization completed");
    });
  }

  final _phoneController = TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: size.height * 0.05),
                child: Lottie.asset(
                  "assets/jsons/otp.json",
                  height: size.height * 0.4,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: size.height * 0.45,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 5.0),
                        ),
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10.0,
                      margin: EdgeInsets.all(12.0),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Login with mobile number\n\n\n",
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0278AE),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "We will send you an",
                                      style: TextStyle(
                                        color: Color(0xFF373A40),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " One Time Password (OTP) ",
                                      style: TextStyle(
                                        color: Color(0xFF373A40),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: "on this mobile number"),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: size.height * 0.045),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    controller: _phoneController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.length != 10) {
                                        return "Please Enter valid phone number";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefix: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text('+91'),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD4D4D4),
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD4D4D4),
                                          width: 1.0,
                                        ),
                                      ),
                                      hintText: "Enter Your Mobile Number.",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Button(
                    size: size,
                    text: "Send OTP",
                    press: () {
                      if (formKey.currentState.validate()) {
                        final phone = _phoneController.text.trim();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpVerfication(phone)),
                        );
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
