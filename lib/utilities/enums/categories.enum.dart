import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Categories {
  all('All', FontAwesomeIcons.globe),
  electronics('Electronics', FontAwesomeIcons.computer),
  audioEquipment('Audio Equipment', FontAwesomeIcons.guitar),
  outdoorGears('Outdoor Gears', FontAwesomeIcons.personHiking),
  appliances('Appliances', FontAwesomeIcons.blenderPhone),
  eventSupplies('Event Supplies', FontAwesomeIcons.headset),
  vehicles('Vehicles', FontAwesomeIcons.car);

  final String label;
  final IconData icon;
  const Categories(this.label, this.icon);
}
