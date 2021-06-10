import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/auth/create_account_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/google_auth_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/signup_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => ListView(
          children: [
            SizedBox(height: 50),
            Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(30),
                child: Image.asset(Images.kiwis_logo, height: 200)),
            SizedBox(height: 30),
            Text(
              getTranslated('welcome', context),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3.copyWith(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  fontSize: 32),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              child: Text(
                'Kiwis welcomes you!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: ColorResources.getGreyColor(context)),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              child: CustomButton(
                btnTxt: getTranslated('login', context),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_DEFAULT,
                  right: Dimensions.PADDING_SIZE_DEFAULT,
                  bottom: Dimensions.PADDING_SIZE_DEFAULT,
                  top: 12),
              child: CustomButton(
                btnTxt: getTranslated('signup', context),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => CreateAccountScreen()));
                },
                // backgroundColor: ColorResources.getBackgroundColor(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.FONT_SIZE_DEFAULT,
                right: Dimensions.PADDING_SIZE_DEFAULT,
                bottom: Dimensions.PADDING_SIZE_DEFAULT,
                top: 12,
              ),
              child: CustomButton(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleAuthScreen()));
                },
                inactiveColor: ColorResources.COLOR_WHITE,
                btnTxt: 'NA',
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
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
                          color: ColorResources.getAccentColor(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
