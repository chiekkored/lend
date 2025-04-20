import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/message.model.dart';
import 'package:lend/core/models/simple_user.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/message_type.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find<ChatController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final chat = Get.arguments as Chat;

  final TextEditingController textController = TextEditingController();

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
    _isLoading.close();
    super.onClose();
  }

  void cancelSubscriptions() {
    _messagesSubscription?.cancel();
  }

  void sendMessage() {
    try {
      if (textController.text.isNotEmpty) {
        final textMessage = textController.text.trim();
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

  void goToAsset() {
    if (chat.asset != null) {
      LNDNavigate.toAssetPage(args: Asset.fromMap(chat.asset!.toMap()));
    }
  }
}
