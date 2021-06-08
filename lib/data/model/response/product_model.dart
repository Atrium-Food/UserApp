import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/utill/strings.dart';

class ProductModel {
  int _totalSize;
  String _limit;
  String _offset;
  List<Product> _products;

  ProductModel(
      {int totalSize, String limit, String offset, List<Product> products}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._products = products;
  }

  int get totalSize => _totalSize;
  String get limit => _limit;
  String get offset => _offset;
  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int _id;
  String _name;
  String _description;
  String _image;
  double _price;
  List<Variation> _variations;
  List<AddOns> _addOns;
  double _tax;
  String _availableTimeStarts;
  String _availableTimeEnds;
  int _status;
  String _createdAt;
  String _updatedAt;
  List<String> _attributes;
  List<CategoryId> _categoryIds;
  List<ChoiceOption> _choiceOptions;
  double _discount;
  String _discountType;
  String _taxType;
  int _setMenu;
  double _calories_per_serving;
  Rating _rating;
  List<Ingredients> _ingredients;
  Recipe _recipe;
  Nutrients _nutrients;
  List<ReviewBody> _reviews;
  int _serves;
  String _cuisine;
  String _time;

  Product({
    int id,
    String time,
    int serves,
    String cuisine,
    double calories_per_serving,
    String name,
    String description,
    String image,
    double price,
    List<Variation> variations,
    List<AddOns> addOns,
    double tax,
    String availableTimeStarts,
    String availableTimeEnds,
    int status,
    String createdAt,
    String updatedAt,
    List<String> attributes,
    List<CategoryId> categoryIds,
    List<ChoiceOption> choiceOptions,
    double discount,
    String discountType,
    String taxType,
    int setMenu,
    Rating rating,
    List<Ingredients> ingredients,
    Recipe recipe,
    Nutrients nutrients,
    List<ReviewBody> reviews,
  }) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._image = image;
    this._price = price;
    this._variations = variations;
    this._addOns = addOns;
    this._tax = tax;
    this._time = time;
    this._serves = serves;
    this._cuisine = cuisine;
    this._calories_per_serving = calories_per_serving;
    this._availableTimeStarts = availableTimeStarts;
    this._availableTimeEnds = availableTimeEnds;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._attributes = attributes;
    this._categoryIds = categoryIds;
    this._choiceOptions = choiceOptions;
    this._discount = discount;
    this._discountType = discountType;
    this._taxType = taxType;
    this._setMenu = setMenu;
    this._rating = rating;
    this._ingredients = ingredients;
    this._recipe = recipe;
    this._nutrients = nutrients;
    this._reviews = reviews;
  }

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get image => _image;
  double get price => _price;
  List<Variation> get variations => _variations;
  List<AddOns> get addOns => _addOns;
  double get tax => _tax;
  String get availableTimeStarts => _availableTimeStarts;
  String get availableTimeEnds => _availableTimeEnds;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  List<String> get attributes => _attributes;
  List<CategoryId> get categoryIds => _categoryIds;
  List<ChoiceOption> get choiceOptions => _choiceOptions;
  double get discount => _discount;
  String get discountType => _discountType;
  String get taxType => _taxType;
  int get setMenu => _setMenu;
  Rating get rating => _rating;
  List<Ingredients> get ingredients => _ingredients;
  Recipe get recipe => _recipe;
  Nutrients get nutrients => _nutrients;
  List<ReviewBody> get reviews => _reviews;
  double get calories_per_serving => _calories_per_serving;
  String get time => _time;
  int get serves => _serves;
  String get cuisine => _cuisine;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _time = json['time'];
    _cuisine = json['cuisine'];
    _serves = json['serves'];
    _image = json['image'];
    _price = json['price'].toDouble();
    if (json['variations'] != null) {
      _variations = [];
      json['variations'].forEach((v) {
        _variations.add(new Variation.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns.add(new AddOns.fromJson(v));
      });
    }

    if (json['ingredients'] != null) {
      _ingredients = [];
      json['ingredients'].forEach((v) {
        _ingredients.add(new Ingredients.fromJson(v));
      });
    }

    _tax = json['tax'].toDouble();
    _availableTimeStarts = json['available_time_starts'];
    _availableTimeEnds = json['available_time_ends'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _attributes = json['attributes'].cast<String>();
    if (json['category_ids'] != null) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds.add(new CategoryId.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions.add(new ChoiceOption.fromJson(v));
      });
    }
    _discount = json['discount'].toDouble();
    _calories_per_serving = json['calories_per_serving'];
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];
    _setMenu = json['set_menu'];
    if (json['rating'] != null) {
      // _rating = [];
      // json['rating'].forEach((v) {
      //   _rating.add(new Rating.fromJson(v));
      // });
      if (json['rating'].length > 0)
        _rating = json['rating'][0] != null
            ? Rating.fromJson(json['rating'][0])
            : null;
    }

    if (json['recipe'] != null) {
      _recipe = Recipe.fromJson(json['recipe']);
    }

    if (json['nutrients'] != null) {
      _nutrients = Nutrients.fromJson(json['nutrients']);
    }

    if (json['reviews'] != null) {
      json['reviews'].forEach((v) {
        _reviews.add(new ReviewBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['description'] = this._description;
    data['image'] = this._image;
    data['calories_per_serving'] = this._calories_per_serving;
    data['time'] = this._time;
    data['serves'] = this._serves;
    data['cuisine'] = this._cuisine;
    data['price'] = this._price;
    if (this._variations != null) {
      data['variations'] = this._variations.map((v) => v.toJson()).toList();
    }
    if (this._addOns != null) {
      data['add_ons'] = this._addOns.map((v) => v.toJson()).toList();
    }
    data['tax'] = this._tax;
    data['available_time_starts'] = this._availableTimeStarts;
    data['available_time_ends'] = this._availableTimeEnds;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['attributes'] = this._attributes;
    if (this._categoryIds != null) {
      data['category_ids'] = this._categoryIds.map((v) => v.toJson()).toList();
    }
    if (this._choiceOptions != null) {
      data['choice_options'] =
          this._choiceOptions.map((v) => v.toJson()).toList();
    }
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['tax_type'] = this._taxType;
    data['set_menu'] = this._setMenu;
    // if (this._rating != null) {
    //   data['rating'] = this._rating.map((v) => v.toJson()).toList();
    // }
    if (this._rating != null) data['rating'] = this._rating.toJson();

    if (this._ingredients != null) {
      data['ingredients'] = this._ingredients.map((v) => v.toJson()).toList();
    }

    if (this._recipe != null) {
      data['recipe'] = this._recipe.toJson();
    }

    if (this._nutrients != null) {
      data['nutrients'] = this._nutrients.toJson();
    }
    if (this._reviews != null) {
      data['reviews'] = this._reviews.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Variation {
  String _type;
  double _price;

  Variation({String type, double price}) {
    this._type = type;
    this._price = price;
  }

  String get type => _type;
  double get price => _price;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    if (json['price'] != null) {
      _price = json['price'].toDouble();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['price'] = this._price;
    return data;
  }
}

class Recipe {
  List<String> _procedure;
  String _description;

  Recipe({List<String> procedure, String description}) {
    this._procedure = procedure;
    this._description = description;
  }

  List<String> get procedure => _procedure;
  String get description => _description;

  Recipe.fromJson(Map<String, dynamic> json) {
    _procedure = json['procedure'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['procedure'] = this.procedure;
    data['description'] = this.description;

    return data;
  }
}

class Nutrients {
  int _glycemicIndex;
  int _glycemicLoad;
  double _score;
  double _protein;
  double _calories;
  double _carbs;
  double _energy;
  double _fats;
  double _fiber;
  double _sugar;
  String _suggestion;

  Nutrients(
      {int glycemicIndex,
      int glycemicLoad,
      double score,
      double protein,
      double calories,
      double carbs,
      double energy,
      double fats,
      double fiber,
      double sugar,
      String suggestion}) {
    this._glycemicIndex = glycemicIndex;
    this._glycemicLoad = glycemicLoad;
    this._score = score;
    this._protein = protein;
    this._calories = calories;
    this._energy = energy;
    this._fats = fats;
    this._fiber = fiber;
    this._sugar = sugar;
    this._suggestion = suggestion;
  }

  int get glycemicIndex => _glycemicIndex;
  int get glycemicLoad => _glycemicLoad;
  double get score => _score;
  double get protein => _protein;
  double get calories => _calories;
  double get carbs => _carbs;
  double get energy => _energy;
  double get fats => _fats;
  double get fiber => _fiber;
  double get sugar => _sugar;
  String get suggestion => _suggestion;

  Nutrients.fromJson(Map<String, dynamic> json) {
    _glycemicIndex = json['glycemic_index'];
    _glycemicLoad = json['glycemic_load'];
    _score = json['score'];
    _protein = json['protein'];
    _calories = json['calories'];
    _carbs = json['carbs'];
    _energy = json['energy'];
    _fats = json['fats'];
    _fiber = json['fiber'];
    _sugar = json['sugar'];
    _suggestion = json['suggestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['glycemicIndex'] = _glycemicIndex;
    data['glycemicLoad'] = _glycemicLoad;
    data['score'] = _score;
    data['protein'] = _protein;
    data['calories'] = _calories;
    data['carbs'] = _carbs;
    data['energy'] = _energy;
    data['fats'] = _fats;
    data['fiber'] = _fiber;
    data['sugar'] = _sugar;
    data['suggestion'] = _suggestion;

    return data;
  }
}

class AddOns {
  int _id;
  String _name;
  double _price;
  String _createdAt;
  String _updatedAt;

  AddOns(
      {int id, String name, double price, String createdAt, String updatedAt}) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  String get name => _name;
  double get price => _price;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  AddOns.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['price'] = this._price;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class Ingredients {
  int _id;
  String _name;
  int _quantity;
  double _price;
  String _createdAt;
  String _updatedAt;
  int _minQuantity;

  Ingredients(
      {int id,
      String name,
      double price,
      String createdAt,
      String updatedAt,
      int quantity,
      int minQuantity}) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._quantity = quantity;
    this._minQuantity = minQuantity;
  }

  int get id => _id;
  int get quantity => _quantity;
  String get name => _name;
  double get price => _price;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get minQuantity => _minQuantity;

  Ingredients.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _quantity = json['quantity'];
    _minQuantity = json['min_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['price'] = this._price;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['quantity'] = this.quantity;
    return data;
  }
}

class CategoryId {
  String _id;
  int _position;

  CategoryId({String id, int position}) {
    this._id = id;
    this._position = position;
  }

  String get id => _id;
  int get position => _position;

  CategoryId.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['position'] = this._position;
    return data;
  }
}

class ChoiceOption {
  String _name;
  String _title;
  List<String> _options;

  ChoiceOption({String name, String title, List<String> options}) {
    this._name = name;
    this._title = title;
    this._options = options;
  }

  String get name => _name;
  String get title => _title;
  List<String> get options => _options;

  ChoiceOption.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['title'] = this._title;
    data['options'] = this._options;
    return data;
  }
}

class Rating {
  int _productId;
  String _average;
  List<int> _countRating;
  int _countTotalRating;

  Rating({String average, List<int> countRating, int productId}) {
    this._countRating = countRating;
    this._countTotalRating = countRating.reduce((a, b) => a + b);
    this._productId = productId;
    this._average = average;
  }

  String get average => _average;
  int get productId => _productId;
  List<int> get countRating => _countRating;
  int get countTotalRating => _countTotalRating;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'];
    _productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this._average;
    data['product_id'] = this._productId;
    return data;
  }
}
