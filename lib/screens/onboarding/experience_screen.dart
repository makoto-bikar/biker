import 'package:flutter/material.dart';
import 'loading_screen.dart';

class ExperienceScreen extends StatefulWidget {
  final String manufacturer;
  final String bike;
  final String year;
  final String style;

  const ExperienceScreen({
    super.key,
    required this.manufacturer,
    required this.bike,
    required this.year,
    required this.style,});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final List<Map<String, String>> experiences = [
    {
      "emoji": "🔰",
      "title": "初めて",
    },
    {
      "emoji": "🙂",
      "title": "少しだけ",
    },
    {
      "emoji": "😎",
      "title": "自分でやっている",
    },
    {
      "emoji": "🛠",
      "title": "上級者",
    },
  ];

  String? selectedExperience;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth > 600 ? 120.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              const Text(
                "⑥ / 6",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "カスタム経験はありますか？",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "あなたに合ったAIアドバイスを\nするために教えてください。",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 35),

              Expanded(
                child: ListView.builder(
                  itemCount: experiences.length,
                  itemBuilder: (context, index) {
                    final item = experiences[index];

                    final selected =
                        selectedExperience == item["title"];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedExperience = item["title"];
                          });
                        },
                        child: Container(
                          height: 62,
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white
                                : const Color(0xff1A1A1A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? Colors.white
                                  : Colors.white12,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item["emoji"]!,
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item["title"]!,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedExperience == null
    ? null
    : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>  LoadingScreen(
                manufacturer: widget.manufacturer,
                bike: widget.bike,
                year: widget.year,
                style: widget.style,
                experience: selectedExperience!,
            ),
          ),
        );
      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white10,
                    disabledForegroundColor: Colors.white38,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "次へ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}