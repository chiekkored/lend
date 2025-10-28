import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_either/dart_either.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';
import 'package:lend/utilities/enums/chat_status.enum.dart';

class BookingService {
  static final _db = FirebaseFirestore.instance;

  static Future<Either<bool, String>> acceptBooking(Booking booking) async {
    const e1 = 'Selected booking does not exist';
    const e2 = 'This booking is no longer available for confirmation';
    try {
      await _db.runTransaction((transaction) async {
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
      });

      return const Left(true);
    } catch (e) {
      if (e == e1 || e == e2) {
        return Right(e.toString());
      }
      return const Right('Something went wrong');
    }
  }
}
