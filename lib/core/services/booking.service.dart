import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dart_either/dart_either.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/message.model.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/constants/functions.constant.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';
import 'package:lend/utilities/enums/chat_status.enum.dart';
import 'package:lend/utilities/enums/message_type.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class BookingService {
  static final _db = FirebaseFirestore.instance;

  static Future<Either<bool, String>> acceptBooking(Booking booking) async {
    const e1 = 'Selected booking does not exist';
    const e2 = 'This booking is no longer available for confirmation';
    try {
      await _db.runTransaction((transaction) async {
        final chatsRef =
            _db
                .collection(LNDCollections.chats.name)
                .doc(booking.chatId)
                .collection(LNDCollections.messages.name)
                .doc();
        final ownerUserChatRef = _db
            .collection(LNDCollections.userChats.name)
            .doc(booking.asset?.owner?.uid)
            .collection(LNDCollections.chats.name)
            .doc(booking.chatId);
        final renterUserChatRef = _db
            .collection(LNDCollections.userChats.name)
            .doc(booking.renter?.uid)
            .collection(LNDCollections.chats.name)
            .doc(booking.chatId);

        final selectedRef = _db
            .collection(LNDCollections.assets.name)
            .doc(booking.asset?.id)
            .collection(LNDCollections.bookings.name)
            .doc(booking.id);

        final selectedUserRef = _db
            .collection(LNDCollections.users.name)
            .doc(booking.renter?.uid)
            .collection(LNDCollections.bookings.name)
            .doc(booking.id);

        // --- READ SELECTED ---
        final selectedSnap = await transaction.get(selectedRef);
        if (!selectedSnap.exists) throw e1;

        final selectedBooking = Booking.fromMap(selectedSnap.data()!);
        if (selectedBooking.status != BookingStatus.pending) {
          throw e2;
        }

        // --- GET ALL BOOKINGS ON SAME DATES ---
        final otherQuery =
            await _db
                .collection(LNDCollections.assets.name)
                .doc(booking.asset?.id)
                .collection(LNDCollections.bookings.name)
                .where('dates', arrayContainsAny: booking.dates)
                .get();

        // Build reference pairs (asset + user copy)
        final otherRefs =
            otherQuery.docs
                // exclude selected
                .where((doc) => doc.id != booking.id)
                .map((doc) {
                  final data = doc.data();
                  final bookingData = Booking.fromMap(data);
                  final renterId = bookingData.renter?.uid;

                  return (
                    assetRef: doc.reference,
                    userRef: _db
                        .collection(LNDCollections.users.name)
                        .doc(renterId)
                        .collection(LNDCollections.bookings.name)
                        .doc(doc.id),
                    data: data,
                  );
                })
                .toList();

        // --- WRITE PHASE ---

        // Confirm selected
        transaction.update(selectedRef, {
          'status': BookingStatus.confirmed.label,
        });
        transaction.update(selectedUserRef, {
          'status': BookingStatus.confirmed.label,
        });

        // Decline others still pending
        for (final ref in otherRefs) {
          final otherBooking = Booking.fromMap(ref.data);
          final chatRef = _db
              .collection(LNDCollections.userChats.name)
              .doc(otherBooking.renter?.uid)
              .collection(LNDCollections.chats.name)
              .doc(otherBooking.chatId);

          if (otherBooking.status == BookingStatus.pending) {
            transaction.update(ref.assetRef, {
              'status': BookingStatus.declined.label,
            });
            transaction.update(ref.userRef, {
              'status': BookingStatus.declined.label,
            });
            transaction.update(chatRef, {'status': ChatStatus.archived.label});
          }
        }

        transaction.set(
          chatsRef,
          Message(
            id: chatsRef.id,
            text:
                'Booking Confirmed!\n\nYou may now view the complete '
                'information of the owner details by clicking the information '
                'button above.',
            senderId: '',
            createdAt: Timestamp.now(),
            type: MessageType.system,
          ).toMap(),
        );
        transaction.update(ownerUserChatRef, Chat(hasRead: false).toMap());
        transaction.update(renterUserChatRef, Chat(hasRead: false).toMap());
      });

      // Generate handover and return tokens for QR
      await _makeToken(
        userId: booking.renter?.uid ?? '',
        assetId: booking.asset?.id ?? '',
        bookingId: booking.id ?? '',
      );

      return const Left(true);
    } catch (e) {
      LNDLogger.e(e.toString(), error: e, stackTrace: StackTrace.current);

      if (e == e1 || e == e2) {
        return Right(e.toString());
      }
      return Right(e.toString());
    }
  }

  static Future<Map<String, dynamic>?> _makeToken({
    required String userId,
    required String assetId,
    required String bookingId,
  }) async {
    try {
      // FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);
      final callable = FirebaseFunctions.instance.httpsCallable(
        LNDFunctions.makeToken,
      );

      final result = await callable.call({
        'userId': userId,
        'assetId': assetId,
        'bookingId': bookingId,
      });

      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      LNDLogger.e(e.message ?? '', stackTrace: StackTrace.current);
    } catch (e) {
      LNDLogger.e(e.toString(), stackTrace: StackTrace.current);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> markBooking({
    required String token,
  }) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        LNDFunctions.verifyAndMark,
      );

      final result = await callable.call({'token': token});

      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      LNDLogger.e(e.details, error: e, stackTrace: StackTrace.current);
    } catch (e) {
      LNDLogger.e(e.toString(), error: e, stackTrace: StackTrace.current);
    }
    return null;
  }
}
