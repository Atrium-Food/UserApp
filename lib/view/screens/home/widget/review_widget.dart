import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[
              Provider.of<ThemeProvider>(
                  context)
                  .darkTheme
                  ? 700
                  : 400],
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.account_circle,size: 50,),
              RatingBar(rating: 3),
              ],
          ),
          SizedBox(
            height: 5,
          ),
          Text("Lovely lunch today. Ordered the food without much expectations from myself as in the end I was the one who had to cook, but in the end everything turned out to be great. The chef who was guiding me through the whole session was so calm and he motivated me to cook. Giving a four so that I can improve myself and cook better next time. Hoping to update the review soon. ",
              style: rubikRegular.copyWith(color: ColorResources.getGrayColor(context))),
        ],
      ),
    );
  }
}
