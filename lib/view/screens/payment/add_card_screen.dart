import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/menu_app_bar.dart';

class AddCardScreen extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  FocusNode _cardNumberFocus;
  FocusNode _cardNameFocus;
  FocusNode _expiryMonthFocus;
  FocusNode _expiryYearFocus;

  TextEditingController _cardNumberController;
  TextEditingController _cardNameController;
  TextEditingController _expiryMonthController;
  TextEditingController _expiryYearController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cardNameFocus=FocusNode();
    _cardNameFocus=FocusNode();
    _expiryMonthFocus=FocusNode();
    _expiryYearFocus=FocusNode();
    _cardNameController=TextEditingController();
    _cardNameController=TextEditingController();
    _expiryMonthController=TextEditingController();
    _expiryYearController=TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(),
      backgroundColor: ColorResources.getThemeColor(context),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          alignment: Alignment.topCenter,
          child: ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Add Card',
                style: rubikRegular.copyWith(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: ColorResources.getThemeColor(context),
                    ),
                    constraints: BoxConstraints(
                      maxHeight:  MediaQuery.of(context).size.height * 0.75,
                    ),
                    // height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ListView(
                      shrinkWrap: true,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text(
                          'Add New Credit/Debit Card',
                          style: rubikMedium.copyWith(fontSize: 15),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                            child: CustomTextField(
                              controller: _cardNumberController,
                              hintText: 'Card Number',
                              isShowBottomBorder: true,
                              focusNode: _cardNumberFocus,
                              nextFocus: _cardNameFocus,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                            child: CustomTextField(
                              controller: _cardNameController,
                              hintText: 'Card Name',
                              isShowBottomBorder: true,
                              focusNode: _cardNameFocus,
                              nextFocus: _expiryMonthFocus,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                                child: CustomTextField(
                                  controller: _expiryMonthController,
                                  hintText: 'Expiry Month',
                                  isShowBottomBorder: true,
                                  focusNode: _expiryMonthFocus,
                                  nextFocus: _expiryYearFocus,
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                                child: CustomTextField(
                                  controller: _expiryYearController,
                                  hintText: 'Expiry Year',
                                  isShowBottomBorder: true,
                                  focusNode: _expiryYearFocus,
                                )),

                          ],
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomButton(
                              btnTxt: 'Save',
                              onTap: () {

                              },
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
