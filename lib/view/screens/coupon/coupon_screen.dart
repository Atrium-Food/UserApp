import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/menu_app_bar.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
    }

    return Scaffold(
      appBar: MenuAppBar(),
      backgroundColor: ColorResources.getThemeColor(context),
      body: _isLoggedIn ? Consumer<CouponProvider>(
        builder: (context, coupon, child) {
          return coupon.couponList != null ? coupon.couponList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: Dimensions.FONT_SIZE_LARGE,top: Dimensions.PADDING_SIZE_LARGE),
                  child: Text(getTranslated('coupon', context),style: robotoRegular.copyWith(fontSize: 22),),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: coupon.couponList.length,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                        child: Stack(children: [
                          Image.asset(Images.coupon_bg, height: 100, width: MediaQuery.of(context).size.width, color: Theme.of(context).primaryColor),
                          Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: Row(children: [

                              SizedBox(width: 40),
                              Image.asset(Images.percentage, height: 30, width: 25),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_SMALL),
                                child: Image.asset(Images.line, height: 100, width: 5),
                              ),

                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  // SelectableText(
                                  //   coupon.couponList[index].code,
                                  //   style: robotoRegular.copyWith(color: ColorResources.COLOR_WHITE),
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${coupon.couponList[index].discount}${coupon.couponList[index].discountType == 'percent' ? '%'
                                                : Provider.of<SplashProvider>(context, listen: false).configModel.currencySymbol}',
                                            style: robotoMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                          ),
                                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          OutlinedButton(
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(ColorResources.getBackgroundColor(context)),
                                                textStyle: MaterialStateProperty.all(robotoRegular.copyWith(color: ColorResources.getPrimaryColor(context))),
                                              ),
                                              onPressed: (){
                                                Clipboard.setData(ClipboardData(text: coupon.couponList[index].code));
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('coupon_code_copied', context)), backgroundColor: Colors.green));
                                              },
                                              child: Text("Redeem",style: robotoMedium.copyWith(color: ColorResources.getPrimaryColor(context)),)
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '${getTranslated('valid_until', context)} ${DateConverter.isoStringToLocalDateOnly(coupon.couponList[index].expireDate)}',
                                            style: robotoRegular.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          ),
                                          SelectableText(
                                              'Code: ${coupon.couponList[index].code}',
                                              style: robotoRegular.copyWith(fontSize:Dimensions.FONT_SIZE_SMALL,color: ColorResources.COLOR_WHITE),
                                            ),
                                          Text(
                                            'Min Purchase: ${coupon.couponList[index].minPurchase}',
                                            style: robotoRegular.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                ]),
                              ),

                            ]),
                          ),

                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }
}
