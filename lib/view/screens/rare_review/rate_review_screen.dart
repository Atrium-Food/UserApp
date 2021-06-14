
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/screens/rare_review/widget/deliver_man_review_widget.dart';
import 'package:flutter_restaurant/view/screens/rare_review/widget/product_review_widget.dart';
import 'package:provider/provider.dart';

class RateReviewScreen extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  final DeliveryMan deliveryMan;
  RateReviewScreen({@required this.orderDetailsList, @required this.deliveryMan});

  @override
  _RateReviewScreenState createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> with TickerProviderStateMixin {
  TabController _tabController;

  GlobalKey<ScaffoldMessengerState>  _scaffoldKey;
  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    _tabController = TabController(length: widget.deliveryMan == null ? 1 : 2, initialIndex: 0, vsync: this);
    Provider.of<ProductProvider>(context, listen: false).initRatingData(widget.orderDetailsList);
    print(widget.orderDetailsList.length);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // if(widget.fromNotifs)
    // Provider.of<SplashProvider>(context).initConfig(_scaffoldKey);
  }
  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).initConfig(_scaffoldKey);
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('rate_review', context)),
      body: Column(children: [
        Container(
          color: Theme.of(context).accentColor,
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).textTheme.bodyText1.color,
            indicatorColor: ColorResources.COLOR_PRIMARY,
            indicatorWeight: 3,
            unselectedLabelStyle: robotoRegular.copyWith(color: ColorResources.COLOR_HINT, fontSize: Dimensions.FONT_SIZE_SMALL),
            labelStyle: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
            tabs: widget.deliveryMan != null ? [
              Tab(text: getTranslated(widget.orderDetailsList.length > 1 ? 'items' : 'item', context)),
              Tab(text: getTranslated('delivery_man', context)),
            ] : [
              Tab(text: getTranslated(widget.orderDetailsList.length > 1 ? 'items' : 'item', context)),
            ],
          ),
        ),

        Expanded(child: TabBarView(
          controller: _tabController,
          children: widget.deliveryMan != null ? [
            ProductReviewWidget(orderDetailsList: widget.orderDetailsList),
            DeliveryManReviewWidget(deliveryMan: widget.deliveryMan, orderID: widget.orderDetailsList[0].orderId.toString()),
          ] : [
            ProductReviewWidget(orderDetailsList: widget.orderDetailsList),
          ],
        )),

      ]),
    );
  }
}
