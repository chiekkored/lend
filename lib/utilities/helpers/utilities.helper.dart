import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lend/core/models/location.model.dart';
import 'package:lend/utilities/extensions/string.extension.dart';

class LNDUtils {
  static String formatFullName({
    required String? firstName,
    required String? lastName,
  }) {
    if (firstName == null || lastName == null) return 'No name';
    return '$firstName $lastName';
  }

  static String getDateRange({
    required DateTime? start,
    required DateTime? end,
  }) {
    if (start == null || end == null) return '';

    String startMonth = start.toAbbrMonth();
    String endMonth = end.toAbbrMonth();

    if (startMonth == endMonth) {
      return '$startMonth ${start.day} - ${end.day}, ${end.year}';
    } else {
      return '$startMonth ${start.day} - $endMonth ${end.day}, ${end.year}';
    }
  }

  /// Generates a random LatLng within the specified radius (in meters) from the center point
  static LatLng getRandomLocationWithinRadius(LatLng center, double radius) {
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

  // Helper method to conditionally show address based on useSpecificLocation
  static String getAddressText({
    required Location? location,
    required bool toObscure,
  }) {
    if (location == null) return '';

    final address = location.description;

    // Return full address if useSpecificLocation is true
    if (location.useSpecificLocation == true ||
        address == null ||
        address.isEmpty) {
      if (toObscure) return (address ?? '').toObscure();

      return address ?? '';
    }

    // Otherwise show only last two components
    final components = address.split(', ');

    if (toObscure) {
      if (components.length <= 2) return address.toObscure();

      return components.sublist(components.length - 2).join(', ').toObscure();
    }

    if (components.length <= 2) return address;

    return components.sublist(components.length - 2).join(', ');
  }

  static bool isTodayInTimestamps(List<Timestamp> timestamps) {
    // Get today's date with time set to midnight (00:00)
    // FIXME
    final now = DateTime.now().add(Duration(days: 1));
    final today = DateTime(now.year, now.month, now.day);

    // Check if today's date is in the list
    for (var ts in timestamps) {
      final date = ts.toDate();
      final timestampDate = DateTime(date.year, date.month, date.day);

      if (timestampDate == today) {
        return true;
      }
    }

    return false;
  }
}
