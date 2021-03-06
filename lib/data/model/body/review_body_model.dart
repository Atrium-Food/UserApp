class ReviewBody {
  String _productId;
  String _deliveryManId;
  String _comment;
  int _rating;
  List<String> _fileUpload;
  String _orderId;
  String _userId;
  String _userName;
  String _userImage;

  ReviewBody(
      {String productId,
        String deliveryManId,
        String comment,
        int rating,
        String orderId,
        List<String> fileUpload,
        String userId,
        String userName,
        String userImage
      }) {
    this._productId = productId;
    this._deliveryManId = deliveryManId;
    this._comment = comment;
    this._rating = rating;
    this._orderId = orderId;
    this._fileUpload = fileUpload;
    this._userId=userId;
    this._userImage=userImage;
    this._userName=userName;
  }

  String get productId => _productId;
  String get deliveryManId => _deliveryManId;
  String get comment => _comment;
  String get orderId => _orderId;
  int get rating => _rating;
  List<String> get fileUpload => _fileUpload;
  String get userName => _userName;
  String get userId => _userId;
  String get userImage => _userImage;

  ReviewBody.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'].toString();
    _deliveryManId = json['delivery_man_id'];
    _comment = json['comment'];
    _orderId = json['order_id'].toString();
    _rating = json['rating'];
    _userId = json['user_id'] is Map<String, dynamic>?  json['user_id']['id'].toString():json["user_id"].toString();
    _userName=json['user_id'] is Map<String, dynamic>?json['user_id']['f_name']+" "+json['user_id']['l_name']:json["user_name"];
    _userImage=json['user_id'] is Map<String, dynamic>?json['user_id']['image']:json["user_image"];
    // _fileUpload = json['attachment']!=null? json['attachment']?.cast<String>():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['delivery_man_id'] = this._deliveryManId;
    data['comment'] = this._comment;
    data['order_id'] = this._orderId;
    data['rating'] = this._rating;
    data['attachment'] = this._fileUpload;
    data['user_id']=this._userId;
    data['user_image']=this._userImage;
    data['user_name'] = this._userName;
    return data;
  }
}
