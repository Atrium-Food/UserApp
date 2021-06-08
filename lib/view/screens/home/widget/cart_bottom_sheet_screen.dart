import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
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
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/ReviewPage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'detailsPage.dart';
import 'recipePage.dart';

class CartBottomSheetScreen extends StatefulWidget {
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
  _CartBottomSheetScreenState createState() => _CartBottomSheetScreenState();
}

class _CartBottomSheetScreenState extends State<CartBottomSheetScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController(keepScrollOffset: false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map> myProducts =
        List.generate(7, (index) => {"id": index, "name": "Ingredient $index"})
            .toList();

    final List<Widget> ingredients = [
      Row(children: [
        Text(
          'Ingredient1',
          style: robotoRegular,
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
                style: robotoMedium.copyWith(
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
          style: robotoRegular,
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
                style: robotoMedium.copyWith(
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
          style: robotoRegular,
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
                style: robotoMedium.copyWith(
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

    bool fromCart = widget.cart != null;
    Provider.of<ProductProvider>(context, listen: false)
        .initData(widget.product, widget.cart);
    Variation _variation = Variation();

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                forceElevated: value,
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
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [StretchMode.fadeTitle],
                  background: Container(
                    padding: EdgeInsets.only(top: 0.0, right: 8, left: 20),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: robotoMedium.copyWith(
                                  color: ColorResources.getAccentColor(context),
                                  fontSize: 25),
                            ),
                            RatingBar(
                                rating: widget.product.rating != null
                                    ? double.parse(
                                        widget.product.rating.average)
                                    : 0.0,
                                size: 10),
                          ],
                        ),
                        Spacer(),
                        Consumer<WishListProvider>(
                            builder: (context, wishList, child) {
                          return IconButton(
                            onPressed: () {
                              Provider.of<AuthProvider>(context, listen: false)
                                      .isLoggedIn()
                                  ? wishList.wishIdList
                                          .contains(widget.product.id)
                                      ? wishList.removeFromWishList(
                                          widget.product, (message) {})
                                      : wishList.addToWishList(
                                          widget.product, (message) {})
                                  : showCustomSnackBar(
                                      'Login to add favorites', context);
                            },
                            icon: Icon(
                              wishList.wishIdList.contains(widget.product.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: wishList.wishIdList
                                      .contains(widget.product.id)
                                  ? ColorResources.getAccentColor(context)
                                  : ColorResources.getAccentColor(context),
                              size: 20,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  titlePadding: EdgeInsets.only(left: 15),
                  centerTitle: true,
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
                      color: ColorResources.getThemeColor(context),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      unselectedLabelColor:
                          ColorResources.getGreyBunkerColor(context),
                      labelColor: ColorResources.getThemeColor(context),
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
                              style: robotoRegular.copyWith(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 8, 2, 8),
                          child: Text('RECIPE',
                              style: robotoRegular.copyWith(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 8, 2, 8),
                          child: Text('REVIEW',
                              style: robotoRegular.copyWith(fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              DetailsPage(
                product: widget.product,
                callback: widget.callback,
                cart: widget.cart,
                cartIndex: widget.cartIndex,
              ),
              RecipePage(product: widget.product),
              ReviewPage(product: widget.product),
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
