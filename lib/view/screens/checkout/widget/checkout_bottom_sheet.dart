import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/notification/my_notification.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/address/add_location_screen.dart';
import 'package:flutter_restaurant/view/screens/address/add_new_address_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/payment_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/custom_check_box.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/razor_payment.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckoutBottomSheet extends StatefulWidget {
  final List<CartModel> cartList;
  final double amount;
  final String orderType;
  CheckoutBottomSheet(
      {@required this.cartList,
      @required this.amount,
      @required this.orderType});

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  GoogleMapController _mapController;
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  List<Branches> _branches = [];
  bool _loading = true;
  Set<Marker> _markers = HashSet<Marker>();
  bool _isLoggedIn;
  bool _isAddressExpanded = false;
  String _errorMessage = '';
  String _email = '';
  String _phone = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = Provider.of<ProfileProvider>(context, listen: false)
        .userInfoModel
        .email;
    _phone = Provider.of<ProfileProvider>(context, listen: false)
        .userInfoModel
        .phone;
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      _branches = Provider.of<SplashProvider>(context, listen: false)
          .configModel
          .branches;
      Provider.of<LocationProvider>(context, listen: false)
          .initAddressList(context);
      // Provider.of<LocationProvider>(context, listen: false)
      //     .initAddressList(context);
      // Provider.of<OrderProvider>(context, listen: false).clearPrevData();
      _isCashOnDeliveryActive =
          Provider.of<SplashProvider>(context, listen: false)
                  .configModel
                  .cashOnDelivery ==
              'true';
      _isDigitalPaymentActive =
          Provider.of<SplashProvider>(context, listen: false)
                  .configModel
                  .digitalPayment ==
              'true';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: ColorResources.getBackgroundColor(context),
        ),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Consumer<OrderProvider>(builder: (context, order, child) {
          return Consumer<LocationProvider>(builder: (context, address, child) {
            return ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text(
                    "Delivery Address",
                    style: robotoRegular.copyWith(
                        color: ColorResources.getAccentColor(context)),
                  ),
                  subtitle: order.addressIndex != -1
                      ? Text(
                    address.addressList[order.addressIndex].address,
                    style: robotoRegular.copyWith(
                        fontWeight: FontWeight.w400),
                  )
                      : Text(""),
                ),
                if(order.addressIndex == -1)
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: Row(children: [
                          TextButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AddLocationScreen(
                                        fromCheckout: true))),
                            icon: Icon(Icons.add),
                            label:
                                Text('Add address', style: robotoRegular),
                          ),
                        ]),
                      ),
                // widget.orderType != 'take_away' ?
                // ExpansionTile(
                //   title: Text(
                //     "Select Delivery Address",
                //     style: robotoRegular.copyWith(
                //         color: ColorResources.getAccentColor(context)),
                //   ),
                //   subtitle: order.addressIndex != -1
                //       ? Text(
                //           address.addressList[order.addressIndex].address,
                //           style: robotoRegular.copyWith(
                //               fontWeight: FontWeight.w400),
                //         )
                //       : Text(""),
                //   onExpansionChanged: (value) {
                //     setState(() {
                //       _isAddressExpanded = value;
                //     });
                //   },
                //   tilePadding: EdgeInsets.zero,
                //   textColor: ColorResources.getAccentColor(context),
                //   iconColor: ColorResources.getAccentColor(context),
                  // children: [
                  //   widget.orderType != 'take_away'
                  //       ? Column(mainAxisSize: MainAxisSize.min, children: [
                  //           SizedBox(
                  //             // height: 100,
                  //             child: address.addressList != null
                  //                 ? address.addressList.length > 0
                  //                     ? ConstrainedBox(
                  //                         constraints: BoxConstraints(
                  //                             maxHeight: MediaQuery.of(context)
                  //                                     .size
                  //                                     .height *
                  //                                 0.4,
                  //                             minHeight: MediaQuery.of(context)
                  //                                     .size
                  //                                     .height *
                  //                                 0.05),
                  //                         child: ListView.separated(
                  //                           // physics: BouncingScrollPhysics(),
                  //                           scrollDirection: Axis.vertical,
                  //                           separatorBuilder: (context, index) {
                  //                             return Padding(
                  //                               padding: EdgeInsets.all(4),
                  //                             );
                  //                           },
                  //                           shrinkWrap: true,
                  //                           padding: EdgeInsets.only(
                  //                               left: Dimensions
                  //                                   .PADDING_SIZE_SMALL),
                  //                           itemCount:
                  //                               address.addressList.length,
                  //                           itemBuilder: (context, index) {
                  //                             // bool _isAvailable = _branches
                  //                             //             .length ==
                  //                             //         1 &&
                  //                             //     (_branches[0].latitude ==
                  //                             //             null ||
                  //                             //         _branches[0]
                  //                             //             .latitude
                  //                             //             .isEmpty);
                  //                             // if (!_isAvailable) {
                  //                             //   double _distance = Geolocator
                  //                             //           .distanceBetween(
                  //                             //         double.parse(
                  //                             //             _branches[order
                  //                             //                     .branchIndex]
                  //                             //                 .latitude),
                  //                             //         double.parse(
                  //                             //             _branches[order
                  //                             //                     .branchIndex]
                  //                             //                 .longitude),
                  //                             //         double.parse(address
                  //                             //             .addressList[
                  //                             //                 index]
                  //                             //             .latitude),
                  //                             //         double.parse(address
                  //                             //             .addressList[
                  //                             //                 index]
                  //                             //             .longitude),
                  //                             //       ) /
                  //                             //       1000;
                  //                             //   _isAvailable = _distance <
                  //                             //       _branches[order
                  //                             //               .branchIndex]
                  //                             //           .coverage;
                  //                             // }
                  //                             return InkWell(
                  //                               onTap: () {
                  //                                 // if (_isAvailable) {
                  //                                 print(order.addressIndex);
                  //                                 order.setAddressIndex(index);
                  //                                 // }
                  //                               },
                  //                               child: Stack(children: [
                  //                                 Container(
                  //                                   height: 60,
                  //                                   // width: 200,
                  //                                   margin: EdgeInsets.only(
                  //                                       right: Dimensions
                  //                                           .PADDING_SIZE_LARGE),
                  //                                   decoration: BoxDecoration(
                  //                                     color: index ==
                  //                                             order.addressIndex
                  //                                         ? Theme.of(context)
                  //                                             .accentColor
                  //                                         : ColorResources
                  //                                             .getBackgroundColor(
                  //                                                 context),
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             10),
                  //                                     border: index ==
                  //                                             order.addressIndex
                  //                                         ? Border.all(
                  //                                             color: ColorResources
                  //                                                 .getPrimaryColor(
                  //                                                     context),
                  //                                             width: 2)
                  //                                         : null,
                  //                                   ),
                  //                                   child: Row(children: [
                  //                                     Padding(
                  //                                       padding: EdgeInsets.symmetric(
                  //                                           horizontal: Dimensions
                  //                                               .PADDING_SIZE_EXTRA_SMALL),
                  //                                       child: Column(
                  //                                         crossAxisAlignment:
                  //                                             CrossAxisAlignment
                  //                                                 .start,
                  //                                         children: [
                  //                                           Icon(
                  //                                             address
                  //                                                         .addressList[
                  //                                                             index]
                  //                                                         .addressType ==
                  //                                                     'Home'
                  //                                                 ? Icons
                  //                                                     .home_outlined
                  //                                                 : address.addressList[index].addressType ==
                  //                                                         'Workplace'
                  //                                                     ? Icons
                  //                                                         .work_outline
                  //                                                     : Icons
                  //                                                         .list_alt_outlined,
                  //                                             color: index ==
                  //                                                     order
                  //                                                         .addressIndex
                  //                                                 ? ColorResources
                  //                                                     .getPrimaryColor(
                  //                                                         context)
                  //                                                 : Theme.of(
                  //                                                         context)
                  //                                                     .textTheme
                  //                                                     .bodyText1
                  //                                                     .color,
                  //                                             size: 30,
                  //                                           ),
                  //                                           Text(
                  //                                               address
                  //                                                   .addressList[
                  //                                                       index]
                  //                                                   .addressType,
                  //                                               style:
                  //                                                   robotoRegular
                  //                                                       .copyWith(
                  //                                                 fontSize:
                  //                                                     Dimensions
                  //                                                         .FONT_SIZE_SMALL,
                  //                                                 color: ColorResources
                  //                                                     .getGreyBunkerColor(
                  //                                                         context),
                  //                                               )),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                         padding: EdgeInsets
                  //                                             .all(Dimensions
                  //                                                 .PADDING_SIZE_EXTRA_SMALL)),
                  //                                     Expanded(
                  //                                       child: Text(
                  //                                         address
                  //                                             .addressList[
                  //                                                 index]
                  //                                             .address,
                  //                                         style: robotoRegular,
                  //                                         softWrap: true,
                  //                                         overflow:
                  //                                             TextOverflow.fade,
                  //                                       ),
                  //                                     ),
                  //                                     Spacer(),
                  //                                     PopupMenuButton(
                  //                                         icon: Icon(Icons
                  //                                             .more_vert_rounded),
                  //                                         onSelected: (val) {
                  //                                           if (val == 'edit') {
                  //                                             Navigator.push(
                  //                                                 context,
                  //                                                 MaterialPageRoute(
                  //                                                     builder: (context) =>
                  //                                                         AddLocationScreen(
                  //                                                           address:
                  //                                                               address.addressList[index],
                  //                                                           fromCheckout:
                  //                                                               true,
                  //                                                           isEnableUpdate:
                  //                                                               true,
                  //                                                         )));
                  //                                           } else if (val ==
                  //                                               'delete') {
                  //                                             Provider.of<LocationProvider>(
                  //                                                     context,
                  //                                                     listen:
                  //                                                         false)
                  //                                                 .deleteUserAddressByID(
                  //                                                     address
                  //                                                         .addressList[
                  //                                                             index]
                  //                                                         .id,
                  //                                                     index,
                  //                                                     (bool isSuccessful,
                  //                                                         String
                  //                                                             message) {
                  //                                               // showCustomSnackBar(message, context, isError: !isSuccessful);
                  //                                               setState(() {
                  //                                                 _errorMessage =
                  //                                                     message;
                  //                                               });
                  //                                             });
                  //                                           }
                  //                                         },
                  //                                         itemBuilder:
                  //                                             (context) {
                  //                                           List<PopupMenuEntry>
                  //                                               items = [];
                  //                                           items.add(
                  //                                               PopupMenuItem(
                  //                                                   value:
                  //                                                       'edit',
                  //                                                   child: Text(
                  //                                                       "Edit")));
                  //                                           items.add(PopupMenuItem(
                  //                                               value: 'delete',
                  //                                               child: Text(
                  //                                                   "Delete")));
                  //                                           return items;
                  //                                         }),
                  //                                     // IconButton(
                  //                                     //     onPressed: (){
                  //                                     //
                  //                                     //     },
                  //                                     //     icon: Icon(Icons.more_vert_rounded))
                  //                                   ]),
                  //                                 ),
                  //                                 // !_isAvailable?
                  //                                 // Positioned(
                  //                                 //         top: 0,
                  //                                 //         left: 0,
                  //                                 //         bottom: 0,
                  //                                 //         right: 20,
                  //                                 //         child: Container(
                  //                                 //           alignment:
                  //                                 //               Alignment
                  //                                 //                   .center,
                  //                                 //           decoration: BoxDecoration(
                  //                                 //               borderRadius:
                  //                                 //                   BorderRadius.circular(
                  //                                 //                       10),
                  //                                 //               color: Colors
                  //                                 //                   .black
                  //                                 //                   .withOpacity(
                  //                                 //                       0.6)),
                  //                                 //           child: Text(
                  //                                 //             getTranslated(
                  //                                 //                 'out_of_coverage_for_this_branch',
                  //                                 //                 context),
                  //                                 //             textAlign:
                  //                                 //                 TextAlign
                  //                                 //                     .center,
                  //                                 //             maxLines: 2,
                  //                                 //             overflow:
                  //                                 //                 TextOverflow
                  //                                 //                     .ellipsis,
                  //                                 //             style: robotoRegular.copyWith(
                  //                                 //                 color: Colors
                  //                                 //                     .white,
                  //                                 //                 fontSize:
                  //                                 //                     10),
                  //                                 //           ),
                  //                                 //         ),
                  //                                 //       )
                  //                                 // : SizedBox(),
                  //                               ]),
                  //                             );
                  //                           },
                  //                         ),
                  //                       )
                  //                     : Center(
                  //                         child: Text(getTranslated(
                  //                             'no_address_available', context)))
                  //                 : Center(
                  //                 child: Text("Addresses not initialized")),
                  //           ),
                  //           Padding(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: Dimensions.PADDING_SIZE_SMALL),
                  //             child: Row(children: [
                  //               TextButton.icon(
                  //                 onPressed: () => Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (_) => AddLocationScreen(
                  //                             fromCheckout: true))),
                  //                 icon: Icon(Icons.add),
                  //                 label:
                  //                     Text('Add address', style: robotoRegular),
                  //               ),
                  //             ]),
                  //           ),
                  //           SizedBox(height: 20),
                  //         ])
                  //       : SizedBox(),
                  // ],
                // ),
                // : Text("Take Away"),
                // Divider(
                //   color: ColorResources.getAccentColor(context),
                //   thickness: 0.3,
                // ),
                // RichText(
                //     text: TextSpan(children: [
                //   TextSpan(
                //       text: "Expected Delivery Time: ",
                //       style: robotoRegular.copyWith(
                //           fontSize: Dimensions.FONT_SIZE_LARGE,
                //           color: ColorResources.getAccentColor(context))),
                //   TextSpan(
                //       text: "25 minutes",
                //       style: robotoMedium.copyWith(
                //           fontSize: Dimensions.FONT_SIZE_LARGE,
                //           color: ColorResources.getAccentColor(context)))
                // ])),
                Divider(
                  color: ColorResources.getAccentColor(context),
                  thickness: 0.3,
                ),
                Container(
                  child: Consumer<ProfileProvider>(
                      builder: (context, profile, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Details',
                              style: robotoRegular.copyWith(
                                  fontWeight: FontWeight.w100,
                                  fontSize: Dimensions.FONT_SIZE_LARGE),
                            ),
                            order.addressIndex != -1
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: address
                                                .addressList[order.addressIndex]
                                                .contactPersonName
                                                .trim(),
                                            style: robotoRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_DEFAULT,
                                                color: ColorResources
                                                    .getAccentColor(context))),
                                        TextSpan(
                                            text: ", " +
                                                address
                                                    .addressList[
                                                        order.addressIndex]
                                                    .contactPersonNumber,
                                            style: robotoRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_DEFAULT,
                                                color: ColorResources
                                                    .getAccentColor(context))),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                      ],
                    );
                  }),
                ),
                Divider(
                  color: ColorResources.getAccentColor(context),
                  thickness: 0.5,
                ),
                _isCashOnDeliveryActive
                    ? CustomCheckBox(
                        title: getTranslated('cash_on_delivery', context),
                        index: 0)
                    : SizedBox(),
                _isDigitalPaymentActive
                    ? CustomCheckBox(
                        title: getTranslated('digital_payment', context),
                        index: _isCashOnDeliveryActive ? 1 : 0)
                    : SizedBox(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _errorMessage.length > 0
                        ? CircleAvatar(
                            backgroundColor:
                                ColorResources.getPrimaryColor(context),
                            radius: 5)
                        : SizedBox.shrink(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage ?? "",
                        style: Theme.of(context).textTheme.headline2.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: ColorResources.getPrimaryColor(context),
                            height: 1),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: !order.isLoading
                      ? Builder(
                          builder: (context) => CustomButton(
                              btnTxt: getTranslated('confirm_order', context),
                              onTap: () {
                                print("Tap Confirm Order");
                                if (widget.amount <
                                    Provider.of<SplashProvider>(context,
                                            listen: false)
                                        .configModel
                                        .minimumOrderValue) {
                                  setState(() {
                                    _errorMessage =
                                        'Minimum order amount is ${Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue}';
                                  });
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(SnackBar(
                                  //         content: Text(
                                  //           'Minimum order amount is ${Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue}',
                                  //         ),
                                  //         backgroundColor: Colors.red));
                                } else if (widget.orderType != 'take_away' &&
                                    (address.addressList == null ||
                                        address.addressList.length == 0 ||
                                        order.addressIndex < 0)) {
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(SnackBar(
                                  //   content: Text(getTranslated(
                                  //       'select_an_address', context)),
                                  //   backgroundColor: Colors.red,
                                  //   behavior: SnackBarBehavior.floating,
                                  // ));
                                  setState(() {
                                    _errorMessage = 'Select an address';
                                  });
                                } else {
                                  List<Cart> carts = [];
                                  for (int index = 0;
                                      index < widget.cartList.length;
                                      index++) {
                                    CartModel cart = widget.cartList[index];
                                    List<int> _addOnIdList = [];
                                    List<int> _addOnQtyList = [];
                                    cart.addOnIds.forEach((addOn) {
                                      _addOnIdList.add(addOn.id);
                                      _addOnQtyList.add(addOn.quantity);
                                    });
                                    carts.add(Cart(
                                      cart.product.id.toString(),
                                      cart.discountedPrice.toString(),
                                      '',
                                      cart.variation,
                                      cart.discountAmount,
                                      cart.quantity,
                                      cart.taxAmount,
                                      _addOnIdList,
                                      _addOnQtyList,
                                    ));
                                  }
                                  order.placeOrder(
                                    PlaceOrderBody(
                                      cart: carts,
                                      couponDiscountAmount:
                                          Provider.of<CouponProvider>(context,
                                                  listen: false)
                                              .discount,
                                      couponDiscountTitle: '',
                                      deliveryAddressId: widget.orderType !=
                                              'take_away'
                                          ? Provider.of<LocationProvider>(
                                                  context,
                                                  listen: false)
                                              .addressList[order.addressIndex]
                                              .id
                                          : 0,
                                      orderAmount: widget.amount,
                                      orderNote: _noteController.text ?? '',
                                      orderType: widget.orderType,
                                      paymentMethod: _isCashOnDeliveryActive
                                          ? order.paymentMethodIndex == 0
                                              ? 'cash_on_delivery'
                                              : null
                                          : null,
                                      couponCode: Provider.of<CouponProvider>(
                                                      context,
                                                      listen: false)
                                                  .coupon !=
                                              null
                                          ? Provider.of<CouponProvider>(context,
                                                  listen: false)
                                              .coupon
                                              .code
                                          : null,
                                      branchId: _branches[order.branchIndex].id,
                                    ),
                                    _callback,
                                  );
                                }
                              }),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor))),
                ),
              ],
            );
          });
        }));
  }

  void _callback(
      bool isSuccess, String message, String orderID, int addressID) async {
    if (isSuccess) {
      Provider.of<CartProvider>(context, listen: false).clearCartList();
      Provider.of<OrderProvider>(context, listen: false).stopLoader();

      MyNotification.scheduleNotification(
          flutterLocalNotificationsPlugin, "id", 'Title', "body", orderID);
      if (_isCashOnDeliveryActive &&
          Provider.of<OrderProvider>(context, listen: false)
                  .paymentMethodIndex ==
              0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => OrderSuccessfulScreen(
                    orderID: orderID, status: 0, addressID: addressID)));
      } else {
        OrderModel _orderModel = OrderModel(
          paymentMethod: '',
          id: int.parse(orderID),
          userId: Provider.of<ProfileProvider>(context, listen: false)
              .userInfoModel
              .id,
          couponDiscountAmount:
              Provider.of<CouponProvider>(context, listen: false).discount,
          createdAt: DateConverter.localDateToIsoString(DateTime.now()),
          updatedAt: DateConverter.localDateToIsoString(DateTime.now()),
          orderStatus: 'pending',
          paymentStatus: 'unpaid',
        );
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PaymentScreen(orderModel: _orderModel, fromCheckout: true)));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    PaymentScreen(orderModel: _orderModel, fromCheckout: true)
                    // RazorPayment(
                    //   amount: widget.amount,
                    //   orderModel: _orderModel,
                    //   userInfoModel:
                    //       Provider.of<ProfileProvider>(context, listen: false)
                    //           .userInfoModel,
                    // )
            ));
      }
    } else {
      // _scaffoldKey.currentState.showSnackBar(
      //     SnackBar(content: Text(message), backgroundColor: Colors.red));
      setState(() {
        _errorMessage = message;
      });
    }
  }
}
