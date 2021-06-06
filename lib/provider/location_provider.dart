import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/error_response.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/repository/location_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/base/address_bottom_sheet.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final LocationRepo locationRepo;

  LocationProvider({@required this.sharedPreferences, this.locationRepo});

  Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  bool _loading = false;
  bool get loading => _loading;

  Position get position => _position;
  Placemark _address = Placemark();

  Placemark get address => _address;
  List<Marker> _markers = <Marker>[];

  List<Marker> get markers => _markers;

  LatLng _latLng;
  LatLng get latLng => _latLng;

  bool newAddress = false;

  // for get current location
  void getCurrentLocation({GoogleMapController mapController}) async {
    _loading = true;
    notifyListeners();
    try {
      Position newLocalData;
      try {
        newLocalData = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } on Exception catch(e){
        newAddress=false;
        notifyListeners();
        return;
      }
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(newLocalData.latitude, newLocalData.longitude),
                zoom: 17)));
        _position = newLocalData;

        List<Placemark> placemarks = await placemarkFromCoordinates(
            newLocalData.latitude, newLocalData.longitude);
        _address = placemarks.first;
        newAddress=true;
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    _loading = false;
    notifyListeners();
  }

  getLatLongfromAddress(String query)async {
    try {
      var addresses = await locationFromAddress(query);
      var first = addresses.first;
      _latLng=LatLng(first.latitude,first.longitude);
      return _latLng;
      // print("${first.latitude} : ${first.longitude}");
    } on Exception catch(e){
      print("LatLong Error");
      print(e.toString());
      return;
    }
  }

  void clearLatLng(){
    _latLng=null;
  }
  // update Position
  void updatePosition(CameraPosition position) async {
    _position = Position(
      latitude: position.target.latitude,
      longitude: position.target.longitude,
      timestamp: DateTime.now(),
      heading: 1,
      accuracy: 1,
      altitude: 1,
      speedAccuracy: 1,
      speed: 1,
    );
  }

  // End Address Position
  void dragableAddress() async {
    try {
      _loading = true;
      notifyListeners();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      _address = placemarks.first;
      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
    }
  }

  // delete usser address
  void deleteUserAddressByID(int id, int index, Function callback) async {
    ApiResponse apiResponse = await locationRepo.removeAddressByID(id);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _addressList.removeAt(index);
      callback(true, 'Deleted address successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
    }
  }

  bool _isAvaibleLocation = false;

  bool get isAvaibleLocation => _isAvaibleLocation;

  // user address
  List<AddressModel> _addressList;

  List<AddressModel> get addressList => _addressList;

  Position _currentLocation = Position(
    latitude: 0,
    longitude: 0,
    speed: 1,
    speedAccuracy: 1,
    altitude: 1,
    accuracy: 1,
    heading: 1,
    timestamp: DateTime.now(),
  );
  Position get currentLocation => _currentLocation;

  Future<Position> locateUser() async {
    try {
      var result = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return result;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  void getUserLocation(BuildContext context,bool isReset) async {
    if(isReset || _address==null || _address.locality==null) {
      _currentLocation = await locateUser();
      if (_currentLocation == null) {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddressBottomSheet();
            });
      } else {
        try {
          var currentAddresses = await placemarkFromCoordinates(
              _currentLocation.latitude, _currentLocation.longitude);
          _address = currentAddresses.first;
        } on Exception catch (e) {
          print("$e Address can't be found");
          _address = null;
        }
        print("longitude" + _currentLocation.longitude.toString());
        notifyListeners();
      }
    }
  }

  void setAddress(int index) async{
    try {
      var currentAddresses = await placemarkFromCoordinates(
          double.parse(_addressList[index].latitude),double.parse(_addressList[index].longitude));
      _address = currentAddresses.first;
    } on Exception catch (e) {
      print("$e Address can't be found");
      _address = null;
    }
    notifyListeners();
  }
  Future<ResponseModel> initAddressList(BuildContext context) async {
    ResponseModel _responseModel;
    ApiResponse apiResponse = await locationRepo.getAllAddress();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _addressList = [];
      apiResponse.response.data.forEach(
          (address) => _addressList.add(AddressModel.fromJson(address)));
      _responseModel = ResponseModel(true, 'successful');
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  String _addressStatusMessage = '';
  String get addressStatusMessage => _addressStatusMessage;
  updateAddressStatusMessae({String message}) {
    _addressStatusMessage = message;
  }

  updateErrorMessage({String message}) {
    _errorMessage = message;
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponse apiResponse = await locationRepo.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      if (_addressList == null) {
        _addressList = [];
      }
      _addressList.add(addressModel);
      String message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for address update screen
  Future<ResponseModel> updateAddress(BuildContext context,
      {AddressModel addressModel, int addressId}) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponse apiResponse =
        await locationRepo.updateAddress(addressModel, addressId);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      initAddressList(context);
      String message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for save user address Section
  Future<void> saveUserAddress({Placemark address}) async {
    String userAddress = jsonEncode(address);
    try {
      await sharedPreferences.setString(AppConstants.USER_ADDRESS, userAddress);
    } catch (e) {
      throw e;
    }
  }

  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS) ?? "";
  }

  // for Label Us
  List<String> _getAllAddressType = [];

  List<String> get getAllAddressType => _getAllAddressType;
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index) {
    _selectAddressIndex = index;
    notifyListeners();
  }

  initializeAllAddressType({BuildContext context}) {
    if (_getAllAddressType.length == 0) {
      _getAllAddressType = [];
      _getAllAddressType = locationRepo.getAllAddressType(context: context);
    }
  }
}
