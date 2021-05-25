import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('help_and_support', context)),
      body: ListView(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          children: [
            Image.asset(Images.customer_support),
            SizedBox(height: 20),

            // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
            //   Text(getTranslated('restaurant_address', context), style: rubikMedium),
            // ]),
            // SizedBox(height: 10),
            Text(
              'How can we help you?',
              style: rubikMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              'Feel free to ask help from our expert chefs',
              style: rubikRegular,
              textAlign: TextAlign.center,
            ),
            // Divider(thickness: 2),
            SizedBox(height: 50),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        Images.call_support,
                        height: MediaQuery.of(context).size.width * 0.3,
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: ColorResources.getPrimaryColor(context),
                      ),
                      Text(
                        'Call us',
                        style: rubikRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  launch(
                      'tel:${Provider.of<SplashProvider>(context, listen: false).configModel.restaurantPhone}');
                },
              ),
              SizedBox(width: 10),
              InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        Images.chat_support,
                        height: MediaQuery.of(context).size.width * 0.3,
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: ColorResources.getPrimaryColor(context),
                      ),
                      Text(
                        'Call us',
                        style: rubikRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => ChatScreen()));
                },
              ),
            ]),
          ]),
    );
  }
}
