import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewWidget extends StatelessWidget {
  ReviewBody review;
  ReviewWidget({this.review});
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
              RatingBar(rating: double.parse(review.rating)),
              ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(review.comment,
              style: robotoRegular.copyWith(color: ColorResources.getGrayColor(context))),
        ],
      ),
    );
  }
}
