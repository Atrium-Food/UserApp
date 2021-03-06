import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/review_widget.dart';
import 'package:flutter_restaurant/view/screens/rare_review/review_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ReviewPage extends StatelessWidget {
  final Product product;
  ReviewPage({@required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Text(
                '${product.rating != null ? product.rating.average != null ? product.rating.average.toStringAsFixed(1) : 0.0 : 0.0}',
                style: robotoRegular.copyWith(
                    color: ColorResources.getAccentColor(context),
                    fontSize: 70)),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: RatingBar(
              rating:
                  product.rating != null ? product.rating.average ?? 0 : 0.0,
              size: 20,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
              child: Text(
            'Based on ${product.rating?.countTotalRating ?? 0} ratings',
            style: robotoRegular.copyWith(color: Colors.white),
          )),
          SizedBox(
            height: 15.0,
          ),
          if (product.rating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Excellent',
                  textAlign: TextAlign.end,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: ColorResources.getGreyBunkerColor(context)),
                ),
                new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 150,
                  lineHeight: 16.0,
                  animationDuration: 2500,
                  percent: product.rating.countTotalRating != 0
                      ? product.rating.countRating[4] /
                          product.rating.countTotalRating
                      : 0,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.green,
                ),
              ],
            ),
          if (product.rating != null)
            SizedBox(
              height: 10,
            ),
          if (product.rating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Good',
                  textAlign: TextAlign.end,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: ColorResources.getGreyBunkerColor(context)),
                ),
                new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 150,
                  lineHeight: 16.0,
                  animationDuration: 2500,
                  percent: product.rating.countTotalRating != 0
                      ? product.rating.countRating[3] /
                          product.rating.countTotalRating
                      : 0,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.green,
                ),
              ],
            ),
          if (product.rating != null)
            SizedBox(
              height: 10,
            ),
          if (product.rating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Average',
                  textAlign: TextAlign.end,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: ColorResources.getGreyBunkerColor(context)),
                ),
                new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 150,
                  lineHeight: 16.0,
                  percent: product.rating.countTotalRating != 0
                      ? product.rating.countRating[2] /
                          product.rating.countTotalRating
                      : 0,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.yellow,
                ),
              ],
            ),
          if (product.rating != null)
            SizedBox(
              height: 10,
            ),
          if (product.rating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Below Average',
                  textAlign: TextAlign.end,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: ColorResources.getGreyBunkerColor(context)),
                ),
                new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 150,
                  lineHeight: 16.0,
                  percent: product.rating.countTotalRating != 0
                      ? product.rating.countRating[1] /
                          product.rating.countTotalRating
                      : 0,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.orange,
                ),
              ],
            ),
          if (product.rating != null)
            SizedBox(
              height: 10,
            ),
          if (product.rating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Poor',
                  textAlign: TextAlign.end,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: ColorResources.getGreyBunkerColor(context)),
                ),
                new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 150,
                  lineHeight: 16.0,
                  animationDuration: 2500,
                  percent: product.rating.countTotalRating != 0
                      ? product.rating.countRating[0] /
                          product.rating.countTotalRating
                      : 0,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.red,
                ),
              ],
            ),
          SizedBox(
            height: 30,
          ),
          if (product.reviews != null)
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: product.reviews.length,
                itemBuilder: (context, index) {
                  // Map<String, dynamic> json = {
                  //   'product_id': 1,
                  //   'comment':
                  //       'Lovely lunch today. Ordered the food without much expectations from myself as in the end I was the one who had to cook, but in the end everything turned out to be great. The chef who was guiding me through the whole session was so calm and he motivated me to cook. Giving a four so that I can improve myself and cook better next time. Hoping to update the review soon.',
                  //   'rating': 3,
                  // };
                  return ReviewWidget(review: product.reviews[index]);
                }),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductReviewScreen(
                              productID: product.id,
                            )));
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: Dimensions.PADDING_SIZE_SMALL,
                  bottom: Dimensions.PADDING_SIZE_SMALL,
                  left: Dimensions.PADDING_SIZE_EXTRA_LARGE + 40,
                  right: Dimensions.PADDING_SIZE_EXTRA_LARGE + 40,
                ),
                decoration: BoxDecoration(
                  color: ColorResources.COLOR_WHITE,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border:
                      Border.all(color: ColorResources.COLOR_PRIMARY, width: 3),
                ),
                child: Text(
                  'Write a review',
                  style: robotoRegular.copyWith(
                      color: ColorResources.COLOR_PRIMARY, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
