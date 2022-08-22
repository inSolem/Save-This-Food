import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MerchantNavBar extends StatelessWidget {
  const MerchantNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 80,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          //Home button
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pushNamed(context, '/merchant_home');
          //   },
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: const [
          //       Icon(
          //         Icons.home,
          //         color: Color(0xFFEEE3D4),
          //       ),
          //       Text(
          //         "Home",
          //         style: TextStyle(
          //           color: Color(0xFFEEE3D4),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          //^^^Home button^^^

          //List button
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/list');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: Color(0xFFEEE3D4),
                ),
                Text(
                  "List",
                  style: TextStyle(
                    color: Color(0xFFEEE3D4),
                  ),
                )
              ],
            ),
          ),
          //^^^List button^^^

          //Surplus Market button
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/merchant_surplus_market');
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
        ]),
      ),
    );
  }
}
