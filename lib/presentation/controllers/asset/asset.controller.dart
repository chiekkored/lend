import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/availability.model.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/models/chat_root.model.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/message.model.dart';
import 'package:lend/core/models/rates.model.dart';
import 'package:lend/core/models/simple_asset.model.dart';
import 'package:lend/core/models/user_chat.model.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/calendar_bookings/calendar_bookings.controller.dart';
import 'package:lend/presentation/controllers/calendar_picker/calendar_picker.controller.dart';
import 'package:lend/presentation/controllers/home/home.controller.dart';
import 'package:lend/presentation/controllers/my_rentals/my_rentals.controller.dart';
import 'package:lend/presentation/controllers/navigation/navigation.controller.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/presentation/pages/asset/widgets/all_prices.widget.dart';
import 'package:lend/presentation/pages/photo_view/photo_view.page.dart';
import 'package:lend/presentation/pages/product_showcase/product_showcase.page.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';
import 'package:lend/utilities/enums/chat_type.enum.dart';
import 'package:lend/utilities/enums/message_type.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class AssetController extends GetxController {
  static final instance = Get.find<AssetController>();

  final Rx<Asset?> _asset = Rx<Asset?>(Get.arguments as Asset?);
  Asset? get asset => _asset.value;

  final RxList<Booking> _bookingDates = <Booking>[].obs;
  List<Booking> get bookingDates => _bookingDates;
  List<Booking> get confirmedBookingDates =>
      _bookingDates
          .where((date) => date.status == BookingStatus.confirmed)
          .toList();
  List<Booking> get pendingBookingDates =>
      _bookingDates
          .where((date) => date.status == BookingStatus.pending)
          .toList();

  final RxBool _isAssetLoading = false.obs;
  bool get isAssetLoading => _isAssetLoading.value;

  final RxBool _isUserLoading = false.obs;
  bool get isUserLoading => _isUserLoading.value;

  final _mapController = Rxn<GoogleMapController>();
  GoogleMapController? get mapController => _mapController.value;

  final circles = <Circle>{}.obs;
  final markers = <Marker>{}.obs;

  final RxString _address = ''.obs;
  String get address => _address.value;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 13,
  );

  @override
  void onReady() async {
    if (asset?.description == null) {
      await getAsset();
    }
    getBookings();

    super.onReady();
  }

  @override
  void onClose() {
    _asset.close();
    markers.close();
    circles.close();

    _mapController.close();
    _isUserLoading.close();
    _address.close();

    super.onClose();
  }

  /// Refreshes a single asset from Firestore
  /// and updates the HomeController with the new asset data.
  /// This method is useful for updating the asset details
  /// after a booking is made or any other changes.
  Future<void> refreshAsset() async {
    try {
      final assetsCollection = FirebaseFirestore.instance.collection(
        LNDCollections.assets.name,
      );

      final result = await assetsCollection.doc(asset?.id).get();

      if (result.exists) {
        HomeController.instance.updateAsset(Asset.fromMap(result.data()!));
      }
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  /// Fetches the asset details from Firestore
  Future<void> getAsset() async {
    try {
      _isAssetLoading.value = true;
      final assetsCollection = FirebaseFirestore.instance.collection(
        LNDCollections.assets.name,
      );

      final result = await assetsCollection.doc(asset?.id).get();

      if (result.exists) {
        _asset.value = Asset.fromMap(result.data()!);
        _isAssetLoading.value = false;
      } else {
        LNDSnackbar.showError('Product unavailable');
        Get.back();
      }
    } catch (e, st) {
      _isAssetLoading.value = false;
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
      LNDSnackbar.showError('Product unavailable');
      Get.back();
    }
  }

  /// Fetches the asset details from Firestore
  Future<void> getBookings() async {
    try {
      final bookingDocs = FirebaseFirestore.instance
          .collection(LNDCollections.assets.name)
          .doc(asset?.id)
          .collection(LNDCollections.bookings.name);
      // .where('status', isEqualTo: BookingStatus.confirmed.label);

      final result = await bookingDocs.get();

      _bookingDates.value =
          result.docs.map((doc) => Booking.fromMap(doc.data())).toList();
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
      LNDSnackbar.showError('Something went wrong');
      Get.back();
    }
  }

  void onMapCreated(GoogleMapController mapCtrl) {
    _mapController.value = mapCtrl;
    cameraPosition = CameraPosition(
      target: LatLng(
        asset?.location?.latLng?.latitude ?? 0.0,
        asset?.location?.latLng?.longitude ?? 0.0,
      ),
      zoom: 13,
    );

    if (asset?.location?.useSpecificLocation == true) {
      mapCtrl.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      markers.add(
        Marker(
          markerId: const MarkerId('selected-location'),
          position: cameraPosition.target,
        ),
      );
    } else {
      const radius = 500.0;
      final randomLocation = _getRandomLocationWithinRadius(
        cameraPosition.target,
        radius,
      );
      mapCtrl.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: randomLocation, zoom: 13),
        ),
      );
      circles.add(
        Circle(
          circleId: const CircleId('selected-location'),
          center: randomLocation,
          radius: radius,
          fillColor: Colors.blue.withValues(alpha: 0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
    }

    // _getAddressFromLatLng(cameraPosition.target);
  }

  /// Generates a random LatLng within the specified radius (in meters) from the center point
  LatLng _getRandomLocationWithinRadius(LatLng center, double radius) {
    // Generate a random distance from center (0 to radius)
    final random = math.Random();
    final randomRadius = radius * math.sqrt(random.nextDouble());

    // Generate random angle
    final randomAngle = random.nextDouble() * 2 * math.pi;

    // Calculate offset in meters
    final xOffset = randomRadius * math.cos(randomAngle);
    final yOffset = randomRadius * math.sin(randomAngle);

    // Convert meter offsets to latitude/longitude offsets
    // 111,111 meters is approximately 1 degree of latitude
    // Longitude degrees vary based on latitude
    final latOffset = yOffset / 111111;
    final lngOffset =
        xOffset / (111111 * math.cos(center.latitude * math.pi / 180));

    return LatLng(center.latitude + latOffset, center.longitude + lngOffset);
  }

  void openAllPrices() async {
    LNDShow.bottomSheet(const AssetAllPricesSheet(), enableDrag: false);
  }

  void goToCalendarPicker() async {
    final datesOnly =
        confirmedBookingDates
            .where((booking) => booking.dates?.isNotEmpty ?? false)
            .expand((booking) => booking.dates!)
            .map((timestamp) => timestamp.toDate())
            .toSet()
            .toList();
    await LNDNavigate.toCalendarPickerPage(
      args: CalendarPickerPageArgs(
        isReadOnly: false,
        dates: datesOnly,
        rates: asset?.rates ?? Rates(),
        onSubmit:
            (selectedDates, totalPrice) => bookAsset(selectedDates, totalPrice),
      ),
    );
  }

  void goToCalendarBookings() async {
    await LNDNavigate.toCalendarBookingsPage(
      args: CalendarBookingsPageArgs(
        isReadOnly: true,
        bookings: _bookingDates,
        rates: Rates(),
      ),
    );
  }

  void bookAsset(List<DateTime> selectedDates, int totalPrice) async {
    if (selectedDates.length < 2 || selectedDates.first == selectedDates.last) {
      return;
    }
    try {
      if (asset == null) throw 'Asset does not exist';

      if (asset?.owner == null) throw 'Asset owner does not exist';

      if (asset?.id == null) throw 'Asset ID does not exist';

      LNDLoading.show();

      final List<Availability> dates = [];
      final start = selectedDates.first;
      final end = selectedDates.last;
      DateTime currentDate = start;

      while (!currentDate.isAfter(end)) {
        dates.add(
          Availability(
            date: Timestamp.fromDate(currentDate),
            userId: ProfileController.instance.user?.uid,
            firstName: ProfileController.instance.user?.firstName,
            lastName: ProfileController.instance.user?.lastName,
          ),
        );
        currentDate = currentDate.add(const Duration(days: 1));
      }

      final batch = FirebaseFirestore.instance.batch();
      // final assetsCollection = FirebaseFirestore.instance.collection(
      //   LNDCollections.assets.name,
      // );

      final userBookingsCollection = FirebaseFirestore.instance
          .collection(LNDCollections.users.name)
          .doc(AuthController.instance.uid)
          .collection(LNDCollections.bookings.name);

      final userBookingDoc = userBookingsCollection.doc();

      final assetBookingsDoc = FirebaseFirestore.instance
          .collection(LNDCollections.assets.name)
          .doc(asset!.id)
          .collection(LNDCollections.bookings.name)
          .doc(userBookingDoc.id);

      // final newAvailability = {
      //   'availability': FieldValue.arrayUnion(
      //     dates.map((d) => d.toMap()).toList(),
      //   ),
      // };

      // Update the asset's availability
      // batch.update(assetsCollection.doc(asset?.id), newAvailability);

      // Create a new booking
      // For future: Separate status to another collection for source of truth

      final chatsCollection = FirebaseFirestore.instance.collection(
        LNDCollections.chats.name,
      );

      final chatsDoc = chatsCollection.doc();

      final booking =
          AddBooking(
            id: userBookingDoc.id,
            chatId: chatsDoc.id,
            asset: AddSimpleAsset.fromMap(asset!.toMap()),
            dates: dates.map((d) => d.date).toList(),
            createdAt: Timestamp.now(),
            payment: null,
            renter: ProfileController.instance.simpleUser,
            status: BookingStatus.pending.label,
            totalPrice: totalPrice,
          ).toMap();

      batch.set(userBookingDoc, booking);
      batch.set(assetBookingsDoc, booking);

      // Create a new chat
      final newBatch = await _createMessage(
        batch,
        userBookingDoc.id,
        chatsDoc,
        dates,
      );

      await newBatch.commit();

      await refreshAsset();
      await MyRentalsController.instance.getMyRentals();

      LNDLoading.hide();
      NavigationController.instance.changeTab(1);
      Get.until((page) => page.isFirst);
    } catch (e, st) {
      LNDLoading.hide();
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
      LNDSnackbar.showError('Something went wrong. Please try again later.');
    }
  }

  Future<WriteBatch> _createMessage(
    WriteBatch batch,
    String bookingDocId,
    DocumentReference chatsDoc,
    List<Availability> bookedDates,
  ) async {
    try {
      final userChatsCollection = FirebaseFirestore.instance.collection(
        LNDCollections.userChats.name,
      );
      const bookingString = 'Booking Confirmed';

      // Create a new message

      // Collection: chats/{randomId}
      batch.set(chatsDoc, ChatRoot(chatType: ChatType.private.label).toMap());

      // Collection: chats/{randomId}/messages
      final chatMessagesDoc =
          chatsDoc.collection(LNDCollections.messages.name).doc();
      batch.set(
        chatMessagesDoc,
        Message(
          id: chatMessagesDoc.id,
          text: bookingString,
          senderId: asset!.ownerId,
          createdAt: Timestamp.now(),
          type: MessageType.text.label,
        ).toMap(),
      );

      // Create a new chat
      // For current user
      // Collection: userChats/{userId}
      final userChatsDoc = userChatsCollection.doc(AuthController.instance.uid);
      batch.set(userChatsDoc, UserChatRoot(isOnline: true).toMap());

      // Collection: userChats/{userId}/chats
      final userChatsSubChatDoc = userChatsDoc
          .collection(LNDCollections.chats.name)
          .doc(chatsDoc.id);
      final chatObject = Chat(
        id: chatsDoc.id,
        chatId: chatsDoc.id,
        bookingId: bookingDocId,
        renterId: AuthController.instance.uid,
        asset: SimpleAsset.fromMap(asset!.toMap()),
        participants: [asset!.owner!, ProfileController.instance.simpleUser],
        lastMessage: bookingString,
        lastMessageDate: Timestamp.now(),
        lastMessageSenderId: asset!.ownerId,
        createdAt: Timestamp.now(),
        hasRead: false,
      );
      batch.set(userChatsSubChatDoc, chatObject.toMap());

      // For asset owner
      // Collection: userChats/{userId}
      final assetOwnerDoc = userChatsCollection.doc(asset!.ownerId);
      batch.set(assetOwnerDoc, UserChatRoot(isOnline: true).toMap());
      // Collection: userChats/{userId}/chats
      final assetOwnerSubChatDoc = assetOwnerDoc
          .collection(LNDCollections.chats.name)
          .doc(chatsDoc.id);
      batch.set(assetOwnerSubChatDoc, chatObject.toMap());

      return batch;
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
      return batch;
    }
  }

  void onMapTap(LatLng position) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 13),
        ),
      );
    }
  }

  void onMapLongPress(LatLng position) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 13),
        ),
      );
    }
  }

  void addBookmark() async {
    if (AuthController.instance.isAuthenticated) return;
  }

  void openPhotoShowcase(int index) {
    LNDNavigate.toPhotoViewPage(
      args: PhotoViewArguments(
        images: asset?.showcase ?? [],
        intialIndex: index,
      ),
    );
  }

  void openPhotoAsset(int index) {
    LNDNavigate.toPhotoViewPage(
      args: PhotoViewArguments(images: asset?.images ?? [], intialIndex: index),
    );
  }

  void openSeeAllShowcase() {
    LNDNavigate.toProductShowcasePage(
      args: ProductShowcaseArguments(showcase: asset?.showcase ?? []),
    );
  }

  // Future<void> _getAddressFromLatLng(LatLng position) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );
  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks.first;
  //       _address.value =
  //           '${place.street}, ${place.locality}, ${place.isoCountryCode}';
  //     } else {
  //       _address.value = "No address found";
  //     }
  //   } catch (e, st) {
  //     _address.value = 'No address found';
  //     LNDLogger.e(e.toString(), error: e, stackTrace: st);
  //   }
  // }
}
