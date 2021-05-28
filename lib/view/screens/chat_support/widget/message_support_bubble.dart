import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/chat_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/chat_support/dialogflow_utils/chat_provider_dialogflow.dart';
import 'package:provider/provider.dart';

class MessageSupportBubble extends StatelessWidget {
  final MessageModel message;
  final bool addDate;
  MessageSupportBubble({@required this.message, @required this.addDate});

  @override
  Widget build(BuildContext context) {
    bool isMe = message.isUser;
    // String dateTime = DateConverter.isoStringToLocalTimeOnly(message.sendTime.toString());
    // String _date = DateConverter.isoStringToLocalDateOnly(message.sendTime.toString()) == DateConverter.estimatedDate(DateTime.now()) ? 'Today'
    //     : DateConverter.isoStringToLocalDateOnly(message.sendTime.toString()) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1)))
    //     ? 'Yesterday' : DateConverter.isoStringToLocalDateOnly(message.sendTime.toString());

    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        addDate ? Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          // child: Align(alignment: Alignment.center, child: Text(_date, style: rubikMedium, textAlign: TextAlign.center)),
        ) : SizedBox(),
        Padding(
          padding: isMe ?  EdgeInsets.fromLTRB(50, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 50, 5),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                            bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: isMe ? ColorResources.getHintColor(context) : ColorResources.getSearchBg(context),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                              child: Text(message.message, style: rubikRegular.copyWith(color: isMe ? Theme.of(context).accentColor
                                  : Theme.of(context).textTheme.bodyText1.color)),
                            ),
                          ],
                        ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1),
              // Text(dateTime, style: rubikRegular.copyWith(fontSize: 8, color: ColorResources.COLOR_GREY_BUNKER)),
            ],
          ),
        ),
      ],
    );
  }
}
