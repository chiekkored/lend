import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/location.model.dart';
import 'package:lend/core/models/rates.model.dart';
import 'package:lend/core/models/simple_asset.model.dart';
import 'package:lend/core/models/simple_user.model.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/availability.enum.dart';
import 'package:lend/utilities/enums/categories.enum.dart';

class AssetDummyData {
  /// Creates and uploads 5 dummy assets to Firestore
  static Future<void> uploadDummyAssets() async {
    final batch = FirebaseFirestore.instance.batch();
    final firestore = FirebaseFirestore.instance;
    final assetCollection = firestore.collection(LNDCollections.assets.name);
    final userAssetCollection = firestore.collection(LNDCollections.users.name);

    // Create a simple user as the owner for all assets
    final SimpleUserModel dummyOwner = ProfileController.instance.simpleUser;

    // Asset 1
    final doc1 = assetCollection.doc();
    batch.set(
      doc1,
      AddAsset(
        id: doc1.id,
        ownerId: dummyOwner.uid ?? '',
        owner: dummyOwner,
        title: 'Professional DSLR Camera',
        description:
            'Canon EOS 5D Mark IV with 24-70mm lens. Perfect for photography enthusiasts or professional shoots.',
        category: Categories.electronics.label,
        rates: Rates(daily: 2500),
        location: Location(
          description: '123 Photography St, San Francisco, CA 94105',
          useSpecificLocation: true,
          latLng: const GeoPoint(37.7749, -122.4194),
        ),
        images: [
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=1000',
        ],
        showcase: [],
        inclusions: ['Camera body', 'Lens', 'Battery', 'Charger', 'Camera bag'],
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Add SimpleAsset to user's assets collection
    batch.set(
      userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc1.id),
      SimpleAsset(
        id: doc1.id,
        title: 'Professional DSLR Camera',
        images: [
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=1000',
        ],
        category: Categories.electronics.label,
        ownerId: dummyOwner.uid ?? '',
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Asset 2
    final doc2 = assetCollection.doc();
    batch.set(
      doc2,
      AddAsset(
        id: doc2.id,
        ownerId: dummyOwner.uid ?? '',
        owner: dummyOwner,
        title: 'Mountain Bike - Trek Fuel EX',
        description:
            'High-performance mountain bike for trail riding. Full suspension with hydraulic disc brakes.',
        category: Categories.outdoorGears.label,
        rates: Rates(daily: 1500),
        location: Location(
          description: '456 Mountain Trail Ave, Boulder, CO 80302',
          useSpecificLocation: true,
          latLng: const GeoPoint(40.0150, -105.2705),
        ),
        images: [
          'https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?q=80&w=1000',
        ],
        showcase: [],
        inclusions: ['Bike', 'Helmet', 'Bike lock', 'Repair kit'],
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Add SimpleAsset to user's assets collection
    batch.set(
      userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc2.id),
      SimpleAsset(
        id: doc2.id,
        title: 'Mountain Bike - Trek Fuel EX',
        images: [
          'https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?q=80&w=1000',
        ],
        category: Categories.outdoorGears.label,
        ownerId: dummyOwner.uid ?? '',
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Asset 3
    final doc3 = assetCollection.doc();
    batch.set(
      doc3,
      AddAsset(
        id: doc3.id,
        ownerId: dummyOwner.uid ?? '',
        owner: dummyOwner,
        title: 'DJ Equipment Set',
        description:
            'Complete DJ setup including Pioneer CDJ-2000NXS2 players and DJM-900NXS2 mixer. Perfect for events and parties.',
        category: Categories.audioEquipment.label,
        rates: Rates(daily: 5000),
        location: null, // Using registered address
        images: [
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=1000',
        ],
        showcase: [],
        inclusions: [
          '2x CDJ-2000NXS2',
          'DJM-900NXS2 mixer',
          'Headphones',
          'Cables',
          'Stand',
        ],
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Add SimpleAsset to user's assets collection
    batch.set(
      userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc3.id),
      SimpleAsset(
        id: doc3.id,
        title: 'DJ Equipment Set',
        images: [
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=1000',
        ],
        category: Categories.audioEquipment.label,
        ownerId: dummyOwner.uid ?? '',
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Asset 4
    final doc4 = assetCollection.doc();
    batch.set(
      doc4,
      AddAsset(
        id: doc4.id,
        ownerId: dummyOwner.uid ?? '',
        owner: dummyOwner,
        title: 'Camping Tent - 6 Person',
        description:
            'Coleman WeatherMaster 6-person tent with screened porch. Waterproof and easy to set up.',
        category: Categories.outdoorGears.label,
        rates: Rates(daily: 800),
        location: Location(
          description: '789 Camping Road, Yosemite, CA 95389',
          useSpecificLocation: false,
          latLng: const GeoPoint(37.8651, -119.5383),
        ),
        images: [
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=1000',
        ],
        showcase: [],
        inclusions: ['Tent', 'Rainfly', 'Stakes', 'Setup instructions'],
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Add SimpleAsset to user's assets collection
    batch.set(
      userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc4.id),
      SimpleAsset(
        id: doc4.id,
        title: 'Camping Tent - 6 Person',
        images: [
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=1000',
        ],
        category: Categories.outdoorGears.label,
        ownerId: dummyOwner.uid ?? '',
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Asset 5
    final doc5 = assetCollection.doc();
    batch.set(
      doc5,
      AddAsset(
        id: doc5.id,
        ownerId: dummyOwner.uid ?? '',
        owner: dummyOwner,
        title: 'Projector for Home Theater',
        description:
            'Epson Home Cinema 3800 4K PRO-UHD projector with 3000 lumens. Great for movie nights or presentations.',
        category: Categories.electronics.label,
        rates: Rates(daily: 2000),
        location: null, // Using registered address
        images: [
          'https://images.unsplash.com/photo-1601944179066-29786cb9d32a?q=80&w=1000',
        ],
        showcase: [],
        inclusions: ['Projector', 'Remote control', 'HDMI cable', 'Power cord'],
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Add SimpleAsset to user's assets collection
    batch.set(
      userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc5.id),
      SimpleAsset(
        id: doc5.id,
        title: 'Projector for Home Theater',
        images: [
          'https://images.unsplash.com/photo-1601944179066-29786cb9d32a?q=80&w=1000',
        ],
        category: Categories.electronics.label,
        ownerId: dummyOwner.uid ?? '',
        createdAt: Timestamp.now(),
        status: Availability.available.label,
      ).toMap(),
    );

    // Commit the batch
    await batch.commit();
    debugPrint('Successfully uploaded 5 dummy assets to Firestore');
  }
}
