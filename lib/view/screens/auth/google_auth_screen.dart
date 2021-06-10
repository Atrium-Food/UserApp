import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/cancel_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleAuthScreen extends StatefulWidget {

  @override
  _GoogleAuthScreenState createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  WebViewController controllerGlobal;

  @override
  void initState() {
    super.initState();
    // selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';
    selectedUrl = 'http://3.108.112.158/auth/redirect';

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(
            title: getTranslated('Google Sign In', context),
            onBackPressed: () => _exitApp(context)),
        body: Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: selectedUrl,
              gestureNavigationEnabled: true,
              // userAgent:
              // ('Mozilla/5.0 (Linux; Android 4.4.4; One Build/KTU84L.H4) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/28.0.0.20.16;]').replaceAll("; wv",""),
              userAgent: 'Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36',
              onWebViewCreated: (WebViewController webViewController) {
                _controller.future.then((value) => controllerGlobal = value);
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
                setState(() {
                  _isLoading = true;
                });
                if(url.startsWith('http://localhost:8000/auth/google/callback')){
                  print("Found the page");
                  RegExp regExp = new RegExp("#access_token=(.*)");
                  String token = regExp.firstMatch(url)?.group(1);
                  print("token $token");
                }
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                setState(() {
                  _isLoading = false;
                });
              },
            ),
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
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
        Navigator.pop(context);
    }
  }
}
