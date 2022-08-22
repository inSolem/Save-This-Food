import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Product extends Equatable {
  final String listingImage;
  final String businessLogo;
  final String businessName;
  final String category;
  final String listingName;
  final DateTime startTime;
  final DateTime endTime;
  final int quantityAvailable;
  final String unitOfMeasurement;
  final double price;
  final String description;
  final String businessLocation;
  final String address;
  final String listingId;

  const Product({
    required this.listingImage,
    required this.businessLogo,
    required this.businessName,
    required this.category,
    required this.listingName,
    required this.startTime,
    required this.endTime,
    required this.quantityAvailable,
    required this.unitOfMeasurement,
    required this.price,
    required this.description,
    required this.businessLocation,
    required this.address,
    required this.listingId,
  });

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
      listingImage: snap["listingImage"],
      businessLogo: snap["businessLogo"],
      businessName: snap["businessName"],
      category: snap["category"],
      listingName: snap["listingName"],
      startTime: (snap["startTime"] as Timestamp).toDate(),
      endTime: (snap["endTime"] as Timestamp).toDate(),
      quantityAvailable: snap["quantityAvailable"],
      unitOfMeasurement: snap["unitOfMeasurement"],
      price: snap["price"],
      description: snap["description"],
      businessLocation: snap["businessLocation"],
      address: snap["address"],
      listingId: "${snap.id}",
    );

    return product;
  }

  @override
  List<Object?> get props => [
        listingImage,
        businessLogo,
        businessName,
        category,
        listingName,
        startTime,
        endTime,
        quantityAvailable,
        unitOfMeasurement,
        price,
        description,
        businessLocation,
        address,
        listingId
      ];

  String calculateDifference(DateTime date) {
    DateTime now = DateTime.now();

    int dayDifference = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (dayDifference == 0) {
      return "today";
    } else if (dayDifference == 1) {
      return "tomorrow";
    } else {
      return DateFormat("dd-MMM").format(startTime);
    }
  }

  String displayCollectionTime() {
    var displayStartTime = DateFormat("h:mm a").format(startTime);
    var displayEndTime = DateFormat("h:mm a").format(endTime);
    return "Collect ${displayDate()} $displayStartTime To: $displayEndTime";
  }

  String displayCollectionTimeForProductScreen() {
    var displayStartTime = DateFormat("h:mm a").format(startTime);
    var displayEndTime = DateFormat("h:mm a").format(endTime);
    return "$displayStartTime To: $displayEndTime";
  }

  String displayDate() {
    return calculateDifference(endTime);
  }
}
