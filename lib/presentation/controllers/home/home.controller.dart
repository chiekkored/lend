import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static final instance = Get.find<HomeController>();

  final RxInt _selectedCategoryIndex = 0.obs;

  int get selectedCategoryIndex => _selectedCategoryIndex.value;

  List<Categories> get categories => [
        Categories(
          label: 'All',
          icon: FontAwesomeIcons.globe,
        ),
        Categories(
          label: 'Electronics & Gadgets',
          icon: FontAwesomeIcons.computer,
        ),
        Categories(
          label: 'Audio Equipments',
          icon: FontAwesomeIcons.guitar,
        ),
        Categories(
          label: 'Outdoor Gears',
          icon: FontAwesomeIcons.personHiking,
        ),
        Categories(
          label: 'Appliances',
          icon: FontAwesomeIcons.blenderPhone,
        ),
        Categories(
          label: 'Event Supplies',
          icon: FontAwesomeIcons.headset,
        ),
        Categories(
          label: 'Vehicles',
          icon: FontAwesomeIcons.car,
        ),
      ];

  @override
  void onClose() {
    _selectedCategoryIndex.close();

    super.onClose();
  }

  void setSelectedCategory(int index) => _selectedCategoryIndex.value = index;
}

class Categories {
  final String label;
  final IconData icon;

  Categories({required this.label, required this.icon});
}
