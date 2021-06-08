import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';




class MobileOTP extends StatefulWidget {
  @override
  _MobileOTPState createState() => _MobileOTPState();
}

class _MobileOTPState extends State<MobileOTP> {
  String _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();
  String id;

  @override
  String _numberError = '';
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Login'),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return ListView(
            children: [
              SizedBox(height: 55),
              Image.asset(
                Images.close_lock,
                width: 142,
                height: 142,
              ),
              SizedBox(height: 40),
              Center(
                  child: Text(
                'Please enter your registered mobile number to receive the One Time Password',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: ColorResources.getHintColor(context)),
              )),
              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),
                    Text(
                      'Mobile Number',
                      style: Theme.of(context).textTheme.headline2.copyWith(
                          color: ColorResources.getHintColor(context)),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      errorMessage: _numberError,
                      hintText: 'Mobile number',
                      isShowBorder: true,
                      controller: _numberController,
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 24),
                    !auth.isForgotPasswordLoading
                        ? CustomButton(
                            btnTxt: getTranslated('send', context),
                            onTap: () {
                              setState(() {
                                if (_numberController.text.isEmpty ||
                                    _numberController.text.length != 10) {
                                  if (_numberController.text.isEmpty) {
                                    _numberError = 'required';
                                    // showCustomSnackBar(
                                    //     getTranslated(
                                    //         'enter_email_address', context),
                                  } else if (_numberController.text.length !=
                                      10) {
                                    _numberError = 'Invalid number';
                                    // showCustomSnackBar(
                                    //     getTranslated('enter_valid_email', context),
                                    //     context);
                                  }
                                } else {
                                  _numberError = '';
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .forgetPassword(_numberController.text)
                                      .then((value) {
                                    if (value.isSuccess) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  VerificationScreen(
                                                      forLogin: true,
                                                      contact: _numberController
                                                          .text)));
                                    } else {
                                      showCustomSnackBar(
                                          value.message, context);
                                    }
                                  });
                                }
                              });
                            },
                          )

                        : Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorResources.COLOR_PRIMARY))),
                    TextFormField(
                      controller: _smsController,
                      decoration: const InputDecoration(labelText: 'Verification code'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: RaisedButton(
                          color: Colors.greenAccent[200],
                          onPressed: () async {
                            signInWithPhoneNumber();
                          },
                          child: Text("Sign in")),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //Callback for when the user has already previously signed in with this phone number on this device
  PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) async {
    await _auth.signInWithCredential(phoneAuthCredential);
    showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
  };

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  //Listens for errors with verification, such as too many attempts
  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
    showSnackbar('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
  };

  //Callback for when the code is sent
  PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    showSnackbar('Please check your phone for the verification code.');
    _verificationId = verificationId;
  };

  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    showSnackbar("verification code: " + verificationId);
    _verificationId = verificationId;
  };

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      showSnackbar("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      showSnackbar("Failed to sign in: " + e.toString());
    }
  }

  Future getcurrentUser(BuildContext context) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    id = user.id;
  }
}
