import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/widgets/button.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

import '../home/HomePage.dart';

class OtpVerfication extends StatefulWidget {
  final String phone;
  OtpVerfication(this.phone);
  @override
  _OtpVerficationState createState() => _OtpVerficationState(phone);
}

class _OtpVerficationState extends State<OtpVerfication> {

  final String phone;
  _OtpVerficationState(this.phone);

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget showSnackbar(String msg){
    return SnackBar(
        content: Text(msg,
          style: GoogleFonts.nunito(
            //textStyle: Theme.of(context).textTheme.display1,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            //fontStyle: FontStyle.italic,
          ),
        ));
  }


  Future<bool> manualVerify() async{
    AuthCredential authCredential = PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: _otp);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(authCredential);
      User user = userCredential.user;
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>HomePage(user) ),
              (route) => false,
        );
      }
    } catch (e) {
      // TODO
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(

      showSnackbar("Invalid OTP")
      );
    }
  }

  String _verificationCode;
  String _otp;
  Future<bool> sendOTP(String phoneNumber, BuildContext context) async {

    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: "+91"+phoneNumber,
        timeout: Duration(seconds: 120),

        //forautomatic verification
        verificationCompleted: (AuthCredential credential) async {
          UserCredential userCredential = await _auth.signInWithCredential(
              credential);

          User user = userCredential.user;
          if (user != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>HomePage(user) ),
                  (route) => false,
            );
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          print("authentication failed "+authException.message);
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).showSnackBar(
              showSnackbar("Something went wrong")
          );
          Navigator.of(context).pop();
        },

        //manualverification
        codeSent: (String verificationId, [int forceResendingToken]) {
          print("code sent manual");
          setState(() {
            _verificationCode = verificationId;
            ScaffoldMessenger.of(context).showSnackBar(
                showSnackbar("OTP Sent")
            );
          });


        },
        codeAutoRetrievalTimeout:null

    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendOTP(phone, context);
  }



  final _otpController = TextEditingController();



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
              child: Lottie.asset(
                "assets/jsons/otp_verify.json",
                height: 300.0,
                width: 250.0,
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
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10.0,
                    margin: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 40.0),
                          padding: EdgeInsets.all(20.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Verification\n\n",
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0278AE),
                                  ),
                                ),
                                TextSpan(
                                  text: "Enter the OTP send to your mobile number",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF373A40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: PinEntryTextField(
                            showFieldAsBox: true,
                            fields: 6,
                            onSubmit: (String pin){

                              _otp = pin;

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Button(
                  size: size,
                  text: "Verify",
                  press: () {
                        manualVerify();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}