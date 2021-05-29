import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/home/widget/pie_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NutrientValues extends StatelessWidget {
  final Product product;

  NutrientValues({
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> nutrients = [];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Text(
            'Nutritional Values',
            style: rubikMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: ColorResources.getAccentColor(context),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nutritional Score',
                          style: rubikMedium,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Glycemic Index'),
                            SizedBox(
                              width: 7,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 7, right: 7),
                              decoration: BoxDecoration(
                                color: ColorResources.getPrimaryColor(context),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text('9'),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('Glycemic Index'),
                            SizedBox(
                              width: 7,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 7, right: 7),
                              decoration: BoxDecoration(
                                color: ColorResources.getPrimaryColor(context),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text('3'),
                            )
                          ],
                        ),
                      ],
                    ),
                    CircularPercentIndicator(
                      lineWidth: 8,
                      radius: 80,
                      backgroundColor: ColorResources.COLOR_WHITE,
                      percent: 0.74,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: ColorResources.getPrimaryColor(context),
                      center: Text(
                        '7.4',
                        style: rubikMedium.copyWith(
                            color: ColorResources.getPrimaryColor(context),
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Nutritional Indices',
                style: rubikMedium.copyWith(fontSize: 20),
              ),
              Center(
                child: PieChartSample1(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'serving/',
                    style: TextStyle(
                      fontSize: 15,
                      color: ColorResources.getGreyColor(context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        color: index % 2 == 1
                            ? ColorResources.COLOR_WHITE
                            : Color(0xffE8F9ED),
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Aspect',
                              style: rubikMedium,
                            ),
                            Text(
                              'Mass',
                              style: rubikMedium.copyWith(color: Colors.grey),
                            ),
                            Text(
                              'percentage',
                              style: rubikMedium.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Food Suggestion',
                style: rubikMedium.copyWith(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    'Pair this dish with a vegetable gourmet filled with fibers and low carbohydrates inorder to make a perfect meal good enough for your tummy and full of protein.',
                    maxLines: 20,
                    style: rubikRegular,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// child: Row(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// Text(
// 'serving/',
// style: TextStyle(
// fontSize: 10,
// color: ColorResources.getGreyColor(context),
// ),
// ),
// ],
// ),
// ),
// SizedBox(
// height: 10.0,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// 'Energy',
// style: rubikMedium,
// ),
// Text(
// '1883 KJ',
// style: rubikMedium,
// ),
// ],
// )
