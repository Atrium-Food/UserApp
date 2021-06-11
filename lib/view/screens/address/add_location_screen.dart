import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/address/select_location_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddLocationScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  AddLocationScreen({this.isEnableUpdate = false, this.address, this.fromCheckout = false});

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _contactPersonNameController = TextEditingController();

  final TextEditingController _contactPersonNumberController = TextEditingController();

  final FocusNode _addressNode = FocusNode();

  final FocusNode _nameNode = FocusNode();

  final FocusNode _numberNode = FocusNode();

  String _addressError='';
  String _nameError='';
  String _numberError='';
  bool newAddress=false;
  @override
  Widget build(BuildContext context) {
    GoogleMapController _controller;

    Provider.of<LocationProvider>(context, listen: false).initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessae(message: '');
    Provider.of<LocationProvider>(context, listen: false).updateErrorMessage(message: '');

    if (widget.isEnableUpdate && widget.address != null) {
      Provider.of<LocationProvider>(context, listen: false)
          .updatePosition(CameraPosition(target: LatLng(double.parse(widget.address.latitude), double.parse(widget.address.longitude))));
      _locationController.text = '${widget.address.address}';
      _contactPersonNameController.text = '${widget.address.contactPersonName}';
      _contactPersonNumberController.text = '${widget.address.contactPersonNumber}';
      if (widget.address.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(0);
      } else if (widget.address.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(1);
      } else {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(2);
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
          title: widget.isEnableUpdate ? getTranslated('update_address', context) : getTranslated('add_new_address', context),
        isBackButtonExist: true,
        onBackPressed: (){
            // Provider.of<LocationProvider>(context,listen: false).setLoadingFalse();
            Navigator.pop(context);
        },
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          // if (widget.isEnableUpdate && locationProvider.address != null) {
          //   _locationController.text = '${locationProvider.address.name ?? ''}, '
          //       '${locationProvider.address.subAdministrativeArea ?? ''}, '
          //       '${locationProvider.address.isoCountryCode ?? ''}';
          // }
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.7,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRect(
                          // borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                          child: Stack(
                            clipBehavior: Clip.none, children: [
                            GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: widget.isEnableUpdate
                                    ? LatLng(double.parse(widget.address.latitude) ?? 0.0, double.parse(widget.address.longitude) ?? 0.0)
                                    : LatLng(locationProvider.position.latitude ?? 0.0, locationProvider.position.longitude ?? 0.0),
                                zoom: 12,
                              ),
                              onTap: (latLng) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => SelectLocationScreen()));
                              },
                              zoomControlsEnabled: false,
                              compassEnabled: false,
                              indoorViewEnabled: true,
                              mapToolbarEnabled: false,
                              onCameraIdle: () {
                                locationProvider.dragableAddress();
                              },
                              onCameraMove: ((_position) => locationProvider.updatePosition(_position)),
                              onMapCreated: (GoogleMapController controller) {
                                _controller = controller;
                                if (!widget.isEnableUpdate && _controller != null) {
                                  Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(mapController: _controller);
                                }
                              },
                            ),
                            locationProvider.loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme
                                .of(context).primaryColor))) : SizedBox(),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height,
                                child: Image.asset(
                                  Images.marker,
                                  width: 25,
                                  height: 35,
                                )),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  locationProvider.getCurrentLocation(mapController: _controller);
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                    color: ColorResources.COLOR_WHITE,
                                  ),
                                  child: Icon(
                                    Icons.my_location,
                                    color: ColorResources.COLOR_PRIMARY,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          ),
                        ),
                      ),
                      DraggableScrollableSheet(
                        initialChildSize: 0.2,
                        maxChildSize: 0.9,
                        minChildSize: 0.2,
                        builder: (context,scrollController){
                          return Container(
                            // height: MediaQuery.of(context).size.height*0.2,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)
                              ),

                              color: ColorResources.getBackgroundColor(context),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              controller: scrollController,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Center(
                                      child: Text(
                                        getTranslated('add_the_location_correctly', context),
                                        style:
                                        Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),
                                      )),
                                ),

                                // for label us
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                                  child: Text(
                                    getTranslated('label_us', context),
                                    style:
                                    Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                                  ),
                                ),

                                Container(
                                  height: 30,
                                  child: ListView.separated(
                                    separatorBuilder: (context,index){
                                      return Padding(padding: EdgeInsets.all(3),);
                                    },
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: locationProvider.getAllAddressType.length,
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        locationProvider.updateAddressIndex(index);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                                        // margin: EdgeInsets.only(right: 17),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            border: Border.all(
                                                color:
                                                locationProvider.selectAddressIndex == index ? ColorResources.COLOR_PRIMARY : ColorResources.BORDER_COLOR),
                                            color: locationProvider.selectAddressIndex == index ? ColorResources.COLOR_PRIMARY : ColorResources.SEARCH_BG),
                                        child: Text(
                                          locationProvider.getAllAddressType[index],
                                          style: Theme.of(context).textTheme.headline2.copyWith(
                                              color: locationProvider.selectAddressIndex == index ? ColorResources.COLOR_WHITE : ColorResources.COLOR_BLACK),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                                  child: Text(
                                    getTranslated('delivery_address', context),
                                    style:
                                    Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                                  ),
                                ),

                                // for Address Field
                                Text(
                                  getTranslated('address_line_01', context),
                                  style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText: getTranslated('address_line_02', context),
                                  isShowBorder: true,
                                  inputType: TextInputType.streetAddress,
                                  inputAction: TextInputAction.next,
                                  focusNode: _addressNode,
                                  errorMessage: _addressError,
                                  nextFocus: _nameNode,
                                  controller: _locationController,
                                  maxLines: 4,
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                // for Contact Person Name
                                Text(
                                  getTranslated('contact_person_name', context),
                                  style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText: getTranslated('enter_contact_person_name', context),
                                  isShowBorder: true,
                                  inputType: TextInputType.name,
                                  controller: _contactPersonNameController,
                                  focusNode: _nameNode,
                                  nextFocus: _numberNode,
                                  errorMessage: _numberError,
                                  inputAction: TextInputAction.next,
                                  capitalization: TextCapitalization.words,
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                // for Contact Person Number
                                Text(
                                  getTranslated('contact_person_number', context),
                                  style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText: getTranslated('enter_contact_person_number', context),
                                  isShowBorder: true,
                                  inputType: TextInputType.phone,
                                  inputAction: TextInputAction.done,
                                  errorMessage: _numberError,
                                  focusNode: _numberNode,
                                  controller: _contactPersonNumberController,
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),
                                locationProvider.addressStatusMessage != null
                                    ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    locationProvider.addressStatusMessage.length > 0 ? CircleAvatar(backgroundColor: Colors.green, radius: 5) : SizedBox.shrink(),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        locationProvider.addressStatusMessage ?? "",
                                        style:
                                        Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.green, height: 1),
                                      ),
                                    )
                                  ],
                                )
                                    : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    locationProvider.errorMessage.length > 0
                                        ? CircleAvatar(backgroundColor: ColorResources.getPrimaryColor(context), radius: 5)
                                        : SizedBox.shrink(),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        locationProvider.errorMessage ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getPrimaryColor(context), height: 1),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 50.0,
                                  padding: EdgeInsets.only(left:Dimensions.PADDING_SIZE_SMALL,right: Dimensions.PADDING_SIZE_SMALL),
                                  child: !locationProvider.isLoading ? CustomButton(
                                    btnTxt: widget.isEnableUpdate ? getTranslated('update_address', context) : getTranslated('save_location', context),
                                    onTap: locationProvider.loading ? null : () async {
                                      /// branch logic
                                      // List<Branches> _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;
                                      // bool _isAvailable = _branches.length == 1 && (_branches[0].latitude == null || _branches[0].latitude.isEmpty);
                                      // if(!_isAvailable) {
                                      //   for (Branches branch in _branches) {
                                      //     double _distance = Geolocator.distanceBetween(
                                      //       double.parse(branch.latitude), double.parse(branch.longitude),
                                      //       locationProvider.position.latitude, locationProvider.position.longitude,
                                      //     ) / 1000;
                                      //     if (_distance < branch.coverage) {
                                      //       _isAvailable = true;
                                      //       break;
                                      //     }
                                      //   }
                                      // }
                                      // if(!_isAvailable) {
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //     content: Text(getTranslated('service_is_not_available', context)),
                                      //     backgroundColor: Colors.red,
                                      //   ));
                                      // }else {
                                      String _latitude;
                                      String _longitude;
                                      print("Add Address");
                                      print(locationProvider.newAddress);
                                      // if(!locationProvider.newAddress && !widget.isEnableUpdate) {
                                        print("Null latitude");
                                        LatLng latLng= await Provider.of<LocationProvider>(context,listen: false).getLatLongfromAddress(_locationController.text);
                                        _latitude=latLng.latitude.toString();
                                        _longitude=latLng.longitude.toString();
                                      // } else if(newAddress){
                                      //   _latitude=locationProvider.position.latitude.toString();
                                      //   _longitude=locationProvider.position.longitude.toString();
                                      // } else if(widget.isEnableUpdate){
                                      //   _latitude=widget.address.latitude;
                                      //   _longitude=widget.address.longitude;
                                      // }
                                      print("$_latitude,$_longitude");
                                      AddressModel addressModel = AddressModel(
                                        addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                                        contactPersonName: _contactPersonNameController.text ?? '',
                                        contactPersonNumber: _contactPersonNumberController.text ?? '',
                                        address: _locationController.text ?? '',
                                        latitude: _latitude,
                                        longitude: _longitude,
                                        // latitude: isEnableUpdate ? locationProvider.position.latitude.toString() ?? address.latitude
                                        //     : locationProvider.position.latitude.toString() ?? '',
                                        // longitude: locationProvider.position.longitude.toString() ?? '',
                                      );
                                      print(addressModel.toJson());
                                      // Provider.of<LocationProvider>(context,listen: false).clearLatLng();
                                      if (widget.isEnableUpdate) {
                                        addressModel.id = widget.address.id;
                                        addressModel.userId = widget.address.userId;
                                        addressModel.method = 'put';
                                        locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {});
                                      } else {
                                        locationProvider.addAddress(addressModel).then((value) {
                                          if (value.isSuccess) {
                                            // showCustomSnackBar(locationProvider.addressStatusMessage, context, isError: false);
                                            if (widget.fromCheckout) {
                                              Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
                                              Provider.of<OrderProvider>(context, listen: false).setAddressIndex(-1);
                                              Navigator.pop(context);
                                            } else {
                                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message), backgroundColor: Colors.green));
                                              Navigator.pop(context);
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message), backgroundColor: Colors.red));
                                          }
                                        });
                                      }
                                      // }
                                    },
                                  )
                                      : Center(
                                      child: CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryColor(context)),
                                      )),
                                )
                              ],
                            ),
                          );
                        },
                      ),

                    ],
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
