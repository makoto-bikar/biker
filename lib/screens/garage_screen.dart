import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'bike_edit_screen.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  final FirestoreService firestoreService = FirestoreService();

  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final data = await firestoreService.getLatestUser();

    if (!mounted) return;

    setState(() {
      user = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "GARAGE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : user == null
              ? const Center(
                  child: Text(
                    "バイク情報がありません。",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "MY BIKE",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =========================
                      // MY BIKE CARD
                      // =========================

                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          color: const Color(0xFF171717),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white12,
                          ),
                        ),

                        child: Stack(
                          children: [

                            // バイク情報
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                const Icon(
                                  Icons.two_wheeler,
                                  color: Colors.white,
                                  size: 48,
                                ),

                                const SizedBox(height: 24),

                                Text(
                                  user?["manufacturer"] ?? "不明",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  user?["bike"] ?? "不明",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "${user?["year"] ?? "不明"}年式",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 17,
                                  ),
                                ),

                               const SizedBox(height: 20),

// 区切り線
Container(
  height: 1,
  color: Colors.white12,
),

const SizedBox(height: 20),

// STYLE
Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      "STYLE",
      style: TextStyle(
        color: Colors.white54,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    ),

    Text(
      user?["style"] ?? "不明",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
),
                              ],
                            ),

                            // =========================
                            // 「…」ボタン
                            // =========================

                            Positioned(
                              top: -8,
                              right: -8,

                              child: IconButton(
  icon: const Icon(
    Icons.more_vert,
    color: Colors.white70,
    size: 26,
  ),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "MY BIKE",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "バイク情報を編集",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BikeEditScreen(
                          user: user!,
                        ),
                      ),
                    );

                    if (result == true) {
                      loadUser();
                    }
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  },
),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}