import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "設定",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            "SETTINGS",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white12,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              title: const Text(
                "通知",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.white38,
              ),
              onTap: () {
                // 後で実装
              },
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white12,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: const Text(
                "Bikarについて",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.white38,
              ),
              onTap: () {
                // 後で実装
              },
            ),
          ),
        ],
      ),
    );
  }
}