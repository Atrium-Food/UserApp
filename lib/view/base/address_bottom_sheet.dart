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
import 'package:provider/provider.dart';

class AddressBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context,listen: false).initAddressList(context);
    return BottomSheet(
        onClosing: (){},
        builder: (context){
          return Consumer<LocationProvider>(
            builder: (context, address,child) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Consumer<OrderProvider>(
                  builder: (context, order,child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                        children: [
                      SizedBox(
                        // height: 100,
                        child: address.addressList != null
                            ? address.addressList.length > 0
                            ? ListView.separated(
                          // physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          separatorBuilder:
                              (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(4),
                            );
                          },
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              left: Dimensions
                                  .PADDING_SIZE_SMALL),
                          itemCount:
                          address.addressList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                  order.setAddressIndex(
                                      index);
                                  address.setAddress(index);
                              },
                              child: Stack(children: [
                                Container(
                                  height: 60,
                                  // width: 200,
                                  margin: EdgeInsets.only(
                                      right: Dimensions
                                          .PADDING_SIZE_LARGE),
                                  decoration:
                                  BoxDecoration(
                                    color: index ==
                                        order
                                            .addressIndex
                                        ? Theme.of(
                                        context)
                                        .accentColor
                                        : ColorResources
                                        .getBackgroundColor(
                                        context),
                                    borderRadius:
                                    BorderRadius
                                        .circular(10),
                                    border: index ==
                                        order
                                            .addressIndex
                                        ? Border.all(
                                        color: ColorResources
                                            .getPrimaryColor(
                                            context),
                                        width: 2)
                                        : null,
                                  ),
                                  child: Row(children: [
                                    Padding(
                                      padding: EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            address.addressList[index].addressType ==
                                                'Home'
                                                ? Icons
                                                .home_outlined
                                                : address.addressList[index].addressType ==
                                                'Workplace'
                                                ? Icons
                                                .work_outline
                                                : Icons
                                                .list_alt_outlined,
                                            color: index ==
                                                order
                                                    .addressIndex
                                                ? ColorResources
                                                .getPrimaryColor(
                                                context)
                                                : Theme.of(
                                                context)
                                                .textTheme
                                                .bodyText1
                                                .color,
                                            size: 30,
                                          ),
                                          Text(
                                              address
                                                  .addressList[
                                              index]
                                                  .addressType,
                                              style: rubikRegular
                                                  .copyWith(
                                                fontSize:
                                                Dimensions
                                                    .FONT_SIZE_SMALL,
                                                color: ColorResources
                                                    .getGreyBunkerColor(
                                                    context),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets
                                            .all(Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL)),
                                    Text(
                                        address
                                            .addressList[
                                        index]
                                            .address,
                                        style:
                                        rubikRegular,
                                        overflow:
                                        TextOverflow
                                            .ellipsis),
                                    Spacer(),
                                    PopupMenuButton(
                                        icon: Icon(Icons
                                            .more_vert_rounded),
                                        itemBuilder:
                                            (context) {
                                          List<PopupMenuEntry>
                                          items = [];
                                          items.add(PopupMenuItem(
                                              child: Text(
                                                  "Edit")));
                                          items.add(PopupMenuItem(
                                              child: Text(
                                                  "Delete")));
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
                                'no_address_available',
                                context)))
                            : Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                                    Theme.of(context)
                                        .primaryColor))),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                            Dimensions.PADDING_SIZE_SMALL),
                        child: Row(children: [
                          TextButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        AddLocationScreen(
                                            fromCheckout: true))),
                            icon: Icon(Icons.add),
                            label: Text('Add address',
                                style: rubikRegular),
                          ),
                        ]),
                      ),
                    ]);
                  }
                ),
              );
            }
          );
        }
    );
  }
}