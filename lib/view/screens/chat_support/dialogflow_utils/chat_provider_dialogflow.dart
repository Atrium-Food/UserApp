import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatProviderDialogFlow extends ChangeNotifier{
  List<MessageModel> chat = [];

  addMessageModel(MessageModel messageModel){
    chat.insert(0,messageModel);
    notifyListeners();
  }

  addMessage(String message, DateTime time,bool isUser){
    chat.insert(0,MessageModel(message:message,sendTime: time,isUser: isUser));
    notifyListeners();
  }

  clearChat(){
    chat.clear();
  }
}

class MessageModel{
  String message;
  DateTime sendTime;
  bool isUser;

  MessageModel({this.message,this.sendTime,@required this.isUser});
}