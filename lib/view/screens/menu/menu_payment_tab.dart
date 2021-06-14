import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/address/address_screen.dart';
import 'package:flutter_restaurant/view/screens/chat/chat_screen.dart';
import 'package:flutter_restaurant/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_restaurant/view/screens/payment/add_card_screen.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen.dart';
import 'package:flutter_restaurant/view/screens/support/support_screen.dart';
import 'package:flutter_restaurant/view/screens/terms/terms_screen.dart';
import 'package:provider/provider.dart';

class MenuPaymentTab extends StatelessWidget {
  bool isCardsExist;
  MenuPaymentTab({this.isCardsExist});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            children: [
              isCardsExist
                  ? Container()
                  : Container(
                      child: Column(
                        children: [
                          Image.asset(
                            Images.no_cards_icon,
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "No cards added",
                            style: robotoMedium.copyWith(
                                color: ColorResources.getPrimaryColor(context),
                                fontSize: 30),
                          ),
                          Text(
                            "Your cards will be displayed here.",
                            style: robotoRegular.copyWith(
                                color: ColorResources.getAccentColor(context),
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text("Add New Payment Methods",
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddCardScreen())),
                leading: Image.asset(
                  Images.add_card_icon, width: 50, height: 50,
                  // color: Theme.of(context).textTheme.bodyText1.color
                ),
                title: Text('Add Card',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressScreen())),
                leading: Image.asset(
                  Images.net_banking_icon, width: 50, height: 50,
                  // color: Theme.of(context).textTheme.bodyText1.color
                ),
                title: Text('Net Banking',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen())),
                leading: Image.asset(
                  Images.pay_tm_icon, width: 50, height: 50,
                  // color: Theme.of(context).textTheme.bodyText1.color
                ),
                title: Text('PayTM',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CouponScreen())),
                leading: Image.asset(
                  Images.gpay_icon, width: 50, height: 50,
                  // color: Theme.of(context).textTheme.bodyText1.color
                ),
                title: Text('Google Pay',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChooseLanguageScreen(fromMenu: true))),
                leading: Image.asset(
                  Images.upi_icon, width: 50, height: 50,
                  // color: Theme.of(context).textTheme.bodyText1.color
                ),
                title: Text("UPI",
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              ListTile(
                // onTap: () =>
                leading: Image.asset(Images.black_wallet_icon,
                    width: 50,
                    height: 50,
                    color: Theme.of(context).textTheme.bodyText1.color),
                title: Text('Other Payment Wallets',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
            ]));
  }
}
