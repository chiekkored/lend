import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';
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
}
