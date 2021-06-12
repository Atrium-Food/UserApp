import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewBody review;
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
                  Provider.of<ThemeProvider>(context).darkTheme ? 700 : 400],
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle,
                size: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName ?? '',
                    style: robotoRegular.copyWith(
                        fontSize: 18,
                        color: ColorResources.getAccentColor(context)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RatingBar(rating: review.rating.toDouble()),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(review.comment,
              style: robotoRegular.copyWith(
                  fontSize: 15, color: ColorResources.getGrayColor(context))),
        ],
      ),
    );
  }
}
