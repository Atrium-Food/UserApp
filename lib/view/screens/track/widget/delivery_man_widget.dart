import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryManWidget extends StatelessWidget {
  final DeliveryMan deliveryMan;
  DeliveryManWidget({@required this.deliveryMan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
          blurRadius: 5, spreadRadius: 1,
        )],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(getTranslated('delivery_man', context), style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
        ListTile(
          leading: ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder_user,
              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.deliveryManImageUrl}/${deliveryMan.image}',
              height: 40, width: 40, fit: BoxFit.cover,
              imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                return Image.asset(Images.placeholder_image,
                  height: 40, width: 40, fit: BoxFit.cover,
                );
              },
            ),
          ),
          title: Text(
            '${deliveryMan.fName} ${deliveryMan.lName}',
            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),
          subtitle: RatingBar(rating: deliveryMan.rating.length > 0 ? double.parse(deliveryMan.rating[0].average) : 0, size: 15),
          trailing: InkWell(
            onTap: () => launch('tel:${deliveryMan.phone}'),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(shape: BoxShape.circle, color: ColorResources.getSearchBg(context)),
              child: Icon(Icons.call_outlined),
            ),
          ),
        ),
      ]),
    );
  }
}
