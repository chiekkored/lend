import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LNDBottomSheetHelper {
  static Future<T?>? showLocationPicker<T>() async {
    return await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Location', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            // Location picker content goes here
            // Replace with your actual location picker implementation
            const Text('Location picker content'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: 'Selected location'),
                  child: const Text('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  static Future<T?>? showInclusions<T>({
    required List<String> inclusions,
    bool isEditable = false,
  }) async {
    return await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inclusions', style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            // Inclusions content
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: inclusions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(inclusions[index]),
                    trailing:
                        isEditable
                            ? IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Handle delete inclusion
                              },
                            )
                            : null,
                  );
                },
              ),
            ),
            if (isEditable) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle add new inclusion
                },
                child: const Text('Add Inclusion'),
              ),
            ],
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
