import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
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
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/nutrient_values.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatelessWidget {
  final Product product;
  final bool fromSetMenu;
  final Function callback;
  final CartModel cart;
  final int cartIndex;
  final bool isAvailable;
  DetailsPage(
      {@required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex,
      this.isAvailable = false});

  @override
  Widget build(BuildContext context) {
    Color link = Colors.greenAccent;
    bool isPressed = false;

    // final List<Map> myProducts =
    //     List.generate(7, (index) => {"id": index, "name": "Ingredient $index"})
    //         .toList();

    bool fromCart = cart != null;
    Provider.of<ProductProvider>(context, listen: false)
        .initData(product, cart);
    Variation _variation = Variation();

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
      ),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          double _startingPrice;
          double _endingPrice;
          if (product.choiceOptions != null &&
              product.choiceOptions.length != 0) {
            List<double> _priceList = [];
            product.variations
                .forEach((variation) => _priceList.add(variation.price));
            _priceList.sort((a, b) => a.compareTo(b));
            _startingPrice = _priceList[0];
            if (_priceList[0] < _priceList[_priceList.length - 1]) {
              _endingPrice = _priceList[_priceList.length - 1];
            }
          } else {
            _startingPrice = product.price;
          }

          List<String> _variationList = [];
          if (product.choiceOptions != null) {
            for (int index = 0; index < product.choiceOptions.length; index++) {
              _variationList.add(product.choiceOptions[index]
                  .options[productProvider.variationIndex[index]]
                  .replaceAll(' ', ''));
            }
          }
          String variationType = '';
          bool isFirst = true;
          if (_variationList != null) {
            _variationList.forEach((variation) {
              if (isFirst) {
                variationType = '$variationType$variation';
                isFirst = false;
              } else {
                variationType = '$variationType-$variation';
              }
            });
          }

          double price = product.price;
          for (Variation variation in product.variations) {
            if (variation.type == variationType) {
              price = variation.price;
              _variation = variation;
              break;
            }
          }
          double priceWithDiscount = PriceConverter.convertWithDiscount(
              context, price, product.discount, product.discountType);
          double priceWithQuantity =
              priceWithDiscount * productProvider.quantity;
          double addonsCost = 0;
          List<AddOn> _addOnIdList = [];
          for (int index = 0; index < product.addOns.length; index++) {
            if (productProvider.addOnActiveList[index]) {
              addonsCost = addonsCost +
                  (product.addOns[index].price *
                      productProvider.addOnQtyList[index]);
              _addOnIdList.add(AddOn(
                  id: product.addOns[index].id,
                  quantity: productProvider.addOnQtyList[index]));
            }
          }
          double priceWithAddons = priceWithQuantity + addonsCost;

          // DateTime _currentTime =
          //     Provider.of<SplashProvider>(context, listen: false).currentTime;
          // DateTime _start =
          //     DateFormat('hh:mm:ss').parse(product.availableTimeStarts);
          // DateTime _end =
          //     DateFormat('hh:mm:ss').parse(product.availableTimeEnds);
          // DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
          //     _currentTime.day, _start.hour, _start.minute, _start.second);
          // DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
          //     _currentTime.day, _end.hour, _end.minute, _end.second);
          // if (_endTime.isBefore(_startTime)) {
          //   _endTime = _endTime.add(Duration(days: 1));
          // }
          // bool _isAvailable = _currentTime.isAfter(_startTime) &&
          //     _currentTime.isBefore(_endTime);

          CartModel _cartModel = CartModel(
            price,
            priceWithDiscount,
            [_variation],
            (price -
                PriceConverter.convertWithDiscount(
                    context, price, product.discount, product.discountType)),
            productProvider.quantity,
            price -
                PriceConverter.convertWithDiscount(
                    context, price, product.tax, product.taxType),
            _addOnIdList,
            product,
          );
          bool isExistInCart = Provider.of<CartProvider>(context, listen: false)
              .isExistInCart(_cartModel, fromCart, cartIndex);

          return SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //Product
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder_rectangle,
                            image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Image.asset(
                                Images.placeholder_rectangle,
                                fit: BoxFit.cover,
                                height: 170,
                                width: MediaQuery.of(context).size.width,
                              );
                            },
                          ),
                        ),
                        isAvailable
                            ? SizedBox()
                            : Positioned(
                                top: 0,
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.6)),
                                  child: Text('Not available\n in your area',
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                      )),
                                ),
                              ),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),

              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Text(
                'From Atrium',
                style: robotoMedium.copyWith(
                    fontSize: 20,
                    color: ColorResources.getAccentColor(context)),
              ),

              SizedBox(
                height: 15,
              ),

              Text(
                '"${product.description}"',
                maxLines: 20,
                style: robotoRegular.copyWith(
                  fontSize: 12.5,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: ColorResources.getAccentColor(context),
                ),
              ),

              SizedBox(height: Dimensions.PADDING_SIZE_LARGE + 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Cuisine',
                        style: robotoRegular.copyWith(
                            fontSize: 11,
                            color: ColorResources.getGreyColor(context)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SvgPicture.asset(
                        Images.cuisine,
                        color: ColorResources.getAccentColor(context),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(product.cuisine != null ? product.cuisine : 'Indian',
                          style: TextStyle(
                              fontSize: 11,
                              color: ColorResources.getAccentColor(context))),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Time',
                        style: robotoRegular.copyWith(
                            fontSize: 11,
                            color: ColorResources.getGreyColor(context)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Icon(CupertinoIcons.time),
                      SizedBox(
                        height: 5,
                      ),
                      Text(product.time != null ? product.time : '1 hr 45 min',
                          style: TextStyle(
                              fontSize: 11,
                              color: ColorResources.getAccentColor(context))),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Serves',
                        style: robotoRegular.copyWith(
                            fontSize: 11,
                            color: ColorResources.getGreyColor(context)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SvgPicture.asset(
                        Images.serving,
                        color: ColorResources.getAccentColor(context),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          product.serves != null
                              ? product.serves.toString()
                              : '2',
                          style: TextStyle(
                              fontSize: 11,
                              color: ColorResources.getAccentColor(context))),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Per Serving',
                        style: robotoRegular.copyWith(
                            fontSize: 11,
                            color: ColorResources.getGreyColor(context)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SvgPicture.asset(
                        Images.hot,
                        color: ColorResources.getAccentColor(context),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          product.calories_per_serving != null
                              ? product.calories_per_serving.toStringAsFixed(1)
                              : '590 cal',
                          style: TextStyle(
                              fontSize: 11,
                              color: ColorResources.getAccentColor(context))),
                    ],
                  ),
                ],
              ),

              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Expanded(
              //           child: Row(
              //             children: [
              //               Icon(
              //                 CupertinoIcons.clock_solid,
              //                 color: ColorResources.getAccentColor(context),
              //               ),
              //               SizedBox(
              //                 width: 5.0,
              //               ),
              //               Text('1 hour 45 mins',
              //                   style: robotoRegular.copyWith(
              //                       color: ColorResources.getAccentColor(
              //                           context))),
              //             ],
              //           ),
              //         ),
              //         SizedBox(
              //           width: 10.0,
              //         ),
              //         Expanded(
              //           child: Row(
              //             children: [
              //               SvgPicture.asset(Images.serving),
              //               SizedBox(
              //                 width: 5.0,
              //               ),
              //               Text('Server 2',
              //                   style: robotoRegular.copyWith(
              //                       color:
              //                           ColorResources.getAccentColor(context)))
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //     SizedBox(
              //       height: 21.0,
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Expanded(
              //           child: Row(
              //             children: [
              //               SvgPicture.asset(Images.cuisine),
              //               SizedBox(
              //                 width: 5.0,
              //               ),
              //               Text('Thai Cuisine',
              //                   style: robotoRegular.copyWith(
              //                       color: ColorResources.getAccentColor(
              //                           context))),
              //             ],
              //           ),
              //         ),
              //         SizedBox(
              //           width: 10.0,
              //         ),
              //         Expanded(
              //           child: Column(
              //             children: [
              //               Row(
              //                 children: [
              //                   SvgPicture.asset(Images.hot),
              //                   SizedBox(
              //                     width: 5.0,
              //                   ),
              //                   Text('569 cal/serving',
              //                       style: robotoRegular.copyWith(
              //                           color: ColorResources.getAccentColor(
              //                               context))),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),

              SizedBox(height: Dimensions.PADDING_SIZE_LARGE + 10),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NutrientValues(
                                product: product,
                              )));
                },
                child: Card(
                  elevation: 3,
                  child: Container(
                    padding:
                        EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: ColorResources.getBackgroundColor(context),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 2,
                      //     blurRadius: 5,
                      //     offset: Offset(0, 3), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nutritional Value',
                              style: robotoMedium,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Glycemic Index',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ColorResources.getAccentColor(
                                          context)),
                                ),
                                SizedBox(
                                  width: 3,
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
                                    product.nutrient.glycemicIndex.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: ColorResources.getBackgroundColor(
                                          context),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Glycemic Index',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ColorResources.getAccentColor(
                                          context)),
                                ),
                                SizedBox(
                                  width: 3,
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
                                    product.nutrient.glycemicLoad.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: ColorResources.getBackgroundColor(
                                          context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //   SizedBox(
                            //     height: 10,
                            //   ),
                            //   Row(
                            //     children: [
                            //       Text('Glycemic Index'),
                            //       SizedBox(
                            //         width: 7,
                            //       ),
                            //       Container(
                            //         padding: EdgeInsets.only(left: 7, right: 7),
                            //         decoration: BoxDecoration(
                            //           color:
                            //               ColorResources.getPrimaryColor(context),
                            //           borderRadius:
                            //               BorderRadius.all(Radius.circular(10)),
                            //         ),
                            //         child: Text(
                            //           '3',
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                          ],
                        ),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircularPercentIndicator(
                                lineWidth: 6,
                                radius: 50,
                                backgroundColor: ColorResources.COLOR_WHITE,
                                percent: 0.74,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor:
                                    ColorResources.getPrimaryColor(context),
                                center: Text(
                                  product.nutrient.score.toStringAsFixed(1),
                                  style: robotoMedium.copyWith(
                                      color: ColorResources.getPrimaryColor(
                                          context),
                                      fontSize: 15),
                                ),
                              ),
                              // VerticalDivider(
                              //   color: Colors.black,
                              //   thickness: 2.0,
                              //   width: 3.0,
                              // ),
                              SizedBox(
                                width: 6,
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.info,
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NutrientValues(
                                                product: product,
                                              )));
                                },
                              ),
                            ],
                          ),
                        ),
                        // CircularPercentIndicator(
                        //   lineWidth: 6,
                        //   radius: 50,
                        //   backgroundColor: ColorResources.COLOR_WHITE,
                        //   percent: 0.74,
                        //   circularStrokeCap: CircularStrokeCap.round,
                        //   progressColor: ColorResources.getPrimaryColor(context),
                        //   center: Text(
                        //     '7.4',
                        //     style: robotoMedium.copyWith(
                        //         color: ColorResources.getPrimaryColor(context),
                        //         fontSize: 15),
                        //   ),
                        // ),
                        // VerticalDivider(
                        //   color: ColorResources.COLOR_BLACK,
                        //   thickness: 2,
                        // ),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.info,
                        //     color: ColorResources.getPrimaryColor(context),
                        //   ),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => NutrientValues()));
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: Dimensions.PADDING_SIZE_LARGE + 10),

              // Quantity
              Row(children: [
                Text(getTranslated('quantity', context),
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                Expanded(child: SizedBox()),
                Container(
                  decoration: BoxDecoration(
                      color: ColorResources.getBackgroundColor(context),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(children: [
                    InkWell(
                      onTap: () {
                        if (productProvider.quantity > 1) {
                          productProvider.setQuantity(false);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffDEDEDE),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Icon(
                          Icons.remove,
                          size: 20,
                          color: ColorResources.COLOR_GRAY,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL - 2,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffDEDEDE),
                      ),
                      child: Text(productProvider.quantity.toString(),
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: ColorResources.COLOR_BLACK)),
                    ),
                    InkWell(
                      onTap: () => productProvider.setQuantity(true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffDEDEDE),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: ColorResources.COLOR_BLACK,
                        ),
                      ),
                    ),
                  ]),
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              // Variation
              if (product.choiceOptions != null)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: product.choiceOptions.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.choiceOptions[index].title,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE)),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                              childAspectRatio: (1 / 0.25),
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                product.choiceOptions[index].options.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  productProvider.setCartVariationIndex(
                                      index, i);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  decoration: BoxDecoration(
                                    color:
                                        productProvider.variationIndex[index] !=
                                                i
                                            ? ColorResources.BACKGROUND_COLOR
                                            : ColorResources.COLOR_PRIMARY,
                                    borderRadius: BorderRadius.circular(5),
                                    border: productProvider
                                                .variationIndex[index] !=
                                            i
                                        ? Border.all(
                                            color: ColorResources.BORDER_COLOR,
                                            width: 2)
                                        : null,
                                  ),
                                  child: Text(
                                    product.choiceOptions[index].options[i]
                                        .trim(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: robotoRegular.copyWith(
                                      color: productProvider
                                                  .variationIndex[index] !=
                                              i
                                          ? ColorResources.COLOR_BLACK
                                          : ColorResources.COLOR_WHITE,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                              height: index != product.choiceOptions.length - 1
                                  ? Dimensions.PADDING_SIZE_LARGE
                                  : 0),
                        ]);
                  },
                ),
              if (product.choiceOptions != null)
                product.choiceOptions.length > 0
                    ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE)
                    : SizedBox(),

              fromSetMenu
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(getTranslated('description', context),
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE)),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Text(product.description ?? '', style: robotoRegular),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        ])
                  : SizedBox(),

              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              //Ingredients

              Text('Ingredients',
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE)),

              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 5,
                    // mainAxisExtent: 130,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: product.ingredients.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28.0,
                            child: Text(
                              product.ingredients[index].name
                                  .substring(0, 2)
                                  .toUpperCase(),
                              style: robotoRegular.copyWith(
                                  color:
                                      ColorResources.getAccentColor(context)),
                            ),
                            backgroundColor:
                                ColorResources.getSearchBg(context),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            product.ingredients[index].name,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                          // SizedBox(
                          //   height: 7,
                          // ),
                          // Row(children: [
                          //   InkWell(
                          //     onTap: () {
                          //       if (productProvider.quantity > 1) {
                          //         productProvider.setQuantity(false);
                          //       }
                          //     },
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         color: Color(0xffDEDEDE),
                          //         borderRadius: BorderRadius.only(
                          //           topLeft: Radius.circular(10),
                          //           bottomLeft: Radius.circular(10),
                          //         ),
                          //       ),
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal:
                          //               Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          //           vertical:
                          //               Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          //       child: Icon(
                          //         Icons.remove,
                          //         size: 20,
                          //         color: ColorResources.COLOR_GRAY,
                          //       ),
                          //     ),
                          //   ),
                          //   Container(
                          //     padding: EdgeInsets.symmetric(
                          //       horizontal: 8,
                          //       vertical:
                          //           Dimensions.PADDING_SIZE_EXTRA_SMALL - 2,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: Color(0xffDEDEDE),
                          //     ),
                          //     child: Text(productProvider.quantity.toString(),
                          //         style: robotoMedium.copyWith(
                          //             fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                          //   ),
                          //   InkWell(
                          //     onTap: () => productProvider.setQuantity(true),
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         color: Color(0xffDEDEDE),
                          //         borderRadius: BorderRadius.only(
                          //           topRight: Radius.circular(10),
                          //           bottomRight: Radius.circular(10),
                          //         ),
                          //       ),
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal:
                          //               Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          //           vertical:
                          //               Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          //       child: Icon(
                          //         Icons.add,
                          //         size: 20,
                          //         color: ColorResources.COLOR_BLACK,
                          //       ),
                          //     ),
                          //   ),
                          // ]),
                        ],
                      ),
                    );
                  }),

              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              // Addons
              product.addOns.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(getTranslated('addons', context),
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE)),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                              childAspectRatio: (1 / 1.1),
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: product.addOns.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (!productProvider.addOnActiveList[index]) {
                                    productProvider.addAddOn(true, index);
                                  } else if (productProvider
                                          .addOnQtyList[index] ==
                                      1) {
                                    productProvider.addAddOn(false, index);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      bottom:
                                          productProvider.addOnActiveList[index]
                                              ? 2
                                              : 20),
                                  decoration: BoxDecoration(
                                    color:
                                        productProvider.addOnActiveList[index]
                                            ? ColorResources.COLOR_PRIMARY
                                            : ColorResources.BACKGROUND_COLOR,
                                    borderRadius: BorderRadius.circular(5),
                                    border: productProvider
                                            .addOnActiveList[index]
                                        ? null
                                        : Border.all(
                                            color: ColorResources.BORDER_COLOR,
                                            width: 2),
                                    boxShadow:
                                        productProvider.addOnActiveList[index]
                                            ? [
                                                BoxShadow(
                                                    color: Colors.grey[
                                                        Provider.of<ThemeProvider>(
                                                                    context)
                                                                .darkTheme
                                                            ? 700
                                                            : 300],
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ]
                                            : null,
                                  ),
                                  child: Column(children: [
                                    Expanded(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          Text(product.addOns[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: robotoMedium.copyWith(
                                                color: productProvider
                                                        .addOnActiveList[index]
                                                    ? ColorResources.COLOR_WHITE
                                                    : ColorResources
                                                        .COLOR_BLACK,
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                              )),
                                          SizedBox(height: 3),
                                          Text(
                                            PriceConverter.convertPrice(context,
                                                product.addOns[index].price),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoRegular.copyWith(
                                                color: productProvider
                                                        .addOnActiveList[index]
                                                    ? ColorResources.COLOR_WHITE
                                                    : ColorResources
                                                        .COLOR_BLACK,
                                                fontSize: Dimensions
                                                        .FONT_SIZE_EXTRA_SMALL -
                                                    1),
                                          ),
                                        ])),
                                    productProvider.addOnActiveList[index]
                                        ? Container(
                                            height: 25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Theme.of(context)
                                                    .accentColor),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (productProvider
                                                                    .addOnQtyList[
                                                                index] >
                                                            1) {
                                                          productProvider
                                                              .setAddOnQuantity(
                                                                  false, index);
                                                        } else {
                                                          productProvider
                                                              .addAddOn(
                                                                  false, index);
                                                        }
                                                      },
                                                      child: Center(
                                                          child: Icon(
                                                              Icons.remove,
                                                              size: 14)),
                                                    ),
                                                  ),
                                                  Text(
                                                      productProvider
                                                          .addOnQtyList[index]
                                                          .toString(),
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                                  .FONT_SIZE_SMALL -
                                                              1)),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () =>
                                                          productProvider
                                                              .setAddOnQuantity(
                                                                  true, index),
                                                      child: Center(
                                                          child: Icon(Icons.add,
                                                              size: 14)),
                                                    ),
                                                  ),
                                                ]),
                                          )
                                        : SizedBox(),
                                  ]),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        ])
                  : SizedBox(),

              Row(children: [
                Text('${getTranslated('total_amount', context)}:',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(PriceConverter.convertPrice(context, priceWithAddons),
                    style: robotoBold.copyWith(
                      color: ColorResources.COLOR_PRIMARY,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
              ]),
              SizedBox(height: 18.0),

              !isAvailable
<<<<<<< HEAD
                  ? CustomButton(
                      btnTxt: 'Request in your area',
                      backgroundColor: Theme.of(context).primaryColor,
                      onTap: (!isExistInCart)
                          ? () {
                              TextEditingController _pinCodeController =
                                  TextEditingController();
                              String errorMessage = '';
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Request for a pantry in your area',
                                        style: robotoRegular.copyWith(
                                            fontSize: 15),
                                      ),
                                      content: Consumer<LocationProvider>(
                                          builder: (context, locationProvider,
                                              child) {
                                        return Column(
=======
                  ? Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                      return Column(
                        children: [
                          Text(
                            locationProvider.requestPantryStatus,
                            style: robotoRegular.copyWith(
                                color: ColorResources.getPrimaryColor(context)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomButton(
                              btnTxt: 'Request in your area',
                              backgroundColor: Theme.of(context).primaryColor,
                              onTap: () {
                                TextEditingController _pinCodeController =
                                    TextEditingController();
                                String errorMessage = '';
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Request for a pantry in your area',
                                          style: robotoRegular.copyWith(
                                              fontSize: 15),
                                        ),
                                        content: Column(
>>>>>>> a75dfc8461879b9e3975d2dc24bf3e49ca051d4d
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: CustomTextField(
                                                controller: _pinCodeController,
                                                hintText: 'Enter pincode',
                                                inputType: TextInputType.number,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            locationProvider.isLoading
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(
<<<<<<< HEAD
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                                Color>(
                                                            ColorResources
                                                                .getPrimaryColor(
                                                                    context)),
=======
                                                    color: ColorResources
                                                        .getPrimaryColor(
                                                            context),
>>>>>>> a75dfc8461879b9e3975d2dc24bf3e49ca051d4d
                                                  ))
                                                : SizedBox(),
                                            // Text(locationProvider.errorMessage?? '',style: robotoRegular.copyWith(color: ColorResources.getPrimaryColor(context),fontSize: 10),)
                                          ],
<<<<<<< HEAD
                                        );
                                      }),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              ResponseModel responseModel =
                                                  await Provider.of<
                                                              LocationProvider>(
                                                          context,
                                                          listen: false)
                                                      .submitRequestInArea(
                                                pincode:
                                                    _pinCodeController.text,
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: Text('Request')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'))
                                      ],
                                    );
                                  });
                            }
                          : null,
                    )
                  : CustomButton(
                      btnTxt: getTranslated(
                          isExistInCart
                              ? 'already_added_in_cart'
                              : fromCart
                                  ? 'update_in_cart'
                                  : 'add_to_cart',
                          context),
                      backgroundColor: Theme.of(context).primaryColor,
                      onTap: (!isExistInCart)
                          ? () {
                              if (!isExistInCart) {
                                Navigator.pop(context);
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addToCart(_cartModel, cartIndex);
                                callback(_cartModel);
                              }
                            }
                          : null,
=======
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                ResponseModel responseModel =
                                                    await Provider.of<
                                                                LocationProvider>(
                                                            context,
                                                            listen: false)
                                                        .submitRequestInArea(
                                                  pincode:
                                                      _pinCodeController.text,
                                                );
                                                if (responseModel.isSuccess) {
                                                  Provider.of<LocationProvider>(
                                                          context,
                                                          listen: false)
                                                      .setRequestStatus(
                                                          'Successfully Requested');
                                                  Navigator.pop(context);
                                                } else {
                                                  Provider.of<LocationProvider>(
                                                          context,
                                                          listen: false)
                                                      .setRequestStatus(
                                                          "Request Failed");
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text('Request')),
                                          TextButton(
                                              onPressed: () {
                                                Provider.of<LocationProvider>(
                                                        context,
                                                        listen: false)
                                                    .setIsLoadingFalse();
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'))
                                        ],
                                      );
                                    });
                              }),
                        ],
                      );
                    })
                  : CustomButton(
                      btnTxt: getTranslated(
                          isExistInCart
                              ? 'already_added_in_cart'
                              : fromCart
                                  ? 'update_in_cart'
                                  : 'add_to_cart',
                          context),
                      backgroundColor: Theme.of(context).primaryColor,
                      onTap: (!isExistInCart)
                          ? () {
                              if (!isExistInCart) {
                                Navigator.pop(context);
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addToCart(_cartModel, cartIndex);
                                callback(_cartModel);
                              }
                            }
                          : null,
>>>>>>> a75dfc8461879b9e3975d2dc24bf3e49ca051d4d
                    ),
              // : Container(
              //     alignment: Alignment.center,
              //     padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Theme.of(context).primaryColor.withOpacity(0.1),
              //     ),
              //     child: Column(children: [
              //       Text(getTranslated('not_available_now', context),
              //           style: robotoMedium.copyWith(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: Dimensions.FONT_SIZE_LARGE,
              //           )),
              //       Text(
              //         '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(product.availableTimeStarts)} '
              //         '- ${DateConverter.convertTimeToTime(product.availableTimeEnds)}',
              //         style: robotoRegular,
              //       ),
              //     ]),
              //   ),
            ]),
          );
        },
      ),
    );
  }
}
