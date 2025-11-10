import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/message.model.dart';
import 'package:lend/core/models/simple_user.model.dart';
import 'package:lend/core/services/booking.service.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/my_rentals/widgets/on_going_booking_view.widget.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/message_type.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find<ChatController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final chat = Get.arguments as Chat;

  final TextEditingController textController = TextEditingController();

  final Rx<Booking?> _booking = Rx<Booking?>(null);
  Booking? get booking => _booking.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  SimpleUserModel? get recepientUser => chat.participants?.firstWhereOrNull(
    (user) => user.uid != AuthController.instance.uid,
  );

  @override
  void onClose() {
    _booking.close();
    textController.dispose();
    _isLoading.close();
    super.onClose();
  }

  @override
  void onReady() {
    _getBooking();

    super.onReady();
  }

  Future<void> _getBooking() async {
    final bookingDoc =
        await _firestore
            .collection(LNDCollections.users.name)
            .doc(chat.renterId)
            .collection(LNDCollections.bookings.name)
            .doc(chat.bookingId)
            .get();

    if (bookingDoc.exists) {
      final bookingData = bookingDoc.data();

      if (bookingData != null) {
        _booking.value = Booking.fromMap(bookingData);
      }
    }
  }

  void sendMessage() {
    try {
      if (textController.text.isNotEmpty) {
        final textMessage = textController.text.trim();
        textController.clear();

        final batch = _firestore.batch();

        final messageCollection = _firestore
            .collection(LNDCollections.chats.name)
            .doc(chat.chatId)
            .collection(LNDCollections.messages.name);

        // Update the sender's chat root
        final userChatsCollection = _firestore
            .collection(LNDCollections.userChats.name)
            .doc(AuthController.instance.uid)
            .collection(LNDCollections.chats.name)
            .doc(chat.id);
        // Update the recepient's chat root
        final recepientChatsCollection = _firestore
            .collection(LNDCollections.userChats.name)
            .doc(recepientUser?.uid)
            .collection(LNDCollections.chats.name)
            .doc(chat.id);

        final message = Message(
          id: messageCollection.doc().id,
          text: textMessage,
          senderId: AuthController.instance.uid,
          createdAt: Timestamp.now(),
          type: MessageType.text,
        );

        final chatDoc = Chat(
          lastMessage: textMessage,
          lastMessageDate: Timestamp.now(),
          lastMessageSenderId: AuthController.instance.uid,
          hasRead: false,
        );

        batch.set(messageCollection.doc(message.id), message.toMap());
        batch.update(userChatsCollection, chatDoc.toMap());
        batch.update(recepientChatsCollection, chatDoc.toMap());

        batch.commit().catchError((e, st) {
          LNDLogger.e(
            'Error sending message',
            error: e,
            stackTrace: StackTrace.current,
          );
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

  void onTapAccept() async {
    if (booking == null) return;

    final result = await LNDShow.alertDialog<bool?>(
      title: 'Accept this booking?',
      content:
          'Are you sure you want to accept this booking request? '
          'All other pending bookings for the same day will be declined.',
    );

    if (result == null || !result) return;

    try {
      LNDLoading.show();

      final result = await BookingService.acceptBooking(booking!);

      result.fold(
        ifLeft: (response) async {
          await _getBooking();
          LNDLoading.hide();
          // Get.back();
        },
        ifRight: (error) {
          throw error;
        },
      );
    } catch (e) {
      LNDLoading.hide();
      LNDSnackbar.showError('Something went wrong');
    }
  }

  void goToScanQR() {
    if (booking != null) {
      LNDNavigate.toScanQRPage();
    }
  }

  void goToQRView() {
    if (booking != null) {
      LNDNavigate.toQRViewPage(qrToken: booking?.tokens?.returnToken ?? '');
    }
  }

  void goToAsset() {
    if (chat.asset != null) {
      LNDNavigate.toAssetPage(args: Asset.fromMap(chat.asset!.toMap()));
    }
  }

  void viewBookingInfo() {
    if (booking == null) return;

    LNDShow.bottomSheet(OnGoingBookingW(booking: booking!));
  }
}
