import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/cancel_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  final bool fromCheckout;
  PaymentScreen({@required this.orderModel, @required this.fromCheckout});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;

  InAppWebViewController _webViewController;
  InAppWebViewController _webViewPopupController;

  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  // WebViewController controllerGlobal;

  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //     crossPlatform: InAppWebViewOptions(
  //       useShouldOverrideUrlLoading: true,
  //       mediaPlaybackRequiresUserGesture: false,
  //     ),
  //     android: AndroidInAppWebViewOptions(
  //       useHybridComposition: true,
  //     ),
  //     ios: IOSInAppWebViewOptions(
  //       allowsInlineMediaPlayback: true,
  //     ));
  @override
  void initState() {
    super.initState();
    // selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';

    selectedUrl =
        '${AppConstants.BASE_URL}/paywithrazorpay/${widget.orderModel.id}';

    print(selectedUrl);
    if (Platform.isAndroid) wv.WebView.platform = wv.SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(
            title: getTranslated('PAYMENT', context),
            onBackPressed: () => _exitApp(context)),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(selectedUrl)),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      javaScriptCanOpenWindowsAutomatically: true),
                  android: AndroidInAppWebViewOptions(
                      supportMultipleWindows: true,
                      useHybridComposition: true)),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
                _webViewController.loadUrl(
                    urlRequest: URLRequest(url: Uri.parse(selectedUrl)));
              },
              onLoadStart: (InAppWebViewController controller, Uri uri) {
                String url = uri.toString();
                print('Page started loading: $url');

                setState(() {
                  _isLoading = false;
                });
                if (url == '${AppConstants.BASE_URL}/payment-success') {
                  print(url);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrderSuccessfulScreen(
                                orderID: widget.orderModel.id.toString(),
                                status: 0,
                                addressID: widget.orderModel.deliveryAddressId,
                              )));
                } else if (url == '${AppConstants.BASE_URL}/payment-fail') {
                  print(url);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrderSuccessfulScreen(
                                orderID: widget.orderModel.id.toString(),
                                status: 1,
                                addressID: widget.orderModel.deliveryAddressId,
                              )));
                } else if (url == '${AppConstants.BASE_URL}/payment-cancel') {
                  print(url);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrderSuccessfulScreen(
                                orderID: widget.orderModel.id.toString(),
                                status: 2,
                                addressID: widget.orderModel.deliveryAddressId,
                              )));
                } else if (uri
                        .toString()
                        .startsWith("https://api.razorpay.com/v1/payments/") &&
                    uri.toString().contains("?status=")) {
                  if (uri.queryParameters["status"] == "failed")
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OrderSuccessfulScreen(
                                  orderID: widget.orderModel.id.toString(),
                                  status: 1,
                                  addressID:
                                      widget.orderModel.deliveryAddressId,
                                )));
                }
              },
              onCreateWindow: (controller, createWindowRequest) async {
                print("onCreateWindow");
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                        child: InAppWebView(
                          // Setting the windowId property is important here!
                          windowId: createWindowRequest.windowId,
                          initialOptions: InAppWebViewGroupOptions(
                              crossPlatform: InAppWebViewOptions(
                                  useShouldOverrideUrlLoading: true,
                                  javaScriptCanOpenWindowsAutomatically: true),
                              android: AndroidInAppWebViewOptions(
                                  supportMultipleWindows: true,
                                  useHybridComposition: true)),
                          onWebViewCreated:
                              (InAppWebViewController controller) {
                            _webViewPopupController = controller;
                          },
                          onLoadStart:
                              (InAppWebViewController controller, Uri uri) {
                            print("onLoadStart popup ${uri.toString()}");
                            if (uri.toString().startsWith(
                                    "https://api.razorpay.com/v1/payments/") &&
                                uri.toString().contains("?status=")) {
                              if (uri.queryParameters["status"] == "failed")
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => OrderSuccessfulScreen(
                                              orderID: widget.orderModel.id
                                                  .toString(),
                                              status: 1,
                                              addressID: widget
                                                  .orderModel.deliveryAddressId,
                                            )));
                            }
                          },
                          onLoadStop:
                              (InAppWebViewController controller, Uri uri) {
                            print("onLoadStop popup ${uri.toString()}");
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );
                return true;
              },
            ),
            // WebView(
            //   javascriptMode: JavascriptMode.unrestricted,
            //   initialUrl: selectedUrl,
            //   gestureNavigationEnabled: true,
            //
            //   // navigationDelegate: (navigation) {
            //   //   navigation.
            //   // },
            //   userAgent:
            //       'Mozilla/5.0 (Linux; Android 4.4.4; One Build/KTU84L.H4) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/28.0.0.20.16;]',
            //   onWebViewCreated: (WebViewController webViewController) {
            //     _controller.future.then((value) => controllerGlobal = value);
            //     _controller.complete(webViewController);
            //   },
            //   onPageStarted: (String url) {
            //     print('Page started loading: $url');
            //     setState(() {
            //       _isLoading = true;
            //     });
            //     if (url == '${AppConstants.BASE_URL}/payment-success') {
            //       print(url);
            //       Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => OrderSuccessfulScreen(
            //                     orderID: widget.orderModel.id.toString(),
            //                     status: 0,
            //                     addressID: widget.orderModel.deliveryAddressId,
            //                   )));
            //     } else if (url == '${AppConstants.BASE_URL}/payment-fail') {
            //       print(url);
            //       Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => OrderSuccessfulScreen(
            //                     orderID: widget.orderModel.id.toString(),
            //                     status: 1,
            //                     addressID: widget.orderModel.deliveryAddressId,
            //                   )));
            //     } else if (url == '${AppConstants.BASE_URL}/payment-cancel') {
            //       print(url);
            //       Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => OrderSuccessfulScreen(
            //                     orderID: widget.orderModel.id.toString(),
            //                     status: 2,
            //                     addressID: widget.orderModel.deliveryAddressId,
            //                   )));
            //     }
            //   },
            //   onPageFinished: (String url) {
            //     print('Page finished loading: $url');
            //     // controllerGlobal.getTitle().then((value){
            //     //   if(value == "Razorpay - Payment in progress"){
            //     //     controllerGlobal.loadUrl(selectedUrl);
            //     //   }
            //     // });
            //     setState(() {
            //       _isLoading = false;
            //     });
            //     // if()
            //
            //   },
            // ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
      return Future.value(false);
    } else {
      return showDialog(
          context: context,
          builder: (context) => CancelDialog(
              orderModel: widget.orderModel,
              fromCheckout: widget.fromCheckout));
    }
  }
}
