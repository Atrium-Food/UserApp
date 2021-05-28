import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/signup_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/forgot_password_screen.dart';
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
            image: AssetImage("assets/image/Ellipse8.png"),
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
                  Text(
                    'Welcome Back!',
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),

                  Text(
                    'Hey, we are happy to have you.',
                    style: TextStyle(
                      color: ColorResources.COLOR_WHITE,
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
                    style: Theme.of(context).textTheme.headline3.copyWith(
                        fontSize: 24,
                        color: ColorResources.COLOR_WHITE,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 30.0),

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
                          'Please fill your valid info',
                          style: TextStyle(
                            color: ColorResources.getGreyColor(context),
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        CustomTextField(
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
                                    backgroundColor:
                                        ColorResources.getPrimaryColor(context),
                                    radius: 5)
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
                                      color: ColorResources.getPrimaryColor(
                                          context),
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
                                  String _email = _emailController.text.trim();
                                  String _password =
                                      _passwordController.text.trim();
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
                                  } else if (_password.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'enter_password', context),
                                        context);
                                  } else if (_password.length < 6) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'password_should_be', context),
                                        context);
                                  } else {
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
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    ColorResources.COLOR_PRIMARY),
                              )),

                        // for create an account
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => SignUpScreen()));
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
