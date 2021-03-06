import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
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

class ProductDescriptionWidget extends StatelessWidget {
  final Product product;
  ProductDescriptionWidget({@required this.product});

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

    // bool _isAvailable=Provider.of<ProductProvider>(context,listen: false).isDefault;

    // print(_isAvailable);
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartBottomSheetScreen(
                    product: product,
                    isAvailable: !productProvider.isDefault,
                    callback: (CartModel cartModel) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(getTranslated('added_to_cart', context)),
                          backgroundColor: ColorResources.COLOR_PRIMARY));
                    },
                  ),
                ));
          },
          child: Container(
            height: 95,
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
                        return Image.asset(Images.placeholder_image,
                            fit: BoxFit.contain);
                      },
                      height: 70,
                      width: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                      !productProvider.isDefault
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
                          getTranslated('not_available_now_break', context),
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(product.name,
                          style: robotoMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: 5.0),
                      product.description != null
                          ? Text(product.description,
                              style: robotoRegular.copyWith(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis)
                          : Text(''),
                    ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (con) => CartBottomSheet(
                          product: product,
                          isAvailable: !productProvider.isDefault,
                          callback: (CartModel cartModel) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text(getTranslated('added_to_cart', context)),
                                backgroundColor: Colors.green));
                          },
                        ),
                      );
                    },
                    child: Icon(Icons.add)),
                Expanded(child: SizedBox()),
                Text(
                  '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}'
                  '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}' : ''}',
                  style:
                      robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                ),
                product.price > _discountedPrice
                    ? Text(
                        '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                        style: robotoMedium.copyWith(
                          color: ColorResources.COLOR_GREY,
                          decoration: TextDecoration.lineThrough,
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        ))
                    : SizedBox(),
              ]),
            ]),
          ),
        );
      }
    );
  }
}
