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
import 'package:flutter_restaurant/view/screens/rare_review/rate_review_screen.dart';
import 'package:flutter_restaurant/view/screens/rare_review/review_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detailsPage.dart';

class RecipePage extends StatelessWidget {
  final Product product;

  RecipePage({
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    List<String> _recipe = [
      'Place the meat in the freezer for 20 minutes.',
      'Whisk coriander, brown sugar, soy sauce, lime juice, garlic, and ground ginger together in a bowl until marinade is well combined.',
      'Remove meat from freezer and slice thinly across the grain. Place steak in a large bowl, pour marinade over steak, and toss to coat. Cover bowl and marinate at room temperature for 1 hour.',
      "Set oven rack about 6 inches from the heat source and preheat the oven's broiler. Line bottom of a broiler pan with foil.",
      "Lay meat slices in a single layer on the rack of the prepared broiler pan.",
      "Cook in the preheated broiler, brushing occasionally with marinade, until steak reaches desired doneness, 1 to 2 minutes for medium rare."
    ];

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_rectangle,
                        image:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                        height: 180,
                        fit: BoxFit.fill,
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      launch(
                          'tel:${Provider.of<SplashProvider>(context, listen: false).configModel.recipePhone}');
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: ColorResources.COLOR_WHITE,
                        border: Border.all(
                            color: ColorResources.COLOR_PRIMARY, width: 2),
                      ),
                      child: Text(
                        'Cooking Support',
                        style: rubikMedium.copyWith(
                          fontSize: 13,
                          color: ColorResources.COLOR_PRIMARY,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Directions',
                style: rubikMedium.copyWith(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Follow these instructions carefully to get the best taste of your own hands. Feel free to contact us if you have any doubt regarding the recipe.',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _recipe.length,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    margin: EdgeInsets.only(
                      top: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    ),
                    decoration: BoxDecoration(
                        color: ColorResources.COLOR_WHITE,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(1, 1),
                          )
                        ]),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFFE1E1E1),
                          radius: 12,
                          child: Text(
                            '${index + 1}',
                            style: rubikRegular.copyWith(
                                color: Colors.black, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            _recipe[index],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductReviewScreen(
                                  productID: product.id,
                                )));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: Dimensions.PADDING_SIZE_SMALL,
                      bottom: Dimensions.PADDING_SIZE_SMALL,
                      left: Dimensions.PADDING_SIZE_EXTRA_LARGE + 40,
                      right: Dimensions.PADDING_SIZE_EXTRA_LARGE + 40,
                    ),
                    decoration: BoxDecoration(
                      color: ColorResources.COLOR_WHITE,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                          color: ColorResources.COLOR_PRIMARY, width: 3),
                    ),
                    child: Text(
                      'Write a review',
                      style: rubikRegular.copyWith(
                          color: ColorResources.COLOR_PRIMARY, fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
