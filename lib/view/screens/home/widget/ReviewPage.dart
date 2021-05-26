import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';


class ReviewPage extends StatelessWidget {
  Product product;
  ReviewPage({@required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${product.rating.length > 0 ? double.parse(product.rating[0].average).toStringAsFixed(1) : 0.0}',
            style: rubikRegular.copyWith(color: ColorResources.getAccentColor(context),fontSize: 70)
          ),
          SizedBox(
            height: 5,
          ),
          RatingBar(
              rating: product.rating.length > 0
                  ? double.parse(product.rating[0].average)
                  : 0.0,
              size: 20,
          ),
          SizedBox(
            height: 5,
          ),
          Text('Based on ${product.rating.length} ratings'),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Excellent',
                textAlign: TextAlign.end,
                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: ColorResources.getGreyBunkerColor(context)),
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
                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: ColorResources.getGreyBunkerColor(context)),
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
                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: ColorResources.getGreyBunkerColor(context)),
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
                textAlign: TextAlign.end,style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: ColorResources.getGreyBunkerColor(context)),
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
                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: ColorResources.getGreyBunkerColor(context)),
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
        ],
      ),
    );
  }
}
