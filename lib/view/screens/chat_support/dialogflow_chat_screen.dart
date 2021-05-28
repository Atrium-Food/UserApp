import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/chat_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/screens/chat/widget/message_bubble.dart';
import 'package:flutter_restaurant/view/screens/chat/widget/message_bubble_shimmer.dart';
import 'package:flutter_restaurant/view/screens/chat_support/dialogflow_utils/chat_provider_dialogflow.dart';
import 'package:flutter_restaurant/view/screens/chat_support/dialogflow_utils/oauth.dart';
import 'package:flutter_restaurant/view/screens/chat_support/widget/message_support_bubble.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:provider/provider.dart';

class DialogFlowChatScreen extends StatefulWidget {
  @override
  _DialogFlowChatScreenState createState() => _DialogFlowChatScreenState();
}

class _DialogFlowChatScreenState extends State<DialogFlowChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    GoogleAPIs.createAuthCreds();
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('message', context)),
      body: _isLoggedIn ? Consumer<ChatProviderDialogFlow>(
        builder: (context, chatProvider, child) {
          print(chatProvider.chat.length);
          return Column(children: [
            Expanded(
              child: chatProvider.chat != null ? chatProvider.chat.length > 0 ? ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                itemCount: chatProvider.chat.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return MessageSupportBubble(message:chatProvider.chat[index], addDate: true);
                },
              ) : SizedBox() : ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                itemCount: 20,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  return MessageBubbleShimmer(isMe: index % 2 == 0);
                },
              ),
            ),

            // Bottom TextField
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 100),
                child: Ink(
                  color: Theme.of(context).accentColor,
                  child: Row(children: [
                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: getTranslated('type_message_here', context),
                          hintStyle: rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                        ),
                        onChanged: (String newText) {
                          // if(newText.isNotEmpty && !Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                          //   Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                          // }else if(newText.isEmpty && Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                          //   Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                          // }
                        },
                      ),
                    ),

                    InkWell(
                      onTap: () async {
                        if(_controller.text.isNotEmpty){
                          // Provider.of<ChatProvider>(context, listen: false).sendMessage(
                          //   _controller.text, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                          //   Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id.toString(), context,
                          // );
                          DateTime sentAt = DateTime.now();
                          Provider.of<ChatProviderDialogFlow>(context,listen: false).addMessage(_controller.text, sentAt, true);
                          var reply = await GoogleAPIs.sendMessage(_controller.text);
                          if(reply!=null){
                            print("Not null");
                            Provider.of<ChatProviderDialogFlow>(context,listen: false).addMessageModel(reply);
                          }
                          _controller.text = '';
                        }else {
                          showCustomSnackBar('Write something', context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Image.asset(
                          Images.send,
                          width: 25, height: 25,
                          // color: Provider.of<ChatProvider>(context).isSendButtonActive ? Theme.of(context).primaryColor : ColorResources.getGreyBunkerColor(context),
                        ),
                      ),
                    ),

                  ]),
                ),
              ),

            ]),

          ]);
        },
      ) : NotLoggedInScreen(),
    );
  }
}
