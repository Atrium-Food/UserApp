import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/screens/address/widget/address_widget.dart';
import 'package:flutter_restaurant/view/screens/address/widget/permission_dialog.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/menu_app_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'add_new_address_screen.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    }

    return Scaffold(
      appBar: MenuAppBar(),
      // floatingActionButton: _isLoggedIn ? FloatingActionButton(
      //   child: Icon(Icons.add, color: Colors.white),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   onPressed: () => _checkPermission(context, AddNewAddressScreen()),
      // ) : null,
      backgroundColor: ColorResources.getThemeColor(context),
      bottomNavigationBar: _isLoggedIn? Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(
          btnTxt: 'Add Address',
          onTap: (){
            _checkPermission(context, AddNewAddressScreen());
          },
        ),
      ):null,
      body: _isLoggedIn ? Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return locationProvider.addressList != null ? locationProvider.addressList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Text('Saved Addresses', style: rubikRegular.copyWith(fontSize: 25,color: ColorResources.getAccentColor(context)),),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    itemCount: locationProvider.addressList.length,
                    itemBuilder: (context, index) => AddressWidget(
                      addressModel: locationProvider.addressList[index],
                      index: index,
                    ),
                  ),
                ),
              ],
            ),
          ) : NoDataScreen()
              : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }

  void _checkPermission(BuildContext context, Widget navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar(getTranslated('you_have_to_allow', context), context);
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
    }else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => navigateTo));
    }
  }

}
