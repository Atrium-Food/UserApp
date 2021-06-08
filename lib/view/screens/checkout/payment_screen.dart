import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/cancel_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  final bool fromCheckout;
  PaymentScreen({@required this.orderModel, @required this.fromCheckout});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _razorpay = Razorpay();
  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController controllerGlobal;

  @override
  void initState() {
    super.initState();
    selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_cOeiHxMt0M01OQ ',
      'amount': 2,
      'name': 'abc',
      'description': 'Payment',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }


   /* @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(title: getTranslated('PAYMENT', context), onBackPressed: () => _exitApp(context)),
        body: Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: selectedUrl,
              gestureNavigationEnabled: true,
              userAgent: 'Mozilla/5.0 (Linux; Android 4.4.4; One Build/KTU84L.H4) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/28.0.0.20.16;]',
              onWebViewCreated: (WebViewController webViewController) {
                _controller.future.then((value) => controllerGlobal = value);
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
                setState(() {
                  _isLoading = true;
                });
                if(url == '${AppConstants.BASE_URL}/payment-success'){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderSuccessfulScreen(
                    orderID: widget.orderModel.id.toString(), status: 0, addressID: widget.orderModel.deliveryAddressId,
                  )));
                }else if(url == '${AppConstants.BASE_URL}/payment-fail') {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderSuccessfulScreen(
                    orderID: widget.orderModel.id.toString(), status: 1, addressID: widget.orderModel.deliveryAddressId,
                  )));
                }else if(url == '${AppConstants.BASE_URL}/payment-cancel') {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderSuccessfulScreen(
                    orderID: widget.orderModel.id.toString(), status: 2, addressID: widget.orderModel.deliveryAddressId,
                  )));
                }
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                setState(() {
                  _isLoading = false;
                });
              },
            ),

            _isLoading ? Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      return showDialog(context: context, builder: (context) => CancelDialog(orderModel: widget.orderModel, fromCheckout: widget.fromCheckout));
    }
  } */
  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text('Cart',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF545D68))),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                      Icons.notifications_none, color: Color(0xFFF17532)),
                  onPressed: () {},
                ),
              ],
            ),

            body: ListView(
                children: [
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          SizedBox(height: 15.0),
                          Hero(
                              tag: 'assets/browniecookies.jpg',
                              child: Image.asset('assets/browniecookies.jpg',
                                  height: 90.0,
                                  width: 90.0,
                                  fit: BoxFit.contain
                              )
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            children: <Widget>[
                              Text('\$3.99',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF17532))),
                              SizedBox(height: 10.0),
                              Text('brownie cookies',
                                  style: TextStyle(
                                      color: Color(0xFF575E67),
                                      fontSize: 24.0)),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0),
                  InkWell(
                      onTap: () {
                        openCheckout();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 18),
                        child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(25.0),
                                color: Color(0xFFF17532)),
                            child: Center(
                                child: Text('Checkout',
                                    style: TextStyle(
                                        fontFamily: 'nunito',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)))),
                      ))

                ]
            ),


          );
        }
}

