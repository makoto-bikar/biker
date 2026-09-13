import 'package:flutter/material.dart';

import '../../screens/garage_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        // Menu
        Builder(
          builder: (context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            );
          },
        ),

        // BIKER AI
        const Expanded(
          child: Center(
            child: Text(
              "BIKER AI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Garage
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GarageScreen(),
              ),
            );
          },
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white12,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}