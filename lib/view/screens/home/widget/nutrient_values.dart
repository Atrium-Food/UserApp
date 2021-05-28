import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

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
            style: rubikMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: ColorResources.getAccentColor(context)),
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
      body: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'serving/',
                    style: TextStyle(
                      fontSize: 10,
                      color: ColorResources.getGreyColor(context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Energy',
                    style: rubikMedium,
                  ),
                  Text(
                    '1883 KJ',
                    style: rubikMedium,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
