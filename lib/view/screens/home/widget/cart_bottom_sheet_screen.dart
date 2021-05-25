import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'detailsPage.dart';
import 'recipePage.dart';

class CartBottomSheetScreen extends StatelessWidget {
  final Product product;
  final bool fromSetMenu;
  final Function callback;
  final CartModel cart;
  final int cartIndex;
  CartBottomSheetScreen(
      {@required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex});

  @override
  Widget build(BuildContext context) {
    final List<Map> myProducts =
        List.generate(7, (index) => {"id": index, "name": "Ingredient $index"})
            .toList();

    final List<Widget> ingredients = [
      Row(children: [
        Text(
          'Ingredient1',
          style: rubikRegular,
        ),
        Expanded(child: SizedBox()),
        Container(
          decoration: BoxDecoration(
              color: ColorResources.getBackgroundColor(context),
              borderRadius: BorderRadius.circular(5)),
          child: Row(children: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Icon(Icons.remove, size: 20),
              ),
            ),
            Text('1',
                style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Icon(Icons.add, size: 20),
              ),
            ),
          ]),
        ),
      ]),
      Row(children: [
        Text(
          'Ingredient2',
          style: rubikRegular,
        ),
        Expanded(child: SizedBox()),
        Container(
          decoration: BoxDecoration(
              color: ColorResources.getBackgroundColor(context),
              borderRadius: BorderRadius.circular(5)),
          child: Row(children: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Icon(Icons.remove, size: 20),
              ),
            ),
            Text('1',
                style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Icon(Icons.add, size: 20),
              ),
            ),
          ]),
        ),
      ]),
      Row(children: [
        Text(
          'Ingredient3',
          style: rubikRegular,
        ),
        Expanded(child: SizedBox()),
        Container(
          decoration: BoxDecoration(
              color: ColorResources.getBackgroundColor(context),
              borderRadius: BorderRadius.circular(5)),
          child: Row(children: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Icon(Icons.remove, size: 20),
              ),
            ),
            Text('1',
                style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Icon(Icons.add, size: 20),
              ),
            ),
          ]),
        ),
      ]),
    ];

    bool fromCart = cart != null;
    Provider.of<ProductProvider>(context, listen: false)
        .initData(product, cart);
    Variation _variation = Variation();

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: Colors.green,
                expandedHeight: 200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                floating: true,
                pinned: true,

                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Container(
                    padding: EdgeInsets.only(top: 65.0, right: 120.0),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          style: rubikMedium.copyWith(color: Colors.black),
                        ),
                        RatingBar(
                            rating: product.rating.length > 0
                                ? double.parse(product.rating[0].average)
                                : 0.0,
                            size: 10),
                      ],
                    ),
                  ),
                ),
                //title: Text('My App Bar'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Theme.of(context).textTheme.bodyText1.color,
                  onPressed: () => Navigator.pop(context),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(10.0),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
                    // padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        shape: BoxShape.rectangle,
                        color: Color(0xFF215E23),
                      ),
                      tabs: [
                        Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          'Recipe',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          'Review',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
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
              DetailsPage(
                product: product,
                callback: callback,
                cart: cart,
                cartIndex: cartIndex,
              ),
              RecipePage(product: product),
              Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${product.rating.length > 0 ? double.parse(product.rating[0].average).toStringAsFixed(1) : 0.0}',
                      style: TextStyle(fontSize: 80.0, color: Colors.black),
                    ),
                    RatingBar(
                        rating: product.rating.length > 0
                            ? double.parse(product.rating[0].average)
                            : 0.0,
                        size: 20),
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
                          style: TextStyle(color: Colors.grey),
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
                          style: TextStyle(color: Colors.grey),
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
                          style: TextStyle(color: Colors.grey),
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
                          style: TextStyle(color: Colors.grey),
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
                          style: TextStyle(color: Colors.grey),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImages() {
    return Text('tab1');
  }
}
