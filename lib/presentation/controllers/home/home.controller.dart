import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lend/core/mixins/scroll.mixin.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/location.model.dart';
import 'package:lend/core/models/rates.model.dart';
import 'package:lend/core/services/get_storage.service.dart';
import 'package:lend/presentation/pages/asset/asset.page.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/constants/get_storage.constant.dart';
import 'package:lend/utilities/enums/categories.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class HomeController extends GetxController with LNDScrollMixin {
  static final instance = Get.find<HomeController>();
  String get _cacheKey =>
      '${LNDStorageConstants.assets}_${selectedCategory.name}';

  final assetsCollection = FirebaseFirestore.instance.collection(
    LNDCollections.assets.name,
  );

  final Rx<Categories> _selectedCategory = Rx(Categories.all);
  final RxBool _isLoading = false.obs;

  final RxList<Asset> _assets = <Asset>[].obs;

  bool get isLoading => _isLoading.value;
  Categories get selectedCategory => _selectedCategory.value;
  List<Asset> get assets => _assets;

  @override
  void onReady() {
    getAssets();

    super.onReady();
  }

  @override
  void onClose() {
    _selectedCategory.close();
    _assets.close();
    _isLoading.close();

    super.onClose();
  }

  void init() {}

  void _setInitialValues() {
    final assetList = _readCache();

    if (assetList == null) return;

    final initialAssets = assetList.map((ast) => Asset.fromJson(ast)).toList();

    _assets.value = initialAssets;
    _isLoading.value = false;
  }

  Future<void> getAssets() async {
    _isLoading.value = true;

    try {
      _setInitialValues();

      Query query = assetsCollection;

      if (_selectedCategory.value != Categories.all) {
        query = query.where(
          'category',
          isEqualTo: _selectedCategory.value.label,
        );
      }

      final result = await query.get();

      _assets.value =
          result.docs
              .map(
                (asset) => Asset.fromMap(asset.data() as Map<String, dynamic>),
              )
              .toList();

      _writeToCache();
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }

    _isLoading.value = false;
  }

  void _writeToCache() {
    LNDStorageService.writeList(
      _cacheKey,
      assets.map((a) => a.toJson()).toList(),
    );
  }

  List<dynamic>? _readCache() {
    return LNDStorageService.readList(_cacheKey);
  }

  void setSelectedCategory(Categories category) {
    _selectedCategory.value = category;

    getAssets();
  }

  void postAssets() async {
    final batch = FirebaseFirestore.instance.batch();
    for (var asset in sampleAssets) {
      batch.set(assetsCollection.doc(), asset.toMap());
    }
    await batch.commit();
    Get.snackbar('Success', 'Add Success');
    getAssets();
  }

  void openAssetPage(Asset asset) {
    Get.toNamed(AssetPage.routeName, arguments: asset);
  }

  void updateAsset(Asset newAsset) {
    final assetIndex = assets.indexWhere((asset) => asset.id == newAsset.id);
    _assets[assetIndex] = newAsset;
    _assets.refresh();
  }

  List<Asset> sampleAssets = [
    Asset(
      id: '1',
      ownerId: 'wvBJK1u8UkJOXABCtiKy',
      title: 'Canon EOS R5 Camera',
      description:
          'High-resolution mirrorless camera perfect for professional photography.',
      category: 'Electronics',
      inclusions: ["3 Batteries", "Hard Case", "128 gb SD Card", "Tripod"],
      rates: Rates(daily: 1500, monthly: 0, annually: 0, notes: 'Just a note'),
      // availability: [
      // Timestamp.fromDate(DateTime(2025, 3, 20)),
      // Timestamp.fromDate(DateTime(2025, 3, 21)),
      // Timestamp.fromDate(DateTime(2025, 3, 22)),
      // ],
      location: Location(
        description: '123 Main St, Springfield, USA',
        latLng: const GeoPoint(37.7749, -122.4194),
      ),
      images: [
        'https://www.the-digital-picture.com/Images/Review/Canon-EOS-R5.jpg',
        'https://www.dpreview.com/files/p/articles/7757595702/20200709-Canon-EOS-R5-Product-Images-1.jpeg',
      ],
      showcase: [
        "https://www.cnet.com/a/img/resize/887fea6895d3592aa884920a4eea1b6ae44c9bff/hub/2022/09/13/5806fde3-a856-4cbb-8a78-ce2f9501df6b/gopro-hero-11-black-05.jpg?auto=webp&width=1200",
        "https://i.insider.com/632169ece8b5000018511e0e?width=700",
        "https://cdn.outsideonline.com/wp-content/uploads/2022/09/gopro-hero-11-black_s.jpeg",
        "https://www.henryscameraphoto.com/image/cache/catalog/GoPro/Hero11/creator/hero11creator-1-800x800.jpeg"
            "https://s3.amazonaws.com/images.gearjunkie.com/uploads/2022/09/Field-Testing-the-GoPro-Hero-11-Black.jpg",
        "https://fdn.gsmarena.com/imgroot/news/22/09/gopro-hero-11-series-ofic/inline/-1200/gsmarena_004.jpg",
        "https://cdn.fstoppers.com/styles/full/s3/media/2022/10/23/gopro-hero-11-black-in-my-hand.jpg",
        "https://static.gopro.com/assets/blta2b8522e5372af40/bltcb0e4a7ab8f7a32e/62ecefc75b080e77825d9efa/pdp-h11b-water-repelling-1920-2x.png",
      ],
      createdAt: Timestamp.now(),
      status: 'Available',
    ),
  ];
}
