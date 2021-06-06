import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

class ProductReviewScreen extends StatefulWidget {
  int productID;
  ProductReviewScreen({this.productID});

  @override
  _ProductReviewScreenState createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  TextEditingController _textEditingController;
  double _rating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rating=0.0;
    print(_rating);
    _textEditingController=TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Review',isBackButtonExist: true,),
      body: FutureBuilder<Object>(
        future: Provider.of<ProductProvider>(context,listen: false).getProductDetails(widget.productID.toString()),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done && snapshot.hasData){
            Product product=snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(top: 20,left: 8.0,right: 8.0),
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  return Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: Offset(0, 1))],
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product details
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder_image,
                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                                height: 70,
                                width: 85,
                                fit: BoxFit.cover,
                                imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                  return Image.asset(Images.placeholder_image, fit: BoxFit.contain);
                                },
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(product.name, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                SizedBox(height: 10),
                                Text(PriceConverter.convertPrice(context, product.price), style: rubikBold),
                              ],
                            )),
                          ],
                        ),
                        Divider(height: 20),

                        // Rate
                        Text(
                          getTranslated('rate_the_food', context),
                          style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        SizedBox(
                          height: 30,
                          child: ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return InkWell(
                                child: Icon(
                                  _rating < (i + 1) ? Icons.star_border : Icons.star,
                                  size: 25,
                                  color: _rating < (i + 1)
                                      ? ColorResources.getGreyColor(context)
                                      : ColorResources.getPrimaryColor(context),
                                ),
                                onTap: () {

                                  setState(() {
                                    _rating=i+1.toDouble();
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Text(
                          getTranslated('share_your_opinion', context),
                          style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        CustomTextField(
                          maxLines: 3,
                          capitalization: TextCapitalization.sentences,
                          // isEnabled: !productProvider.submitList[index],
                          hintText: getTranslated('write_your_review_here', context),
                          fillColor: ColorResources.getSearchBg(context),
                          controller: _textEditingController,
                        ),
                        SizedBox(height: 20),

                        // Submit button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                          child: Column(
                            children: [
                              !productProvider.isLoading ? CustomButton(
                                  btnTxt: getTranslated('submit', context),
                                  backgroundColor:  Theme.of(context).primaryColor,
                                  onTap: () {
                                    if (_rating==0) {
                                      showCustomSnackBar('Give a rating', context);
                                    } else if (_textEditingController.text.isEmpty) {
                                      showCustomSnackBar('Write a review', context);
                                    } else {
                                      ReviewBody reviewBody = ReviewBody(
                                        productId: product.id.toString(),
                                        rating: _rating
                                            .toString(),
                                        comment: _textEditingController.text,
                                      );
                                      productProvider.submitProductReview(reviewBody)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          showCustomSnackBar(
                                              value.message, context, isError: false);
                                        } else {
                                          showCustomSnackBar(value.message, context);
                                        }
                                      });
                                    }
                                  }) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if(snapshot.connectionState==ConnectionState.done && !snapshot.hasData){
            return Container(child: Text("Product Not Found"),);
          } else{
            return Center(child: CircularProgressIndicator());
          }

        }
      ),
    );
  }
}
