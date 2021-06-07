import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';

class NoDataScreen extends StatelessWidget {
  final bool isOrder;
  final bool isCart;
  final bool isNothing;
  final bool isWishList;
  NoDataScreen({this.isCart = false, this.isNothing = false, this.isOrder = false,this.isWishList=false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Spacer(
        //   flex: 1,
        // ),
        Image.asset(
          isWishList?  Images.add_favorite: isOrder ? Images.clock : isCart ? Images.shopping_cart : Images.binoculars,
          width: MediaQuery.of(context).size.height*0.22, height: MediaQuery.of(context).size.height*0.22,
          color: Theme.of(context).primaryColor,
        ),


        Text(
          isWishList? 'No Favorites': isOrder ? 'No history yet' : isCart ? 'No orders yet' : 'Nothing found',
          style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: MediaQuery.of(context).size.height*0.023),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),

        Text(
          isWishList? 'Start wishlisting your favorite dishes now' :isOrder ? 'Click below to start ordering' : isCart ? 'Click below and start ordering': '',
          style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0185), textAlign: TextAlign.center,
        ),
        // Spacer(
        //   flex: 2,
        // ),
        if(isOrder || isCart)CustomButton(
          btnTxt: isWishList? 'Start Browsing' :'Start Ordering',onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> DashboardScreen()));
        },)

      ]),
    );
  }
}
