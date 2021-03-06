import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final bool isAvailable;
  ProductWidget({@required this.product,this.isAvailable=true});

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    if (product.choiceOptions != null && product.choiceOptions.length != 0) {
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

    double _discountedPrice = PriceConverter.convertWithDiscount(
        context, product.price, product.discount, product.discountType);

    // DateTime _currentTime =
    //     Provider.of<SplashProvider>(context, listen: false).currentTime;
    // DateTime _start = DateFormat('hh:mm:ss').parse(product.availableTimeStarts);
    // DateTime _end = DateFormat('hh:mm:ss').parse(product.availableTimeEnds);
    // DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
    //     _currentTime.day, _start.hour, _start.minute, _start.second);
    // DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
    //     _currentTime.day, _end.hour, _end.minute, _end.second);
    // if (_endTime.isBefore(_startTime)) {
    //   _endTime = _endTime.add(Duration(days: 1));
    // }
    // bool _isAvailable =
    //     _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);

    return InkWell(
      onTap: () {
        print(isAvailable);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartBottomSheetScreen(
                product: product,
                callback: (CartModel cartModel) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(getTranslated('added_to_cart', context)),
                      backgroundColor: Colors.green));
                },
                isAvailable: isAvailable
              ),
            ));
      },
      child: Container(
        height: 105,
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[
                  Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder_image,
                  image:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                  imageErrorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Image.asset(
                      Images.placeholder_image,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 95,
                    );
                  },
                  height: 100,
                  width: 95,
                  fit: BoxFit.cover,
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
                        child: Text(
                            'Not available\n in your area',
                            textAlign: TextAlign.center,
                            style: robotoRegular.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                            )),
                      ),
                    ),
            ],
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(product.name,
                            style: robotoMedium.copyWith(fontSize: 15),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                      InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (con) => CartBottomSheet(
                                product: product,
                                callback: (CartModel cartModel) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                              'added_to_cart', context)),
                                          backgroundColor: Colors.green));
                                },
                                isAvailable: isAvailable,
                              ),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: ColorResources.getGrayColor(context),
                                  //     blurRadius: 10.0,
                                  //   ),
                                  // ]
                                  border: Border.all(
                                      color: ColorResources.getGrayColor(
                                          context))),
                              child: Icon(
                                Icons.add,
                                color: ColorResources.getAccentColor(context),
                                size: 20,
                              ))),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    product.description ?? '',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        fontWeight: FontWeight.w300,
                        color: ColorResources.getGrayColor(context)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}'
                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}' : ''}',
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT - 1,
                            fontWeight: FontWeight.w600),
                      ),
                      RatingBar(
                        rating: product.rating != null
                            // product.rating.length > 0
                            ? product.rating.average ?? 0 :0
                            ,
                        size: 10,
                        color: ColorResources.getGrayColor(context),
                      ),
                    ],
                  ),
                  product.price > _discountedPrice
                      ? Text(
                          '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                          '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                          style: robotoMedium.copyWith(
                            color: ColorResources.COLOR_GREY,
                            decoration: TextDecoration.lineThrough,
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL - 1,
                          ))
                      : SizedBox(),
                ]),
          ),
        ]),
      ),
    );
  }
}
