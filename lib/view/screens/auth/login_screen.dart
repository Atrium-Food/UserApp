import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/create_account_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/mobile_otp_Screen.dart';
import 'package:flutter_restaurant/view/screens/auth/signup_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailNumberFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;
  String _passwordError = '';
  String _emailError = '';

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserNumber() ?? '';
    _passwordController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword() ??
            '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/Ellipse9.png"),
            alignment: AlignmentDirectional.topCenter,
            scale: 1,
          ),
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Form(
            key: _formKeyLogin,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome',
                    maxLines: 2,
                    style: robotoBold.copyWith(
                        fontSize: 35,
                        color: ColorResources.getBackgroundColor(context),
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Back!',
                    maxLines: 2,
                    style: robotoBold.copyWith(
                        fontSize: 35,
                        color: ColorResources.getBackgroundColor(context),
                        fontWeight: FontWeight.w600),
                  ),

                  Text(
                    'Hey, we are happy to have you.',
                    style: TextStyle(
                      color: ColorResources.getBackgroundColor(context),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    getTranslated('login', context),
                    style: robotoBold.copyWith(
                        fontSize: 25,
                        color: ColorResources.getBackgroundColor(context),
                        fontWeight: FontWeight.w600),
                  ),

                  SizedBox(height: 30.0),

                  Container(
                    decoration: BoxDecoration(
                      color: ColorResources.getBackgroundColor(context),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
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
                          'Please fill your valid info',
                          style: TextStyle(
                            color: ColorResources.getGreyColor(context),
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        CustomTextField(
                          errorMessage: _emailError,
                          hintText: getTranslated('demo_gmail', context),
                          isShowBorder: true,
                          focusNode: _emailNumberFocus,
                          nextFocus: _passwordFocus,
                          controller: _emailController,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            CupertinoIcons.profile_circled,
                            color: ColorResources.getGreyColor(context),
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        CustomTextField(
                          hintText: getTranslated('password_hint', context),
                          errorMessage: _passwordError,
                          isShowBorder: true,
                          isPassword: true,
                          isShowSuffixIcon: true,
                          focusNode: _passwordFocus,
                          controller: _passwordController,
                          inputAction: TextInputAction.done,
                          prefixIcon: Icon(
                            Icons.remove_red_eye,
                            color: ColorResources.getGreyColor(context),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer<AuthProvider>(
                                builder: (context, authProvider, child) =>
                                    InkWell(
                                      onTap: () {
                                        authProvider.toggleRememberMe();
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                                color: authProvider
                                                        .isActiveRememberMe
                                                    ? ColorResources
                                                        .COLOR_PRIMARY
                                                    : ColorResources
                                                        .COLOR_WHITE,
                                                border: Border.all(
                                                    color: authProvider
                                                            .isActiveRememberMe
                                                        ? Colors.transparent
                                                        : ColorResources
                                                            .COLOR_PRIMARY),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child:
                                                authProvider.isActiveRememberMe
                                                    ? Icon(Icons.done,
                                                        color: ColorResources
                                                            .COLOR_WHITE,
                                                        size: 17)
                                                    : SizedBox.shrink(),
                                          ),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          Text(
                                            getTranslated(
                                                'remember_me', context),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_EXTRA_SMALL,
                                                    color: ColorResources
                                                        .getHintColor(context)),
                                          )
                                        ],
                                      ),
                                    )),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ForgotPasswordScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getTranslated('forgot_password', context),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: ColorResources.getHintColor(
                                              context)),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            authProvider.loginErrorMessage.length > 0
                                ? CircleAvatar(
                                    backgroundColor: Colors.red, radius: 5)
                                : SizedBox.shrink(),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.loginErrorMessage ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: Colors.red,
                                    ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        !authProvider.isLoading
                            ? CustomButton(
                                btnTxt: getTranslated('login', context),
                                onTap: () async {
                                  setState(() {
                                    String _email =
                                        _emailController.text.trim();
                                    String _password =
                                        _passwordController.text.trim();
                                    if (_email.isEmpty ||
                                        EmailChecker.isNotValid(_email) ||
                                        _password.isEmpty ||
                                        _password.length < 6) {
                                      if (_email.isEmpty) {
                                        _emailError = 'required';
                                      } else if (EmailChecker.isNotValid(
                                          _email)) {
                                        _emailError = getTranslated(
                                            'enter_valid_email', context);
                                      } else {
                                        _emailError = '';
                                      }

                                      // if (EmailChecker.isNotValid(_email)) {
                                      //   // showCustomSnackBar(
                                      //   //     getTranslated(
                                      //   //         'enter_valid_email', context),
                                      //   //     context);
                                      //   _emailValidate = true;
                                      // }
                                      if (_password.isEmpty) {
                                        _passwordError = getTranslated(
                                            'enter_password', context);
                                        // showCustomSnackBar(
                                        //     getTranslated(
                                        //         'enter_password', context),
                                        //     context);
                                      } else if (_password.length < 6) {
                                        _passwordError = getTranslated(
                                            'password_should_be', context);
                                      } else
                                        _passwordError = '';
                                    }
                                    // if (_password.length < 6) {
                                    //   // showCustomSnackBar(
                                    //   //     getTranslated(
                                    //   //         'password_should_be', context),
                                    //   //     context);
                                    //   _passwordValidate = true;
                                    // }
                                    else {
                                      _emailError = '';
                                      _passwordError = '';
                                      authProvider
                                          .login(_email, _password)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          if (authProvider.isActiveRememberMe) {
                                            authProvider
                                                .saveUserNumberAndPassword(
                                                    _email, _password);
                                          } else {
                                            authProvider
                                                .clearUserNumberAndPassword();
                                          }

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
                                    ColorResources.COLOR_PRIMARY),
                              )),

                        // for create an account
                        SizedBox(height: 30),
                        // Center(
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => MobileOTP()));
                        //     },
                        //     child: Text(
                        //       'Login using OTP',
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .headline3
                        //           .copyWith(
                        //               fontSize: Dimensions.FONT_SIZE_SMALL,
                        //               color: ColorResources.getGreyBunkerColor(
                        //                   context)),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => CreateAccountScreen()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated('create_an_account', context),
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
                                getTranslated('signup', context),
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
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'or',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.getGreyBunkerColor(
                                        context)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          onTap: () {

                          },
                          inactiveColor: ColorResources.COLOR_WHITE,
                          btnTxt: 'NA',
                          child: Container(
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Images.google_logo),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    color:
                                        ColorResources.getThemeColor(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Center(
                        //   child: TextButton(
                        //     style: TextButton.styleFrom(
                        //       minimumSize: Size(1, 40),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.pushReplacement(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (_) => DashboardScreen()));
                        //     },
                        //     child: RichText(
                        //         text: TextSpan(children: [
                        //       TextSpan(
                        //           text:
                        //               '${getTranslated('login_as_a', context)} ',
                        //           style: robotoRegular.copyWith(
                        //               color: ColorResources.getGreyColor(
                        //                   context))),
                        //       TextSpan(
                        //           text: getTranslated('guest', context),
                        //           style: robotoMedium.copyWith(
                        //               color: Theme.of(context)
                        //                   .textTheme
                        //                   .bodyText1
                        //                   .color)),
                        //     ])),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // Text(
                  //   getTranslated('email', context),
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headline2
                  //       .copyWith(color: ColorResources.getHintColor(context)),
                  // ),
                  // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  //
                  // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  // Text(
                  //   getTranslated('password', context),
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headline2
                  //       .copyWith(color: ColorResources.getHintColor(context)),
                  // ),
                  // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  // CustomTextField(
                  //   hintText: getTranslated('password_hint', context),
                  //   isShowBorder: true,
                  //   isPassword: true,
                  //   isShowSuffixIcon: true,
                  //   focusNode: _passwordFocus,
                  //   controller: _passwordController,
                  //   inputAction: TextInputAction.done,
                  // ),
                  // SizedBox(height: 22),

                  // for remember me section

                  // for login button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
