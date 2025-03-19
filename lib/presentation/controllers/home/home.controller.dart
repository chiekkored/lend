import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/presentation/pages/asset/asset.page.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/categories.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class HomeController extends GetxController {
  static final instance = Get.find<HomeController>();

  final assetsCollection =
      FirebaseFirestore.instance.collection(LNDCollections.assets);

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

  Future<void> getAssets([Categories category = Categories.all]) async {
    _isLoading.value = true;

    try {
      Query query = assetsCollection;

      if (category != Categories.all) {
        query = query.where('category', isEqualTo: category.label);
      }

      final result = await query.get();

      _assets.value = result.docs
          .map((assets) => Asset.fromMap(assets.data() as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }

    _isLoading.value = false;
  }

  void setSelectedCategory(Categories category) {
    _selectedCategory.value = category;

    getAssets(category);
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
    Get.toNamed(AssetPage.routeName, arguments: {'asset': asset});
  }

  List<Asset> sampleAssets = [
    Asset(
      ownerId: 'wvBJK1u8UkJOXABCtiKy',
      title: 'Canon EOS R5 Camera',
      description:
          'High-resolution mirrorless camera perfect for professional photography.',
      category: 'Electronics',
      rates: Rates(daily: 1500, custom: 'Weekly: 9000'),
      availability: [
        Timestamp.fromDate(DateTime(2025, 3, 20)),
        Timestamp.fromDate(DateTime(2025, 3, 21)),
        Timestamp.fromDate(DateTime(2025, 3, 22)),
      ],
      location: const GeoPoint(10.6840, 122.9563), // Bacolod City coordinates
      images: [
        'https://www.the-digital-picture.com/Images/Review/Canon-EOS-R5.jpg',
        'https://www.dpreview.com/files/p/articles/7757595702/20200709-Canon-EOS-R5-Product-Images-1.jpeg',
      ],
      createdAt: Timestamp.now(),
      status: 'Available',
    ),
  ];
}
