import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/create_account_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:flutter_restaurant/view/screens/welcome_screen/welcome_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false)
        .clearVerificationMessage();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/Ellipse8.png"),
            alignment: AlignmentDirectional.topCenter,
            scale: 1,
          ),
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    },
                    child: Icon(
                      CupertinoIcons.back,
                      color: ColorResources.COLOR_WHITE,
                    ),
                  ),
                ),

                SizedBox(
                  height: 20.0,
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'Would love to have to on board',
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 80),
                Text(
                  getTranslated('signup', context),
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      fontSize: 24, color: ColorResources.COLOR_WHITE),
                ),
                SizedBox(height: 80),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    bottom: 10.0,
                    top: 5.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your email to proceed',
                        style: TextStyle(
                          color: ColorResources.getGreyColor(context),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      CustomTextField(
                        hintText: getTranslated('demo_gmail', context),
                        isShowBorder: true,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.verificationMessage.length > 0
                              ? CircleAvatar(
                                  backgroundColor:
                                      ColorResources.getPrimaryColor(context),
                                  radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.verificationMessage ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color:
                                        ColorResources.getPrimaryColor(context),
                                  ),
                            ),
                          )
                        ],
                      ),
                      !authProvider.isPhoneNumberVerificationButtonLoading
                          ? CustomButton(
                              btnTxt: getTranslated('continue', context),
                              onTap: () {
                                String _email = _emailController.text.trim();
                                if (_email.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_email_address', context),
                                      context);
                                } else if (EmailChecker.isNotValid(_email)) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_valid_email', context),
                                      context);
                                } else {
                                  authProvider
                                      .checkEmail(_email)
                                      .then((value) async {
                                    if (value.isSuccess) {
                                      authProvider.updateEmail(_email);
                                      if (value.message == 'active') {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    VerificationScreen(
                                                        emailAddress: _email,
                                                        fromSignUp: true)));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CreateAccountScreen()));
                                      }
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  ColorResources.COLOR_PRIMARY),
                            )),

                      // for create an account
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => LoginScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated('already_have_account', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: ColorResources.getGreyColor(
                                            context)),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Text(
                                getTranslated('login', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color:
                                            ColorResources.getGreyBunkerColor(
                                                context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                // for continue button
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
