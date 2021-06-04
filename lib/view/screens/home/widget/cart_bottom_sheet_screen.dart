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
import 'package:flutter_restaurant/view/screens/home/widget/ReviewPage.dart';
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
                backgroundColor: ColorResources.getPrimaryColor(context),
                toolbarHeight: MediaQuery.of(context).size.height * 0.065,
                collapsedHeight: MediaQuery.of(context).size.height * 0.065,
                expandedHeight: MediaQuery.of(context).size.height * 0.25,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 15),
                  centerTitle: true,
                  title: Container(
                    padding: EdgeInsets.only(top: 65.0, right: 8),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: rubikMedium.copyWith(
                                color: ColorResources.getAccentColor(context),
                              ),
                            ),
                            RatingBar(
                                rating: product.rating != null
                                    ? double.parse(product.rating.average)
                                    : 0.0,
                                size: 10),
                          ],
                        ),
                        Spacer(),
                        Consumer<WishListProvider>(
                            builder: (context, wishList, child) {
                          return IconButton(
                            onPressed: () {
                              wishList.wishIdList.contains(product.id)
                                  ? wishList.removeFromWishList(
                                      product, (message) {})
                                  : wishList.addToWishList(
                                      product, (message) {});
                            },
                            icon: Icon(
                              wishList.wishIdList.contains(product.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: wishList.wishIdList.contains(product.id)
                                  ? ColorResources.getAccentColor(context)
                                  : ColorResources.getAccentColor(context),
                              size: 20,
                            ),
                          );
                        })
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
                  preferredSize: Size.fromHeight(20.0),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 20.0, left: 15, right: 15),
                    // padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TabBar(
                      unselectedLabelColor:
                          ColorResources.getGrayColor(context),
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        shape: BoxShape.rectangle,
                        color: ColorResources.getIndicatorPrimaryColor(context),
                      ),
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 8, 2, 8),
                          child: Text('DETAILS',
                              style: rubikRegular.copyWith(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 8, 2, 8),
                          child: Text('RECIPE',
                              style: rubikRegular.copyWith(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 8, 2, 8),
                          child: Text('REVIEW',
                              style: rubikRegular.copyWith(fontSize: 13)),
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
              ReviewPage(product: product),
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
