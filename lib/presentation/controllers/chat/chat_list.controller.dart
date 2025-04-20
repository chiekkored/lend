import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/message.model.dart';
import 'package:lend/core/models/simple_user.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class ChatListController extends GetxController {
  final Chat chat;
  ChatListController({required this.chat});

  static ChatListController get instance => Get.find<ChatListController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController textController = TextEditingController();
  final RxList<Message> _messages = <Message>[].obs;
  List<Message> get messages => _messages;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  SimpleUserModel? get recepientUser => chat.participants?.firstWhereOrNull(
    (user) => user.uid != AuthController.instance.uid,
  );

  StreamSubscription? _messagesSubscription;

  @override
  void onClose() {
    textController.dispose();
    _messagesSubscription?.cancel();
    _messages.close();
    _isLoading.close();
    super.onClose();
  }

  @override
  void onInit() {
    listenToChats();

    super.onInit();
  }

  void cancelSubscriptions() {
    _messagesSubscription?.cancel();
  }

  // Listen to user's chats
  void listenToChats() {
    _isLoading.value = true;

    try {
      _messagesSubscription?.cancel();

      _messagesSubscription = _firestore
          .collection(LNDCollections.chats.name)
          .doc(chat.chatId)
          .collection(LNDCollections.messages.name)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              final List<Message> chatsList = [];

              for (var doc in snapshot.docs) {
                final chat = Message.fromMap(doc.data());
                chatsList.add(chat);
              }

              _messages.value = chatsList;
              update();
              _isLoading.value = false;
            },
            onError: (e, st) {
              LNDLogger.e('Error listening to chats', error: e, stackTrace: st);
              _isLoading.value = false;
            },
          );
    } catch (e, st) {
      LNDLogger.e('Error setting up chat listener', error: e, stackTrace: st);
      _isLoading.value = false;
    }
  }
}
