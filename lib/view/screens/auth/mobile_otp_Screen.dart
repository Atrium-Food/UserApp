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

class MobileOTP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _numberController = TextEditingController();

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
                              if (_numberController.text.isEmpty) {
                                showCustomSnackBar(
                                    getTranslated(
                                        'enter_email_address', context),
                                    context);
                              } else if (!_numberController.text
                                  .contains('@')) {
                                showCustomSnackBar(
                                    getTranslated('enter_valid_email', context),
                                    context);
                              } else {
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .forgetPassword(_numberController.text)
                                    .then((value) {
                                  if (value.isSuccess) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => VerificationScreen(
                                                forLogin: true,
                                                contact:
                                                    _numberController.text)));
                                  } else {
                                    showCustomSnackBar(value.message, context);
                                  }
                                });
                              }
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorResources.COLOR_PRIMARY))),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
