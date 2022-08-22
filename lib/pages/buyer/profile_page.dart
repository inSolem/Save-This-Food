import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_this_food/home_widgets/custom_navbar.dart';

import '../../models/purchase_model.dart';

class ProfilePage extends StatelessWidget {
  Stream<List<Purchase>> readPurchases() => FirebaseFirestore.instance
      .collection("allOrders")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Purchase.fromJson(doc.data())).toList());

  Widget buildOrder(Purchase purchase) => ListTile(
        title: Text(
          '${purchase.email}',
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          '-${purchase.sellerName}',
          style: TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE4D5),
      bottomNavigationBar: CustomNavBar(),
      body: StreamBuilder<List<Purchase>>(
        stream: readPurchases(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              "We ran out of quote today",
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            );
          } else if (snapshot.hasData) {
            final purchases = snapshot.data!;
            //See ListTile for design style
            return ListView(
              children: purchases.map(buildOrder).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
