import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/home/widget/pie_chart.dart';
import 'package:flutter_restaurant/view/screens/home/widget/pie_chart_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class NutrientValues extends StatelessWidget {
  final Product product;

  NutrientValues({
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Text(
            'Nutritional Values',
            style: robotoMedium.copyWith(
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
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) => Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: ColorResources.getBackgroundColor(context),
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
                            style: robotoMedium,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                'Glycemic Index',
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 7, right: 7),
                                decoration: BoxDecoration(
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                    product.nutrient.glycemicIndex.toString()),
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
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                    product.nutrient.glycemicLoad.toString()),
                              )
                            ],
                          ),
                        ],
                      ),
                      CircularPercentIndicator(
                        lineWidth: 8,
                        radius: 80,
                        backgroundColor: ColorResources.COLOR_WHITE,
                        percent: product.nutrient.score % 10 / 10,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: ColorResources.getPrimaryColor(context),
                        center: Text(
                          (product.nutrient.score % 10).toStringAsFixed(1),
                          style: robotoMedium.copyWith(
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
                  style: robotoMedium.copyWith(fontSize: 20),
                ),
                Center(
                  child: PieChartSample3(
                    product: product,
                  ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _nutrientWidget(
                            'Calories', product.nutrient.calories, 0),
                        _nutrientWidget('Carbs', product.nutrient.carbs, 1),
                        _nutrientWidget('Energy', product.nutrient.energy, 2),
                        _nutrientWidget('Fat', product.nutrient.fats, 3),
                        _nutrientWidget('Fiber', product.nutrient.fiber, 4),
                        _nutrientWidget('Protein', product.nutrient.protein, 5),
                        _nutrientWidget('Sugar', product.nutrient.sugar, 6),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Food Suggestion',
                  style: robotoMedium.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    padding:
                        EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: ColorResources.getBackgroundColor(context),
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
                      product.nutrient.suggestion,
                      maxLines: 20,
                      style: robotoRegular,
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
      ),
    );
  }

  Widget _nutrientWidget(String nutrient, double mass, int index) {
    return Container(
      color: index++ % 2 == 1 ? ColorResources.COLOR_WHITE : Color(0xffE8F9ED),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Row(
        children: [
          Text(
            nutrient,
            style: robotoMedium.copyWith(color: ColorResources.COLOR_BLACK),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  mass.toString(),
                  style: robotoMedium.copyWith(color: Colors.grey),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ],
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
// style: robotoMedium,
// ),
// Text(
// '1883 KJ',
// style: robotoMedium,
// ),
// ],
// )
