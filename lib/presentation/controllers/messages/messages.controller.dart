import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';
import 'package:lend/core/mixins/scroll.mixin.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/message.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class MessagesController extends GetxController with AuthMixin, LNDScrollMixin {
  static MessagesController get instance => Get.find<MessagesController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Chat> _chats = <Chat>[].obs;
  List<Chat> get chats => _chats;

  final RxList<Message> _messages = <Message>[].obs;
  List<Message> get messages => _messages;

  final RxBool _isChatsLoading = false.obs;
  bool get isChatsLoading => _isChatsLoading.value;

  final RxBool _isMessagesLoading = false.obs;
  bool get isMessagesLoading => _isMessagesLoading.value;

  StreamSubscription? _chatsSubscription;

  @override
  void onClose() {
    _chatsSubscription?.cancel();
    _chats.close();
    _messages.close();
    _isChatsLoading.close();
    _isMessagesLoading.close();
    super.onClose();
  }

  void cancelSubscriptions() {
    _chatsSubscription?.cancel();
  }

  // Listen to user's chats
  void listenToChats() {
    _isChatsLoading.value = true;
    final userId = AuthController.instance.uid;

    try {
      _chatsSubscription?.cancel();

      _chatsSubscription = _firestore
          .collection(LNDCollections.userChats.name)
          .doc(userId)
          .collection(LNDCollections.chats.name)
          .orderBy('lastMessageDate', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              final List<Chat> chatsList = [];

              for (var doc in snapshot.docs) {
                final chat = Chat.fromMap(doc.data());
                chatsList.add(chat);
              }

              _chats.value = chatsList;
              _isChatsLoading.value = false;
            },
            onError: (e, st) {
              LNDLogger.e('Error listening to chats', error: e, stackTrace: st);
              _isChatsLoading.value = false;
            },
          );
    } catch (e, st) {
      LNDLogger.e('Error setting up chat listener', error: e, stackTrace: st);
      _isChatsLoading.value = false;
    }
  }

  void goToChatPage(Chat chat) {
    LNDNavigate.toChatPage(chat: chat);
  }
}
