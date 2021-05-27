import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/address/address_screen.dart';
import 'package:flutter_restaurant/view/screens/chat/chat_screen.dart';
import 'package:flutter_restaurant/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen.dart';
import 'package:flutter_restaurant/view/screens/support/support_screen.dart';
import 'package:flutter_restaurant/view/screens/terms/terms_screen.dart';
import 'package:provider/provider.dart';

class MenuProfileTab extends StatelessWidget {
  final Function onTap;
  MenuProfileTab({@required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
        SwitchListTile(
          value: Provider.of<ThemeProvider>(context).darkTheme,
          onChanged: (bool isActive) =>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          title: Text(getTranslated('dark_theme', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          activeColor: Theme.of(context).primaryColor,
        ),
        ListTile(
          onTap: () => onTap(2),
          leading: Image.asset(Images.order, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('my_order', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
          leading: Image.asset(Images.profile, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('profile', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressScreen())),
          leading: Image.asset(Images.location, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen())),
          leading: Image.asset(Images.message, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('message', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CouponScreen())),
          leading: Image.asset(Images.coupon, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('coupon', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChooseLanguageScreen(fromMenu: true))),
          leading: Image.asset(Images.language, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('language', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SupportScreen())),
          leading: Icon(Icons.contact_support, size: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('help_and_support', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TermsScreen())),
          leading: Icon(Icons.rule, size: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('terms_and_condition', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        ListTile(
          onTap: () {
            showDialog(context: context, builder: (context) => SignOutConfirmationDialog());
          },
          leading: Image.asset(Images.log_out, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
          title: Text(getTranslated('logout', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
      ])
    );
  }
}
