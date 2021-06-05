import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/welcome_screen/welcome_screen.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();

  final FocusNode _lastNameFocus = FocusNode();

  final FocusNode _numberFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _numberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  String _emailError = '';
  String _passwordError = '';
  String _fNameError = '';
  String _lNameError = '';
  String _mobileError = '';
  String _passWordError = '';
  String _confirmError = '';

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: 10,
                ),
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
                  height: 20,
                ),
                PreferredSize(
                  preferredSize: Size.fromWidth(10.0),
                  child: Text(
                    'Would love to have to on board!',
                    maxLines: 20,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50.0,
                ),

                Text(
                  getTranslated('signup', context),
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      fontSize: 24, color: ColorResources.COLOR_WHITE),
                ),
                SizedBox(height: 50),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1), // changes position of shadow
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Enter the following details.',
                        style: TextStyle(
                          color: ColorResources.getGreyColor(context),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      CustomTextField(
                        hintText: getTranslated('demo_gmail', context),
                        errorMessage: _emailError,
                        isShowBorder: true,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        hintText: getTranslated('first_name', context),
                        errorMessage: _fNameError,
                        isShowBorder: true,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        hintText: getTranslated('last_name', context),
                        isShowBorder: true,
                        errorMessage: _lNameError,
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        nextFocus: _numberFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: getTranslated('mobile_number', context),
                        isShowBorder: true,
                        errorMessage: _mobileError,
                        controller: _numberController,
                        focusNode: _numberFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.phone,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: getTranslated('password', context),
                        isShowBorder: true,
                        errorMessage: _passwordError,
                        isPassword: true,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: getTranslated('confirm_password', context),
                        isShowBorder: true,
                        errorMessage: _confirmError,
                        isPassword: true,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                        inputAction: TextInputAction.done,
                      ),
                      SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.registrationErrorMessage.length > 0
                              ? CircleAvatar(
                                  backgroundColor:
                                      ColorResources.getPrimaryColor(context),
                                  radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.registrationErrorMessage ?? "",
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
                      SizedBox(height: 10),
                      !authProvider.isLoading
                          ? CustomButton(
                              btnTxt: getTranslated('signup', context),
                              onTap: () {
                                setState(() {
                                  String _firstName =
                                      _firstNameController.text.trim();
                                  String _lastName =
                                      _lastNameController.text.trim();
                                  String _number =
                                      _numberController.text.trim();
                                  String _password =
                                      _passwordController.text.trim();
                                  String _confirmPassword =
                                      _confirmPasswordController.text.trim();
                                  String _email = _emailController.text.trim();
                                  if (_email.isEmpty ||
                                      EmailChecker.isNotValid(_email) ||
                                      _firstName.isEmpty ||
                                      _lastName.isEmpty ||
                                      _number.isEmpty ||
                                      _password.isEmpty ||
                                      _confirmPassword.isEmpty ||
                                      _password.length < 6 ||
                                      _password != _confirmPassword) {
                                    if (_email.isEmpty) {
                                      _emailError = getTranslated(
                                          'enter_email_address', context);
                                      // showCustomSnackBar(
                                      //     getTranslated(
                                      //         'enter_email_address', context),
                                      //     context);
                                    }
                                    if (EmailChecker.isNotValid(_email)) {
                                      _emailError = getTranslated(
                                          'enter_valid_email', context);
                                      // showCustomSnackBar(
                                      //     getTranslated(
                                      //         'enter_valid_email', context),
                                      //     context);
                                    }
                                    if (_firstName.isEmpty) {
                                      _fNameError = getTranslated(
                                          'enter_first_name', context);
                                      // showCustomSnackBar(
                                      //     getTranslated(
                                      //         'enter_first_name', context),
                                      //     context);
                                    }
                                    if (_lastName.isEmpty) {
                                      _lNameError = getTranslated(
                                          'enter_last_name', context);
                                      // showCustomSnackBar(
                                      //     getTranslated(
                                      //         'enter_last_name', context),
                                      //     context);
                                    }
                                    if (_number.isEmpty) {
                                      _mobileError = getTranslated(
                                          'enter_phone_number', context);
                                      // showCustomSnackBar(
                                      //     getTranslated(
                                      //         'enter_phone_number', context),
                                      //     context);
                                    }
                                    if (_password.isEmpty) {
                                      _passwordError = getTranslated(
                                          'enter_password', context);
                                      // showCustomSnackBar(
                                      //     getTranslated(
                                      //         'enter_password', context),
                                      //     context);
                                    }
                                    if (_password.length < 6) {
                                      _passwordError = getTranslated(
                                          'password_should_be', context);
                                      // \
                                    }
                                    if (_confirmPassword.isEmpty) {
                                      _confirmError = getTranslated(
                                          'enter_confirm_password', context);
                                      // showCustomSnackBar(
                                      //     getTranslated(
                                      //         'enter_confirm_password', context),
                                      //     context);
                                    }
                                    if (_password != _confirmPassword) {
                                      _passwordError = getTranslated(
                                          'password_did_not_match', context);
                                      _confirmError = getTranslated(
                                          'password_did_not_match', context);
                                      // showCustomSnackBar(
                                      //     getTranslated(
                                      //         'password_did_not_match', context),
                                      //     context);
                                    }
                                  } else {
                                    _emailError = '';
                                    _passwordError = '';
                                    _fNameError = '';
                                    _lNameError = '';
                                    _mobileError = '';
                                    _passwordError = '';
                                    SignUpModel signUpModel = SignUpModel(
                                      fName: _firstName,
                                      lName: _lastName,
                                      email: _email,
                                      password: _password,
                                      phone: _number,
                                    );
                                    authProvider
                                        .registration(signUpModel)
                                        .then((status) async {
                                      if (status.isSuccess) {
                                        await Provider.of<WishListProvider>(
                                                context,
                                                listen: false)
                                            .initWishList(context);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    DashboardScreen()),
                                            (route) => false);
                                      }
                                    });
                                  }
                                });
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  ColorResources.getPrimaryColor(context)),
                            )),

                      // for already an account
                      SizedBox(height: 11),
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

                // for first name section

                // for password section

                // for confirm password section

                // for signup button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
