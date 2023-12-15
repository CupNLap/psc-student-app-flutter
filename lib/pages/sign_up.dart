import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

enum SigningState {
  loading,
  enterPhoneNumber,
  codeSent,
  verificationCompleted,
  verificationFailed,
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _optController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  SigningState currentState = SigningState.enterPhoneNumber;

  String verificationId = '';

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    Widget getView() {
      switch (currentState) {
        case SigningState.loading:
          return const Center(child: CircularProgressIndicator());
        case SigningState.enterPhoneNumber:
          return Form(
            key: _signUpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _userNameController,
                  decoration: decorator("Name", "Ankit"),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: decorator("Phone Number", "9876543210"),
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Phone number to continue with OTP';
                    } else if (value.length != 10) {
                      return 'Please enter a valid 10 digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_signUpFormKey.currentState!.validate()) {
                      var phoneNumber = '+91${_phoneNumberController.text}';

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));

                      auth.verifyPhoneNumber(
                        phoneNumber: phoneNumber,
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          setState(() => currentState =
                              SigningState.verificationCompleted);
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          setState(() =>
                              currentState = SigningState.verificationFailed);
                        },
                        codeSent: (String id, int? resendToken) async {
                          // Update the UI - wait for the user to enter the SMS code
                          setState(() => {
                                currentState = SigningState.codeSent,
                                verificationId = id,
                              });
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );

                      setState(() => currentState = SigningState.loading);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[900],
                    shadowColor: Colors.red[900],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Send OTP'),
                )
              ],
            ),
          );
        case SigningState.codeSent:
          return Form(
            key: _otpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: decorator("Enter OTP", '000000'),
                  controller: _optController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_otpFormKey.currentState!.validate()) {
                      String smsCode = _optController.text;

                      // Create a PhoneAuthCredential with the code
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsCode);

                      // Sign the user in (or link) with the credential
                      auth.signInWithCredential(credential).then((value) {
                        var d = auth.currentUser!;
                        d.updateDisplayName(_userNameController.text);

                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(d.uid)
                            .set({
                          "uid": d.uid,
                          "name": _userNameController.text,
                          "phone": _phoneNumberController.text,
                        });
                      });
                      setState(() => currentState = SigningState.loading);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[900],
                    shadowColor: Colors.red[900],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Send OTP'),
                )
              ],
            ),
          );
        case SigningState.verificationCompleted:
          return const Center(child: Text('Verification Completed'));
        case SigningState.verificationFailed:
          return const Center(child: Text('Verification Failed'));
        default:
          return const Text("Something unknown happened");
      }
    }

    return Scaffold(
      backgroundColor: Colors.red[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: getView(),
      ),
    );
  }

  InputDecoration decorator(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(color: Colors.red),
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}
