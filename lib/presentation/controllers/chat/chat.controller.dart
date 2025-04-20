import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/message.model.dart';
import 'package:lend/core/models/simple_user.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/message_type.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find<ChatController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final chat = Get.arguments as Chat;

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

  void sendMessage() {
    try {
      if (textController.text.isNotEmpty) {
        final textMessage = textController.text;
        textController.clear();

        final messageCollection = _firestore
            .collection(LNDCollections.chats.name)
            .doc(chat.chatId)
            .collection(LNDCollections.messages.name);

        final message = Message(
          id: messageCollection.doc().id,
          text: textMessage,
          senderId: AuthController.instance.uid,
          createdAt: Timestamp.now(),
          type: MessageType.text.label,
        );

        messageCollection.doc(message.id).set(message.toMap()).catchError((
          e,
          st,
        ) {
          LNDLogger.e('Error sending message', error: e, stackTrace: st);
        });
      }
    } catch (e, st) {
      LNDLogger.e(
        'Something wrong while sending a message',
        error: e,
        stackTrace: st,
      );
    }
  }
}
