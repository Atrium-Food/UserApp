import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../order_successful_screen.dart';

class RazorPayment extends StatefulWidget {
  final double amount;
  final UserInfoModel userInfoModel;
  final OrderModel orderModel;
  const RazorPayment({
    @required this.orderModel,
    @required this.amount,
    @required this.userInfoModel,
  });

  @override
  _RazorPaymentState createState() => _RazorPaymentState();
}

class _RazorPaymentState extends State<RazorPayment> {
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = new Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handelPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handelPaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handelExternalWallet);

    _razorpay.on(Razorpay.PAYMENT_CANCELLED.toString(), handelPaymentCancelled);

    openCheckout();
  }

  @override
  void dispose() {
    super.dispose();

    _razorpay.clear();
  }

  void openCheckout() {
    var options = {
      'key': AppConstants.RAZORPAY_TEST_KEY,
      'amount': widget.amount * 100,
      'name': '${widget.userInfoModel.fName} ${widget.userInfoModel.lName}',
      'description': 'Deposit',
      'prefill': {
        'contact': widget.userInfoModel.phone,
        'email': widget.userInfoModel.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handelPaymentSuccess(PaymentSuccessResponse response) {
    print('-------Payment Successful----------------- ${response.paymentId}');

    Provider.of<OrderProvider>(context, listen: false).updatePaymentStatus(
        widget.orderModel.id.toString(), 'paid', response.paymentId);

    // Provider.of<OrderProvider>(context, listen: false)
    //     .updatePaymentDemo(widget.orderModel.id.toString(), response.paymentId);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => OrderSuccessfulScreen(
                  orderID: widget.orderModel.id.toString(),
                  status: 0,
                  addressID: widget.orderModel.deliveryAddressId,
                )));
  }

  void handelPaymentError(PaymentFailureResponse response) {
    // Provider.of<OrderProvider>(context, listen: false)
    //     .updatePaymentStatus(widget.orderModel.toString(), 'unpaid', '00000');

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => OrderSuccessfulScreen(
                  orderID: widget.orderModel.id.toString(),
                  status: 1,
                  addressID: widget.orderModel.deliveryAddressId,
                )));
  }

  void handelPaymentCancelled() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => OrderSuccessfulScreen(
                  orderID: widget.orderModel.id.toString(),
                  status: 2,
                  addressID: widget.orderModel.deliveryAddressId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
