import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/file.model.dart';
import 'package:lend/core/models/location.model.dart';
import 'package:lend/core/models/rates.model.dart';
import 'package:lend/core/models/simple_asset.model.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/home/home.controller.dart';
import 'package:lend/presentation/controllers/location_picker/location_picker.controller.dart';
import 'package:lend/presentation/controllers/my_rentals/my_rentals.controller.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/categories.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

import 'package:lend/core/mixins/textfields.mixin.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/pages/post_listing/widgets/availability.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/edit_rates.widget.dart';
import 'package:lend/utilities/enums/availability.enum.dart';
import 'package:lend/utilities/extensions/string.extension.dart';
import 'package:permission_handler/permission_handler.dart';

class PostListingController extends GetxController with TextFieldsMixin {
  static final PostListingController instance =
      Get.find<PostListingController>();

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final dailyPriceController = TextEditingController();
  final weeklyPriceController = TextEditingController();
  final monthlyPriceController = TextEditingController();
  final annualPriceController = TextEditingController();
  final locationController = TextEditingController();
  final inclusionController = TextEditingController();

  final RxString weeklyPrice = ''.obs;
  final RxString monthlyPrice = ''.obs;
  final RxString annualPrice = ''.obs;

  final RxBool showCoverPhotosError = false.obs;
  final RxBool useRegisteredAddress = true.obs;
  final RxBool isCustomPrice = true.obs;
  final RxBool isShowcaseUploading = false.obs;

  final RxList<Rx<FileModel>> coverPhotos = <Rx<FileModel>>[].obs;
  final RxList<Rx<FileModel>> showcasePhotos = <Rx<FileModel>>[].obs;

  final RxList<String> inclusions = <String>[].obs;
  final Rx<Availability> availability = Availability.available.obs;

  Location? _location;

  @override
  void onInit() {
    // Listen to daily price change and multiply by each prices
    dailyPriceController.addListener(_calculatePrices);
    weeklyPriceController.addListener(_weeklyPriceListener);
    monthlyPriceController.addListener(_monthlyPriceListener);
    annualPriceController.addListener(_annualPriceListener);

    ever(isCustomPrice, (_) => _calculatePrices());

    // Also watch for additions to the list, and bind listeners to new items
    ever(showcasePhotos, (_) {
      for (final rxFile in showcasePhotos) {
        ever<FileModel>(rxFile, (_) => _checkAllUploadsComplete());
      }
    });

    super.onInit();
  }

  void _checkAllUploadsComplete() {
    if (showcasePhotos.every(
      (rxFile) =>
          rxFile.value.progress == 1.0 &&
          (rxFile.value.storagePath != null &&
              rxFile.value.storagePath!.isNotEmpty),
    )) {
      isShowcaseUploading.value = false;
    } else {
      isShowcaseUploading.value = true;
    }
  }

  @override
  void onClose() {
    availability.close();
    isCustomPrice.close();
    useRegisteredAddress.close();
    inclusions.close();
    for (var photoFile in coverPhotos) {
      photoFile.close();
    }
    for (var showcaseFile in showcasePhotos) {
      showcaseFile.close();
    }
    showcasePhotos.close();
    isShowcaseUploading.close();
    coverPhotos.close();
    showCoverPhotosError.close();

    inclusionController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    dailyPriceController.dispose();
    weeklyPriceController.dispose();
    monthlyPriceController.dispose();
    annualPriceController.dispose();
    locationController.dispose();

    weeklyPrice.close();
    monthlyPrice.close();
    annualPrice.close();
    // Loop remove listeners
    for (var controller in [
      dailyPriceController,
      weeklyPriceController,
      monthlyPriceController,
      annualPriceController,
    ]) {
      controller.removeListener(_calculatePrices);
    }

    super.onClose();
  }

  void _monthlyPriceListener() {
    monthlyPrice.value = monthlyPriceController.text;
  }

  void _weeklyPriceListener() {
    weeklyPrice.value = weeklyPriceController.text;
  }

  void _annualPriceListener() {
    annualPrice.value = annualPriceController.text;
  }

  void _calculatePrices() {
    if (isCustomPrice.isTrue) {
      final dailyPrice =
          double.tryParse(dailyPriceController.text.replaceAll(',', '')) ?? 0;
      final decimalCount = dailyPriceController.text.contains('.') ? 2 : 0;

      calculatePrice(int multiplier) =>
          dailyPrice == 0
              ? ''
              : (dailyPrice * multiplier)
                  .toStringAsFixed(decimalCount)
                  .toMoney();

      weeklyPriceController.text = calculatePrice(7);
      monthlyPriceController.text = calculatePrice(30);
      annualPriceController.text = calculatePrice(365);
    }
  }

  void showEditPrices() {
    LNDShow.bottomSheet(const EditRates());
  }

  void showAddInclusions(BuildContext context) {
    inclusionController.clear();

    LNDNavigate.showAddInclusions(context: context);
  }

  void showAddShowcase(BuildContext context) {
    LNDNavigate.toAddShowcase();
  }

  void showLocationPicker(BuildContext context) async {
    final result = await LNDNavigate.showLocationPicker(
      context: context,
      location: LocationCallbackModel(
        address: locationController.text,
        useSpecificLocation: _location?.useSpecificLocation ?? true,
        latLng:
            _location?.latLng == null
                ? null
                : LatLng(
                  _location?.latLng?.latitude ?? 0.0,
                  _location?.latLng?.longitude ?? 0.0,
                ),
      ),
    );

    if (result != null) {
      locationController.text = result.address;
      _location = Location(
        description: result.address,
        useSpecificLocation: result.useSpecificLocation,
        latLng:
            result.latLng == null
                ? null
                : GeoPoint(
                  result.latLng?.latitude ?? 0.0,
                  result.latLng?.longitude ?? 0.0,
                ),
      );
    }
  }

  Future<bool> _checkPhotosPermission() async {
    // Check for access premission
    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (hasAccess) {
        final result = await Gal.requestAccess();
        if (result) {
          LNDShow.alertDialog(
            title: 'Camera Access Denied',
            content:
                'You have previously denied camera access. Please go to Settings '
                'to enable it.',
            cancelText: 'Close',
            confirmText: 'Settings',
            onConfirm: () async {
              final canOpen = await openAppSettings();

              if (!canOpen) {
                LNDSnackbar.showWarning(
                  "Unable to open app settings. Open phone's settings and enable "
                  'camera access manually.',
                );
              }
            },
          );
          return false;
        }
      }
      return true;
    } on GalException catch (e) {
      LNDLogger.e(e.type.message, error: e, stackTrace: e.stackTrace);
      return false;
    }
  }

  void addShowcasePhotos() async {
    debugPrint('showcasePhotos.length: ${10 - showcasePhotos.length}');
    final photos = await _openPhotos(limit: 10 - showcasePhotos.length);

    if (photos.isNotEmpty) {
      // Add images to list for display and upload to firebase storage
      showcasePhotos.addAll(
        photos.map((e) => Rx(FileModel(file: e, progress: 0.0))),
      );

      // Only upload files that haven't been uploaded yet and aren't currently uploading
      final newFiles =
          showcasePhotos
              .where(
                (photoFile) =>
                    (photoFile.value.storagePath == null ||
                        photoFile.value.storagePath!.isEmpty) &&
                    photoFile.value.progress == 0.0,
              )
              .toList();

      _uploadPhotos(files: newFiles);
    }
  }

  void addCoverPhotos() async {
    final photos = await _openPhotos(limit: 6 - coverPhotos.length);

    if (photos.isNotEmpty) {
      // Add images to list for display and upload to firebase storage
      coverPhotos.addAll(
        photos.map((e) => Rx(FileModel(file: e, progress: 0.0))),
      );

      // Only upload files that haven't been uploaded yet and aren't currently uploading
      final newFiles =
          coverPhotos
              .where(
                (photoFile) =>
                    (photoFile.value.storagePath == null ||
                        photoFile.value.storagePath!.isEmpty) &&
                    photoFile.value.progress == 0.0,
              )
              .toList();

      _uploadPhotos(files: newFiles);
    }
  }

  Future<List<XFile>> _openPhotos({required int limit}) async {
    return await ImagePicker().pickMultiImage(limit: limit);
  }

  void _uploadPhotos({required List<Rx<FileModel>> files}) async {
    try {
      // Create a list to hold all upload futures
      final List<Future> uploadFutures = [];

      // Start all uploads in parallel
      for (var photoFile in files) {
        if (photoFile.value.file != null) {
          final ref = FirebaseStorage.instance.ref().child(
            'images/${photoFile.value.file?.name}',
          );

          final uploadTask = ref.putFile(File(photoFile.value.file!.path));
          uploadTask.snapshotEvents.listen((event) {
            photoFile.value.progress =
                event.bytesTransferred / event.totalBytes;
            photoFile.refresh();
          });

          // Add the future to our list without awaiting it
          uploadFutures.add(
            uploadTask
                .whenComplete(() async {
                  final downloadUrl = await ref.getDownloadURL();
                  photoFile.value.storagePath = downloadUrl;
                  photoFile.refresh();
                })
                .catchError((e) {
                  LNDSnackbar.showWarning(
                    'Something went wrong while uploading',
                  );
                  return e;
                }),
          );
        }
      }
    } catch (e) {
      LNDSnackbar.showWarning(
        'Something went wrong while uploading the photo/s',
      );
    }
  }

  void openCamera() async {
    // Check for access premission
    if (!await _checkPhotosPermission()) {
      return;
    }

    // Shot and Save
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      // await Gal.putImage(image.path);
    }
  }

  void removeCoverPhoto(int index) {
    if (coverPhotos.isNotEmpty) {
      coverPhotos.removeAt(index);
    }
  }

  void removeShowcasePhoto(int index) {
    if (showcasePhotos.isNotEmpty) {
      showcasePhotos.removeAt(index);
    }
  }

  void showCategories(BuildContext context) async {
    final result = await LNDNavigate.showCategories(
      context: context,
      category:
          categoryController.text.isNotEmpty
              ? Categories.values
                  .where((element) => element.label == categoryController.text)
                  .first
              : null,
    );
    if (result != null) {
      categoryController.text = result.label;
    }
  }

  void showAvailability() {
    LNDShow.bottomSheet(const AvailabilityW());
  }

  void addInclusion() {
    if (inclusionController.text.isNotEmpty) {
      inclusions.add((inclusionController.text.capitalizeFirst?.trim() ?? ''));
      inclusionController.clear();
    }
  }

  void removeInclusion(int index) {
    inclusions.removeAt(index);
  }

  void onChangedAvailability(Availability? value) {
    if (value == null) return;

    availability.value = value;
  }

  void next() async {
    try {
      // await AssetDummyData.uploadDummyAssets();
      // return;

      // Check all validations together
      bool hasValidationErrors = false;

      if (formKey.currentState?.validate() == false) {
        hasValidationErrors = true;
      }

      // Check cover photos - required and must be fully uploaded
      if (coverPhotos.isEmpty) {
        showCoverPhotosError.value = true;
        hasValidationErrors = true;
      } else {
        showCoverPhotosError.value = false;
        final allCoverPhotosUploaded = coverPhotos.every(
          (photoFile) =>
              photoFile.value.storagePath != null &&
              photoFile.value.storagePath!.isNotEmpty,
        );

        if (!allCoverPhotosUploaded) {
          LNDSnackbar.showWarning('Please wait for all cover photos to upload');
          hasValidationErrors = true;
        }
      }

      // Check showcase photos (if any) - must be fully uploaded
      if (showcasePhotos.isNotEmpty) {
        final allShowcasePhotosUploaded = showcasePhotos.every(
          (photoFile) =>
              photoFile.value.storagePath != null &&
              photoFile.value.storagePath!.isNotEmpty,
        );

        if (!allShowcasePhotosUploaded) {
          LNDSnackbar.showWarning(
            'Please wait for all showcase photos to upload.',
          );
          hasValidationErrors = true;
        }
      }

      // Stop if any validation errors were found
      if (hasValidationErrors) {
        return;
      }

      LNDLoading.show();

      final batch = FirebaseFirestore.instance.batch();
      final assetDoc =
          FirebaseFirestore.instance
              .collection(LNDCollections.assets.name)
              .doc();
      final userAssetDoc = FirebaseFirestore.instance
          .collection(LNDCollections.users.name)
          .doc(AuthController.instance.uid)
          .collection(LNDCollections.assets.name)
          .doc(assetDoc.id);

      final userAssetArgs =
          SimpleAsset(
            id: assetDoc.id,
            title: titleController.text.trim(),
            images: coverPhotos.map((e) => e.value.storagePath ?? '').toList(),
            category: categoryController.text,
            ownerId: AuthController.instance.uid ?? '',
            createdAt: Timestamp.now(),
            status: availability.value.label,
          ).toMap();

      final assetArgs =
          AddAsset(
            id: assetDoc.id,
            ownerId: AuthController.instance.uid ?? '',
            owner: ProfileController.instance.simpleUser,
            title: titleController.text.trim(),
            description: descriptionController.text,
            category: categoryController.text,
            rates: Rates(
              daily: int.tryParse(dailyPriceController.text.toNumber()),
            ),
            location:
                useRegisteredAddress.value
                    ? ProfileController.instance.user?.location
                    : _location,
            images: coverPhotos.map((e) => e.value.storagePath ?? '').toList(),
            showcase:
                showcasePhotos.map((e) => e.value.storagePath ?? '').toList(),
            inclusions: inclusions.toList(),
            createdAt: Timestamp.now(),
            status: availability.value.label,
          ).toMap();

      // Add asset to assets collection
      batch.set(assetDoc, assetArgs);

      // Add asset to user's assets collection
      batch.set(userAssetDoc, userAssetArgs);

      await batch.commit();

      LNDLoading.hide();
      HomeController.instance.getAssets();
      MyRentalsController.instance.getMyRentals();
      Get.back();
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }
}
