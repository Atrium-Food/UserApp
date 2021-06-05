
class UserInfoModel {
  int id;
  String fName;
  String lName;
  String email;
  String image;
  int isPhoneVerified;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String emailVerificationToken;
  String phone;
  String cmFirebaseToken;
  List<CardModel> cards;

  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.emailVerificationToken,
        this.phone,
        this.cmFirebaseToken,
        this.cards,
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    cards=json['cards'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email_verification_token'] = this.emailVerificationToken;
    data['phone'] = this.phone;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    if (this.cards != null) {
      data['products'] = this.cards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CardModel{
  int _id;
  int _userId;
  String _cardHolderName;
  String _cardNumber;
  int _expiryMonth;
  int _expiryYear;
  String _createdAt;
  String _updatedAt;


  CardModel({int userId,int id, String cardHolderName, String cardNumber, int expiryMonth, int expiryYear, String createdAt, String updatedAt}){
    this._id=id;
    this._userId=userId;
    this._cardHolderName=cardHolderName;
    this._cardNumber=cardNumber;
    this._expiryMonth=expiryMonth;
    this._expiryYear=expiryYear;
    this._createdAt=createdAt;
    this._updatedAt=updatedAt;
  }

  int get id => _id;
  String get cardHolderName => _cardHolderName;
  String get cardNumber => _cardNumber;
  int get expiryMonth => _expiryMonth;
  int get expiryYear => _expiryYear;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  CardModel.fromJson(Map<String,dynamic> json){
    _id = json["id"];
    _cardNumber=json["card_number"];
    _cardHolderName=json["card_holder_name"];
    _expiryMonth = json["expiry_month"];
    _expiryYear=json["expiry_year"];
    _createdAt=json["created_at"];
    _updatedAt=json["updated_at"];
    _userId=json["user_id"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_holder_name'] = this._cardHolderName;
    data['card_number'] = this._cardNumber;
    data['expiry_month'] = this._expiryMonth;
    data['expiry_year'] = this._expiryYear;
    // data['created_at'] = this._createdAt;
    // data['updated_at'] = this._updatedAt;
    data['user_id'] = this._userId;
    return data;
  }

}