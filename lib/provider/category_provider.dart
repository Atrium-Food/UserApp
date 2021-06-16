import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/category_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({@required this.categoryRepo});

  List<CategoryModel> _categoryList;
  List<CategoryModel> _subCategoryList;
  List<Product> _categoryProductList;

  Map<String, bool> _availableList={};

  List<CategoryModel> get categoryList => _categoryList;
  List<CategoryModel> get subCategoryList => _subCategoryList;
  List<Product> get categoryProductList => _categoryProductList;

  bool _veg = false;

  bool get veg => _veg;

  setVeg(bool val){
    _veg=val;
    notifyListeners();
  }

  Future<void> getCategoryList(BuildContext context, bool reload) async {
    if(_categoryList == null || reload) {
      ApiResponse apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _categoryList = [];
        apiResponse.response.data.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void getSubCategoryList(BuildContext context, String categoryID, {double lat,double long,bool veg=false}) async {
    _subCategoryList = null;
    ApiResponse apiResponse = await categoryRepo.getSubCategoryList(categoryID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _subCategoryList= [];
      apiResponse.response.data.forEach((category) => _subCategoryList.add(CategoryModel.fromJson(category)));
      getCategoryProductList(context, categoryID, lat: lat,long: long,veg: veg);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void getCategoryProductList(BuildContext context, String categoryID, {double lat, double long,bool veg=false}) async {
    _categoryProductList = null;
    notifyListeners();
    print("Lat, Long Category: $lat, $long");
    ApiResponse apiResponse = await categoryRepo.getCategoryProductList(categoryID,lat: lat,long: long,veg: veg);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _categoryProductList = [];
      _availableList[categoryID]=apiResponse.response.data.isEmpty;
      apiResponse.response.data.forEach((category) => _categoryProductList.add(Product.fromJson(category)));
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  int _selectCategory = -1;

  int get selectCategory => _selectCategory;

  updateSelectCategory(int index) {
    _selectCategory = index;
    notifyListeners();
  }
}
