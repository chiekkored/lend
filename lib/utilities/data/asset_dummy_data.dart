// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:lend/core/models/asset.model.dart';
// import 'package:lend/core/models/location.model.dart';
// import 'package:lend/core/models/rates.model.dart';
// import 'package:lend/core/models/simple_asset.model.dart';
// import 'package:lend/core/models/simple_user.model.dart';
// import 'package:lend/presentation/controllers/profile/profile.controller.dart';
// import 'package:lend/utilities/constants/collections.constant.dart';
// import 'package:lend/utilities/enums/availability.enum.dart';
// import 'package:lend/utilities/enums/categories.enum.dart';

// class AssetDummyData {
//   /// Creates and uploads 10 dummy assets to Firestore
//   static Future<void> uploadDummyAssets() async {
//     final batch = FirebaseFirestore.instance.batch();
//     final firestore = FirebaseFirestore.instance;
//     final assetCollection = firestore.collection(LNDCollections.assets.name);
//     final userAssetCollection = firestore.collection(LNDCollections.users.name);

//     // Create a simple user as the owner for all assets
//     final SimpleUserModel dummyOwner = ProfileController.instance.simpleUser;

//     // Asset 1
//     final doc1 = assetCollection.doc();
//     batch.set(
//       doc1,
//       AddAsset(
//         id: doc1.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Professional DSLR Camera',
//         description:
//             'Canon EOS 5D Mark IV with 24-70mm lens. Perfect for photography enthusiasts or professional shoots.',
//         category: Categories.electronics.label,
//         rates: Rates(daily: 2500),
//         location: Location(
//           description: '123 Photography St, San Francisco, CA 94105',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(37.7749, -122.4194),
//         ),
//         images: [
//           'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: ['Camera body', 'Lens', 'Battery', 'Charger', 'Camera bag'],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc1.id),
//       SimpleAsset(
//         id: doc1.id,
//         title: 'Professional DSLR Camera',
//         images: [
//           'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=1000',
//         ],
//         category: Categories.electronics.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 2
//     final doc2 = assetCollection.doc();
//     batch.set(
//       doc2,
//       AddAsset(
//         id: doc2.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Mountain Bike - Trek Fuel EX',
//         description:
//             'High-performance mountain bike for trail riding. Full suspension with hydraulic disc brakes.',
//         category: Categories.outdoorGears.label,
//         rates: Rates(daily: 1500),
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//         images: [
//           'https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: ['Bike', 'Helmet', 'Bike lock', 'Repair kit'],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc2.id),
//       SimpleAsset(
//         id: doc2.id,
//         title: 'Mountain Bike - Trek Fuel EX',
//         images: [
//           'https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?q=80&w=1000',
//         ],
//         category: Categories.outdoorGears.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 3
//     final doc3 = assetCollection.doc();
//     batch.set(
//       doc3,
//       AddAsset(
//         id: doc3.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'DJ Equipment Set',
//         description:
//             'Complete DJ setup including Pioneer CDJ-2000NXS2 players and DJM-900NXS2 mixer. Perfect for events and parties.',
//         category: Categories.audioEquipment.label,
//         rates: Rates(daily: 5000),
//         location: null, // Using registered address
//         images: [
//           'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: [
//           '2x CDJ-2000NXS2',
//           'DJM-900NXS2 mixer',
//           'Headphones',
//           'Cables',
//           'Stand',
//         ],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc3.id),
//       SimpleAsset(
//         id: doc3.id,
//         title: 'DJ Equipment Set',
//         images: [
//           'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=1000',
//         ],
//         category: Categories.audioEquipment.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 4
//     final doc4 = assetCollection.doc();
//     batch.set(
//       doc4,
//       AddAsset(
//         id: doc4.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Camping Tent - 6 Person',
//         description:
//             'Coleman WeatherMaster 6-person tent with screened porch. Waterproof and easy to set up.',
//         category: Categories.outdoorGears.label,
//         rates: Rates(daily: 800),
//         location: Location(
//           description: '789 Camping Road, Yosemite, CA 95389',
//           useSpecificLocation: false,
//           latLng: const GeoPoint(37.8651, -119.5383),
//         ),
//         images: [
//           'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: ['Tent', 'Rainfly', 'Stakes', 'Setup instructions'],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc4.id),
//       SimpleAsset(
//         id: doc4.id,
//         title: 'Camping Tent - 6 Person',
//         images: [
//           'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=1000',
//         ],
//         category: Categories.outdoorGears.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 5
//     final doc5 = assetCollection.doc();
//     batch.set(
//       doc5,
//       AddAsset(
//         id: doc5.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Projector for Home Theater',
//         description:
//             'Epson Home Cinema 3800 4K PRO-UHD projector with 3000 lumens. Great for movie nights or presentations.',
//         category: Categories.electronics.label,
//         rates: Rates(daily: 2000),
//         location: null, // Using registered address
//         images: [
//           'https://images.unsplash.com/photo-1601944179066-29786cb9d32a?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: ['Projector', 'Remote control', 'HDMI cable', 'Power cord'],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc5.id),
//       SimpleAsset(
//         id: doc5.id,
//         title: 'Projector for Home Theater',
//         images: [
//           'https://images.unsplash.com/photo-1601944179066-29786cb9d32a?q=80&w=1000',
//         ],
//         category: Categories.electronics.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 6
//     final doc6 = assetCollection.doc();
//     batch.set(
//       doc6,
//       AddAsset(
//         id: doc6.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Stand Mixer - Kitchen Aid Professional',
//         description:
//             'Professional 5-quart stand mixer, perfect for baking enthusiasts. Includes multiple attachments for various functions.',
//         category: Categories.appliances.label,
//         rates: Rates(daily: 1200),
//         location: null, // Using registered address
//         images: [
//           'https://images.unsplash.com/photo-1558180077-09f158c76707?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: ['Mixer', 'Whisk attachment', 'Dough hook', 'Flat beater'],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc6.id),
//       SimpleAsset(
//         id: doc6.id,
//         title: 'Stand Mixer - Kitchen Aid Professional',
//         images: [
//           'https://images.unsplash.com/photo-1558180077-09f158c76707?q=80&w=1000',
//         ],
//         category: Categories.appliances.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 7
//     final doc7 = assetCollection.doc();
//     batch.set(
//       doc7,
//       AddAsset(
//         id: doc7.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Drone - DJI Mavic Air 2',
//         description:
//             'High-performance drone with 4K camera and intelligent flight modes. Perfect for aerial photography and videography.',
//         category: Categories.electronics.label,
//         rates: Rates(daily: 3000),
//         location: Location(
//           description: '321 Sky View Dr, Los Angeles, CA 90001',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(34.0522, -118.2437),
//         ),
//         images: [
//           'https://images.unsplash.com/photo-1508444845599-5c89863b1c44?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: [
//           'Drone',
//           'Remote controller',
//           '3 batteries',
//           'Carrying case',
//           'Spare propellers',
//         ],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc7.id),
//       SimpleAsset(
//         id: doc7.id,
//         title: 'Drone - DJI Mavic Air 2',
//         images: [
//           'https://images.unsplash.com/photo-1508444845599-5c89863b1c44?q=80&w=1000',
//         ],
//         category: Categories.electronics.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 8
//     final doc8 = assetCollection.doc();
//     batch.set(
//       doc8,
//       AddAsset(
//         id: doc8.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Paddleboard Set',
//         description:
//             'Inflatable stand-up paddleboard with pump, paddle, and carrying bag. Great for lake or ocean activities.',
//         category: Categories.outdoorGears.label,
//         rates: Rates(daily: 1000),
//         location: Location(
//           description: '555 Beach Road, Santa Monica, CA 90402',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(34.0195, -118.4912),
//         ),
//         images: [
//           'https://plus.unsplash.com/premium_photo-1681256187382-73ca06ed8d0c?q=80&w=3687&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//         ],
//         showcase: [],
//         inclusions: [
//           'Inflatable paddleboard',
//           'Paddle',
//           'Pump',
//           'Carry bag',
//           'Repair kit',
//         ],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc8.id),
//       SimpleAsset(
//         id: doc8.id,
//         title: 'Paddleboard Set',
//         images: [
//           'https://plus.unsplash.com/premium_photo-1681256187382-73ca06ed8d0c?q=80&w=3687&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//         ],
//         category: Categories.outdoorGears.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 9
//     final doc9 = assetCollection.doc();
//     batch.set(
//       doc9,
//       AddAsset(
//         id: doc9.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Gaming Console - PlayStation 5',
//         description:
//             'Latest PlayStation console with two controllers and a selection of popular games. Perfect for gaming nights.',
//         category: Categories.electronics.label,
//         rates: Rates(daily: 1500),
//         location: null, // Using registered address
//         images: [
//           'https://images.unsplash.com/photo-1607853202273-797f1c22a38e?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: [
//           'PlayStation 5 console',
//           '2 controllers',
//           '5 games',
//           'HDMI cable',
//         ],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection.doc(dummyOwner.uid).collection('assets').doc(doc9.id),
//       SimpleAsset(
//         id: doc9.id,
//         title: 'Gaming Console - PlayStation 5',
//         images: [
//           'https://images.unsplash.com/photo-1607853202273-797f1c22a38e?q=80&w=1000',
//         ],
//         category: Categories.electronics.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Asset 10
//     final doc10 = assetCollection.doc();
//     batch.set(
//       doc10,
//       AddAsset(
//         id: doc10.id,
//         ownerId: dummyOwner.uid ?? '',
//         owner: dummyOwner,
//         title: 'Pneumatic Power Tool Set',
//         description:
//             'Complete set of professional-grade pneumatic tools including nail gun, impact wrench, and air compressor.',
//         category: Categories.outdoorGears.label,
//         rates: Rates(daily: 2200),
//         location: Location(
//           description: '888 Construction Blvd, Portland, OR 97205',
//           useSpecificLocation: false,
//           latLng: const GeoPoint(45.5051, -122.6750),
//         ),
//         images: [
//           'https://images.unsplash.com/photo-1530124566582-a618bc2615dc?q=80&w=1000',
//         ],
//         showcase: [],
//         inclusions: [
//           'Air compressor',
//           'Nail gun',
//           'Impact wrench',
//           'Air hoses',
//           'Safety goggles',
//         ],
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//       ).toMap(),
//     );

//     // Add SimpleAsset to user's assets collection
//     batch.set(
//       userAssetCollection
//           .doc(dummyOwner.uid)
//           .collection('assets')
//           .doc(doc10.id),
//       SimpleAsset(
//         id: doc10.id,
//         title: 'Pneumatic Power Tool Set',
//         images: [
//           'https://images.unsplash.com/photo-1530124566582-a618bc2615dc?q=80&w=1000',
//         ],
//         category: Categories.outdoorGears.label,
//         ownerId: dummyOwner.uid ?? '',
//         createdAt: Timestamp.now(),
//         status: Availability.available.label,
//         location: Location(
//           description: '456 Mountain Trail Ave, Boulder, CO 80302',
//           useSpecificLocation: true,
//           latLng: const GeoPoint(40.0150, -105.2705),
//         ),
//       ).toMap(),
//     );

//     // Commit the batch
//     await batch.commit();
//     debugPrint('Successfully uploaded 10 dummy assets to Firestore');
//   }
// }
