import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/review_widget.dart';
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
                '${product.rating != null ? double.parse(product.rating.average).toStringAsFixed(1) : 0.0}',
                style: robotoRegular.copyWith(
                    color: ColorResources.getAccentColor(context),
                    fontSize: 70)),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: RatingBar(
              rating: product.rating != null
                  ? double.parse(product.rating.average)
                  : 0.0,
              size: 20,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
              child: product.rating != null
                  ? Text('Based on ${product.reviews.length} ratings')
                  : null),
          SizedBox(
            height: 15.0,
          ),
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
                percent: 0.8,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.green,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
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
                percent: 0.4,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.green,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
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
                percent: 0.8,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.yellow,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
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
                percent: 0.6,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.orange,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
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
                percent: 0.7,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.red,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          if(product.reviews!=null)ListView.builder(
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
              })
        ],
      ),
    );
  }
}
