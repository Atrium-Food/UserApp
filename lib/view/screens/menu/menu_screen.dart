import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/address/address_screen.dart';
import 'package:flutter_restaurant/view/screens/chat/chat_screen.dart';
import 'package:flutter_restaurant/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/menu_payment_tab.dart';
import 'package:flutter_restaurant/view/screens/menu/menu_profile_tab.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen.dart';
import 'package:flutter_restaurant/view/screens/support/support_screen.dart';
import 'package:flutter_restaurant/view/screens/terms/terms_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MenuScreen extends StatelessWidget {
  final Function onTap;
  MenuScreen({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: ColorResources.getPrimaryColor(context),
                toolbarHeight: MediaQuery.of(context).size.height * 0.065,
                collapsedHeight: MediaQuery.of(context).size.height * 0.065,
                expandedHeight: MediaQuery.of(context).size.height * 0.30,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 15),
                  centerTitle: true,
                  title: Container(
                    padding: EdgeInsets.only(bottom:45.0),
                    child: Consumer<ProfileProvider>(
                        builder: (context, profileProvider, child) {
                      return ListView(
                        shrinkWrap: true,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: ColorResources.COLOR_WHITE,
                                      width: 2)),
                              child: ClipOval(
                                child: _isLoggedIn
                                    ? FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder_user,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                            '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (BuildContext context,
                                                Object exception,
                                                StackTrace stackTrace) {
                                          return Image.asset(
                                              Images.placeholder_user,
                                              fit: BoxFit.contain);
                                        },
                                      )
                                    : Image.asset(Images.placeholder_user,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover),
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              enabled: profileProvider.userInfoModel == null,
                              child: Column(children: [
                                SizedBox(height: 10),
                                _isLoggedIn
                                    ? profileProvider.userInfoModel != null
                                        ? Text(
                                            '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                            style: rubikRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                                color:
                                                    ColorResources.COLOR_WHITE),
                                          )
                                        : Container(
                                            height: 15,
                                            width: 150,
                                            color: Colors.white)
                                    : Text(
                                        getTranslated('guest', context),
                                        style: rubikRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.COLOR_WHITE),
                                      ),
                                // SizedBox(height: 10),
                                _isLoggedIn
                                    ? profileProvider.userInfoModel != null
                                        ? Text(
                                            '${profileProvider.userInfoModel.email ?? ''}',
                                            style: rubikRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_SMALL,
                                                color: ColorResources
                                                    .BACKGROUND_COLOR),
                                          )
                                        : Container(
                                            height: 15,
                                            width: 100,
                                            color: Colors.white)
                                    : Text(
                                        'demo@demo.com',
                                        style: rubikRegular.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_SMALL,
                                            color: ColorResources.COLOR_WHITE),
                                      ),
                              ]),
                            )
                          ]);
                    }),
                  ),
                ),
                //title: Text('My App Bar'),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(30.0),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: 20, bottom: 20.0, left: 20, right: 20),
                    // padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TabBar(
                      unselectedLabelColor:
                          ColorResources.getGrayColor(context),
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        shape: BoxShape.rectangle,
                        color: ColorResources.getIndicatorPrimaryColor(context),
                      ),
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 8, 2, 8),
                          child: Text('PROFILE',
                              style: rubikRegular.copyWith(fontSize: MediaQuery.of(context).size.width*0.038)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 8, 2, 8),
                          child: Text('PAYMENT',
                              style: rubikRegular.copyWith(fontSize: MediaQuery.of(context).size.width*0.038)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 8, 2, 8),
                          child: Text('REFER',
                              style: rubikRegular.copyWith(fontSize: MediaQuery.of(context).size.width*0.038)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              MenuProfileTab(onTap: onTap),
              MenuPaymentTab(
                isCardsExist: false,
              ),
              Container(),
            ],
          ),
        ),
      ),

      // body: Column(children: [
      //   Consumer<ProfileProvider>(
      //     builder: (context, profileProvider, child) => Container(
      //       width: MediaQuery.of(context).size.width,
      //       padding: EdgeInsets.symmetric(vertical: 50),
      //       decoration: BoxDecoration(color: ColorResources.getPrimaryColor(context)),
      //       child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center, children: [
      //         Container(
      //           height: 80, width: 80,
      //           decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorResources.COLOR_WHITE, width: 2)),
      //           child: ClipOval(
      //             child: _isLoggedIn ? FadeInImage.assetNetwork(
      //               placeholder: Images.placeholder_user,
      //               image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
      //                   '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
      //               height: 80, width: 80, fit: BoxFit.cover,
      //               imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
      //                 return Image.asset(Images.placeholder_image, fit: BoxFit.contain);
      //               },
      //             ) : Image.asset(Images.placeholder_user, height: 80, width: 80, fit: BoxFit.cover),
      //           ),
      //         ),
      //         Shimmer.fromColors(
      //           baseColor: Colors.grey[300],
      //           highlightColor: Colors.grey[100],
      //           enabled: profileProvider.userInfoModel == null,
      //           child: Column(children: [
      //             SizedBox(height: 20),
      //             _isLoggedIn ? profileProvider.userInfoModel != null ? Text(
      //               '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
      //               style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.COLOR_WHITE),
      //             ) : Container(height: 15, width: 150, color: Colors.white) : Text(
      //               getTranslated('guest', context),
      //               style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.COLOR_WHITE),
      //             ),
      //             SizedBox(height: 10),
      //             _isLoggedIn ? profileProvider.userInfoModel != null ? Text(
      //               '${profileProvider.userInfoModel.email ?? ''}',
      //               style: rubikRegular.copyWith(color: ColorResources.BACKGROUND_COLOR),
      //             ) : Container(height: 15, width: 100, color: Colors.white) : Text(
      //               'demo@demo.com',
      //               style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.COLOR_WHITE),
      //             ),
      //           ]),
      //         )
      //       ]),
      //     ),
      //   ),
      //   MenuProfileTab(onTap: onTap),
      // ]),
    );
  }
}
