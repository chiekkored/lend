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
import 'package:lend/core/models/simple_asset.model.dart';
import 'package:lend/core/models/user_chat.model.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
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

  final RxList<DateTime> _selectedDates = <DateTime>[].obs;
  List<DateTime> get selectedDates => _selectedDates;

  final RxInt _totalPrice = 0.obs;
  int get totalPrice => _totalPrice.value;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 13,
  );

  @override
  void onInit() {
    if (asset?.description == null) {
      getAsset();
    }

    super.onInit();
  }

  @override
  void onClose() {
    _asset.close();
    markers.close();
    circles.close();

    _mapController.close();
    _isUserLoading.close();
    _address.close();
    _selectedDates.close();

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
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
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

  void goToReservation() async {
    await LNDNavigate.toCalendarPage();
    _totalPrice.value = 0;
    _selectedDates.clear();
  }

  void onCalendarChanged(List<DateTime> dates) async {
    if (dates.first == dates.last) {
      _selectedDates.value = [dates.last];
      return;
    }

    if (asset?.availability?.any(
          (av) =>
              !av.date.toDate().isBefore(dates.first) &&
              !av.date.toDate().isAfter(dates.last),
        ) ??
        false) {
      _selectedDates.value = [dates.last];
    } else {
      _selectedDates.value = dates;
    }
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    if (selectedDates.length < 2 || selectedDates.first == selectedDates.last) {
      _totalPrice.value = 0;
    }

    int totalPrice = 0;
    DateTime startDate = selectedDates.first;
    DateTime endDate = selectedDates.last;
    int totalDays = endDate.difference(startDate).inDays;

    if (asset?.rates?.annually != null && totalDays >= 365) {
      totalPrice += asset?.rates?.annually ?? 0;
      int remainingDays = totalDays - 365;
      if (remainingDays > 0) {
        // For simplicity, we'll apply daily rate for extra days beyond a year
        if (asset?.rates?.daily != null) {
          totalPrice += remainingDays * (asset?.rates?.daily ?? 0);
        }
      }
      _totalPrice.value = totalPrice;
    }

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      if (asset?.rates?.monthly != null) {
        DateTime nextMonth = DateTime(
          currentDate.year,
          currentDate.month + 1,
          currentDate.day,
        );
        if (!nextMonth.isAfter(endDate)) {
          totalPrice += asset?.rates?.monthly ?? 0;
          currentDate = nextMonth;
          continue;
        }
      }

      if (asset?.rates?.weekly != null) {
        DateTime nextWeek = currentDate.add(const Duration(days: 7));
        if (!nextWeek.isAfter(endDate)) {
          totalPrice += asset?.rates?.weekly ?? 0;
          currentDate = nextWeek;
          continue;
        }
      }

      if (asset?.rates?.daily != null) {
        totalPrice += asset?.rates?.daily ?? 0;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    _totalPrice.value = totalPrice;
  }

  void bookAsset() async {
    if (selectedDates.length < 2 || selectedDates.first == selectedDates.last) {
      return;
    }
    try {
      if (asset?.owner == null) {
        LNDSnackbar.showError('Something went wrong. Please try again later.');
        return;
      }

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
      final assetsCollection = FirebaseFirestore.instance.collection(
        LNDCollections.assets.name,
      );
      final bookingsCollection = FirebaseFirestore.instance
          .collection(LNDCollections.users.name)
          .doc(AuthController.instance.uid)
          .collection(LNDCollections.bookings.name);

      final newAvailability = {
        'availability': FieldValue.arrayUnion(
          dates.map((d) => d.toMap()).toList(),
        ),
      };

      // Update the asset's availability
      batch.update(assetsCollection.doc(asset?.id), newAvailability);

      // Create a new booking
      batch.set(
        bookingsCollection.doc(),
        Booking(
          asset: SimpleAsset(
            id: asset?.id ?? '',
            ownerId: asset?.ownerId,
            title: asset?.title,
            images: asset?.images,
            bookings: dates,
            category: asset?.category,
            createdAt: Timestamp.now(),
            status: asset?.status,
          ),
          dates: dates.map((d) => d.date).toList(),
          createdAt: Timestamp.now(),
          payment: Payment(method: 'debit', transactionId: '123456'),
          renterId: AuthController.instance.uid,
          status: BookingStatus.confirmed.label,
          totalPrice: totalPrice,
        ).toMap(),
      );

      // Create a new chat
      await _createMessage(dates);

      await batch.commit();

      await refreshAsset();
      await MyRentalsController.instance.getMyRentals();

      LNDLoading.hide();
      NavigationController.instance.changeTab(1);
      Get.until((page) => page.isFirst);
    } catch (e, st) {
      LNDLoading.hide();
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  Future<void> _createMessage(List<Availability> bookedDates) async {
    final batch = FirebaseFirestore.instance.batch();
    final userChatsCollection = FirebaseFirestore.instance.collection(
      LNDCollections.userChats.name,
    );
    final chatsCollection = FirebaseFirestore.instance.collection(
      LNDCollections.chats.name,
    );
    const bookingString = 'Booking Confirmed';

    // Create a new message

    // Collection: chats/{randomId}
    final chatsDoc = chatsCollection.doc();
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
    batch.set(
      userChatsSubChatDoc,
      Chat(
        id: chatsDoc.id,
        chatId: chatsDoc.id,
        asset: SimpleAsset.fromMap(asset!.toMap()),
        participants: [asset!.owner!, ProfileController.instance.simpleUser],
        lastMessage: bookingString,
        lastMessageDate: Timestamp.now(),
        lastMessageSenderId: asset!.ownerId,
        bookings: bookedDates,
        createdAt: Timestamp.now(),
        hasRead: false,
      ).toMap(),
    );

    // For asset owner
    // Collection: userChats/{userId}
    final assetOwnerDoc = userChatsCollection.doc(asset!.ownerId);
    batch.set(assetOwnerDoc, UserChatRoot(isOnline: true).toMap());
    // Collection: userChats/{userId}/chats
    final assetOwnerSubChatDoc = assetOwnerDoc
        .collection(LNDCollections.chats.name)
        .doc(chatsDoc.id);
    batch.set(
      assetOwnerSubChatDoc,
      Chat(
        id: chatsDoc.id,
        chatId: chatsDoc.id,
        asset: SimpleAsset.fromMap(asset!.toMap()),
        participants: [asset!.owner!, ProfileController.instance.simpleUser],
        lastMessage: bookingString,
        lastMessageDate: Timestamp.now(),
        lastMessageSenderId: asset!.ownerId,
        bookings: bookedDates,
        createdAt: Timestamp.now(),
        hasRead: false,
      ).toMap(),
    );

    await batch.commit();
  }

  bool checkAvailability(DateTime date) {
    // Make last day available
    if ((asset?.availability?.isNotEmpty ?? false) &&
        date == asset?.availability?.last.date.toDate()) {
      return true;
    }

    return !(asset?.availability?.any((av) => av.date.toDate() == date) ??
        false);
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
