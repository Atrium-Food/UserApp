import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/address/add_location_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AddressBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false)
        .initAddressList(context);
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Consumer<LocationProvider>(builder: (context, address, child) {
            return Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
              child: Consumer<OrderProvider>(builder: (context, order, child) {
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Row(children: [
                      TextButton.icon(
                        onPressed: () async {
                          // Position _position =
                          //     await Provider.of<LocationProvider>(context,
                          //             listen: false)
                          //         .locateUser();
                          Provider.of<LocationProvider>(context, listen: false)
                              .getUserLocation(
                                  context: context,
                                  isReset: true,
                                  fromSheet: true);
                          if (address.addressSheetMessage.isEmpty) {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(Icons.gps_fixed),
                        label:
                            Text('Use current location', style: robotoRegular),
                      ),
                      Text(
                        address.addressSheetMessage,
                        style: robotoRegular.copyWith(
                            color: ColorResources.getPrimaryColor(context),
                            fontSize: 10),
                      )
                    ]),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                        minHeight: MediaQuery.of(context).size.height * 0.04),
                    child: address.addressList != null
                        ? address.addressList.length > 0
                            ? ListView.separated(
                                // physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.all(4),
                                  );
                                },
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_SMALL),
                                itemCount: address.addressList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      print(index);
                                      order.setAddressIndex(index);
                                      address.setAddress(index);
                                      print(address.addressList[index].address);
                                      Navigator.pop(context);
                                    },
                                    child: Stack(children: [
                                      Container(
                                        height: 60,
                                        // width: 200,
                                        margin: EdgeInsets.only(
                                            right:
                                                Dimensions.PADDING_SIZE_LARGE),
                                        decoration: BoxDecoration(
                                          color: index == order.addressIndex
                                              ? Theme.of(context).accentColor
                                              : ColorResources
                                                  .getBackgroundColor(context),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: index == order.addressIndex
                                              ? Border.all(
                                                  color: ColorResources
                                                      .getPrimaryColor(context),
                                                  width: 2)
                                              : null,
                                        ),
                                        child: Row(children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  address.addressList[index]
                                                              .addressType ==
                                                          'Home'
                                                      ? Icons.home_outlined
                                                      : address
                                                                  .addressList[
                                                                      index]
                                                                  .addressType ==
                                                              'Workplace'
                                                          ? Icons.work_outline
                                                          : Icons
                                                              .list_alt_outlined,
                                                  color: index ==
                                                          order.addressIndex
                                                      ? ColorResources
                                                          .getPrimaryColor(
                                                              context)
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .color,
                                                  size: 30,
                                                ),
                                                Text(
                                                    address.addressList[index]
                                                        .addressType,
                                                    style:
                                                        robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_SMALL,
                                                      color: ColorResources
                                                          .getGreyBunkerColor(
                                                              context),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL)),
                                          Expanded(
                                            child: Text(
                                                address
                                                    .addressList[index].address,
                                                style: robotoRegular,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Spacer(),
                                          PopupMenuButton(
                                              icon:
                                                  Icon(Icons.more_vert_rounded),
                                              onSelected: (val) {
                                                if (val == 'edit') {
                                                  print(
                                                      "Address: ${address.addressList[index].address}");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddLocationScreen(
                                                                address: address
                                                                        .addressList[
                                                                    index],
                                                                fromCheckout:
                                                                    false,
                                                                isEnableUpdate:
                                                                    true,
                                                              )));
                                                } else if (val == 'delete') {
                                                  Provider.of<LocationProvider>(
                                                          context,
                                                          listen: false)
                                                      .deleteUserAddressByID(
                                                          address
                                                              .addressList[
                                                                  index]
                                                              .id,
                                                          index,
                                                          (bool isSuccessful,
                                                              String message) {
                                                    // showCustomSnackBar(message, context, isError: !isSuccessful);
                                                  });
                                                  if (Provider.of<OrderProvider>(
                                                              context,
                                                              listen: false)
                                                          .addressIndex ==
                                                      index)
                                                    Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .resetAddressIndex(
                                                            index);
                                                }
                                              },
                                              itemBuilder: (context) {
                                                List<PopupMenuEntry> items = [];
                                                items.add(PopupMenuItem(
                                                    value: 'edit',
                                                    child: Text("Edit")));
                                                items.add(PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text("Delete")));
                                                return items;
                                              }),
                                          // IconButton(
                                          //     onPressed: (){
                                          //
                                          //     },
                                          //     icon: Icon(Icons.more_vert_rounded))
                                        ]),
                                      ),
                                    ]),
                                  );
                                },
                              )
                            : Center(
                                child: Text(getTranslated(
                                    'no_address_available', context)))
                        : SizedBox(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Row(children: [
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddLocationScreen(
                                      isEnableUpdate: false,
                                    ))),
                        icon: Icon(Icons.add),
                        label: Text('Add address', style: robotoRegular),
                      ),
                    ]),
                  ),
                ]);
              }),
            );
          });
        });
  }
}
