import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 80,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          //Home button
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.home,
                  color: Color(0xFFEEE3D4),
                ),
                Text(
                  "Home",
                  style: TextStyle(
                    color: Color(0xFFEEE3D4),
                  ),
                )
              ],
            ),
          ),
          //^^^Home button^^^

          //Surprise Bag button
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/surprise_bag');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.shopping_bag_rounded,
                  color: Color(0xFFEEE3D4),
                ),
                Text(
                  "Surprise Bag",
                  style: TextStyle(
                    color: Color(0xFFEEE3D4),
                  ),
                )
              ],
            ),
          ),
          //^^^Surprise Bag button^^^

          //Surplus Market button
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/surplus_market');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.store_mall_directory_rounded,
                  color: Color(0xFFEEE3D4),
                ),
                Text(
                  "Surplus Market",
                  style: TextStyle(
                    color: Color(0xFFEEE3D4),
                  ),
                )
              ],
            ),
          ),
          //^^^Surplus Market button^^^

          //Profile button
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pushNamed(context, '/profile');
          //   },
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: const [
          //       Icon(
          //         Icons.person,
          //         color: Color(0xFFEEE3D4),
          //       ),
          //       Text(
          //         "Profile",
          //         style: TextStyle(
          //           color: Color(0xFFEEE3D4),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          //^^^Profile button^^^
        ]),
      ),
    );
  }
}
