import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/pages/done.dart';
import 'package:provider/provider.dart';
import 'package:news_app/utils/app_name.dart';
import 'package:news_app/utils/next_screen.dart';

class MobileVerification extends StatefulWidget {
  MobileVerification({Key? key}) : super(key: key);

  @override
  State<MobileVerification> createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  String countryCode = '+91';
  TextEditingController phncontroller = new TextEditingController();
  TextEditingController otpcontroller = new TextEditingController();
  String? verification;
  bool verify = false;

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppName(
                    fontSize: 30,
                  ),
                ],
              ),
              Text(
                'Please Verify Your Mobile',
                style: TextStyle(fontSize: 18),
              ),
              ListTile(
                leading: CountryCodePicker(
                  onChanged: (value) {
                    countryCode = value.dialCode!;
                  },
                  initialSelection: 'US',
                  favorite: ['US', 'BR', 'IN'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
                title: Container(
                    child: TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 20),
                  cursorColor: Colors.grey,
                  controller: phncontroller,
                  decoration: InputDecoration(
                    hintText: 'Enter Number',
                    hintStyle: TextStyle(fontSize: 18),
                    focusColor: Colors.red,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                )),
              ),
              Text(
                'This is only for authentication purpose',
                style: TextStyle(fontSize: 18),
              ),
              verify == true
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 20),
                        cursorColor: Colors.grey,
                        controller: otpcontroller,
                        decoration: InputDecoration(
                          hintText: 'Enter Otp',
                          hintStyle: TextStyle(fontSize: 18),
                          focusColor: Colors.red,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              verify == false
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          verify = true;
                        });
                        verifyNo(phncontroller.text);
                      },
                      child: button('Send Otp'))
                  : InkWell(
                      onTap: () async {
                        await verifyOtp(otpcontroller.text, sb);
                      },
                      child: button('Verify Otp'))
            ],
          ),
        ),
      ),
    );
  }

  Widget button(String text) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          color: Colors.indigo, borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  verifyOtp(otp, SignInBloc sb) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verification!, smsCode: otp);

    _auth
        .signInWithCredential(credential)
        .then((value) => FirebaseFirestore.instance
            .collection("users")
            .doc(sb.uid)
            .set({'mobileNo': phncontroller.text}, SetOptions(merge: true)))
        .then((value) => nextScreen(context, DonePage()));
    print(credential);
  }

  Future verifyNo(String number) async {
    number = countryCode + number.toString();

    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (phoneAuthCredential) async {},
      verificationFailed: (FirebaseAuthException e) {
        print("kkkkkkkkkkkkkkkkkkkkkkk${e.message}");
      },
      codeSent: (verificationId, [code]) {
        setState(() {
          verification = verificationId;
        });
        print(verificationId);
        print(code.toString());
      },
      codeAutoRetrievalTimeout: (time) {
        print(time);
      },
    );
  }
}
