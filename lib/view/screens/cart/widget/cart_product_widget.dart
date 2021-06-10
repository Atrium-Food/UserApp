import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  CartProductWidget({@required this.cart, @required this.cartIndex, @required this.isAvailable, @required this.addOns});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => CartBottomSheet(
            product: cart.product,
            cartIndex: cartIndex,
            cart: cart,
            callback: (CartModel cartModel) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('updated_in_cart', context)), backgroundColor: ColorResources.getPrimaryColor(context)));
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          Positioned(
            top: 0, bottom: 0, right: 0, left: 0,
            child: Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
          ),
          Dismissible(
            key: Key(cart.variation.length > 0 ? cart.variation[0].type : cart.product.id.toString()),
            onDismissed: (DismissDirection direction) => Provider.of<CartProvider>(context, listen: false).removeFromCart(cart),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                  blurRadius: 5, spreadRadius: 1,
                )],
              ),
              child: Column(
                children: [
                  Row(children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder_image,
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${cart.product.image}',
                            height: 70, width: 85, fit: BoxFit.cover,
                            imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                              return Image.asset(Images.placeholder_image, fit: BoxFit.contain,
                                height: 70, width: 85
                              );
                            },
                          ),
                        ),
                        isAvailable ? SizedBox() : Positioned(
                          top: 0, left: 0, bottom: 0, right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                            child: Text(getTranslated('not_available_now_break', context), textAlign: TextAlign.center, style: robotoRegular.copyWith(
                              color: Colors.white, fontSize: 8,
                            )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(cart.product.name, style: robotoMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 2),
                        RatingBar(rating: cart.product.rating!=null ? cart.product.rating.average : 0.0, size: 12),
                        SizedBox(height: 5),
                        Row(children: [
                          Flexible(
                            child: Text(
                              PriceConverter.convertPrice(context, cart.discountedPrice),
                              style: robotoBold,
                            ),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          cart.discountAmount > 0 ? Flexible(
                            child: Text(PriceConverter.convertPrice(context, cart.discountedPrice+cart.discountAmount), style: robotoBold.copyWith(
                              color: ColorResources.COLOR_GREY,
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              decoration: TextDecoration.lineThrough,
                            )),
                          ) : SizedBox(),
                        ]),
                      ]),
                    ),

                    Container(
                      decoration: BoxDecoration(color: ColorResources.getBackgroundColor(context), borderRadius: BorderRadius.circular(5)),
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            if(cart.quantity==1){
                              // print("Quantity 1 ");
                              // print("Cart ${cart.toJson()}");
                              Provider.of<CartProvider>(context, listen: false).removeFromCart(cart);
                            }
                            if (cart.quantity > 1) {
                              // print("Quantity > 1 ");
                              // print("${cart.toJson()}");
                              Provider.of<CartProvider>(context, listen: false).setQuantity(false, cart);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.remove, size: 20),
                          ),
                        ),
                        Text(cart.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                        InkWell(
                          // onTap: () => print("${cart.toJson()}"),
                          onTap: () => Provider.of<CartProvider>(context, listen: false).setQuantity(true, cart),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.add, size: 20),
                          ),
                        ),
                      ]),
                    ),

                  ]),

                  addOns.length > 0 ? SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                      itemCount: addOns.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                          child: Row(children: [
                            InkWell(
                              onTap: () {
                                Provider.of<CartProvider>(context, listen: false).removeAddOn(cartIndex, index);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                              ),
                            ),
                            Text(addOns[index].name, style: robotoRegular),
                            SizedBox(width: 2),
                            Text(PriceConverter.convertPrice(context, addOns[index].price), style: robotoMedium),
                            SizedBox(width: 2),
                            Text('(${cart.addOnIds[index].quantity})', style: robotoRegular),
                          ]),
                        );
                      },
                    ),
                  ) : SizedBox(),

                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
