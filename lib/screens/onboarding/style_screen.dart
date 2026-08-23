import 'package:flutter/material.dart';
import 'experience_screen.dart';

class StyleScreen extends StatefulWidget {
  final String manufacturer;
  final String bike;
  final String year;

  const StyleScreen({
    super.key,
    required this.manufacturer,
    required this.bike,
    required this.year,
  });

  @override
  State<StyleScreen> createState() => _StyleScreenState();
}

class _StyleScreenState extends State<StyleScreen> {
  final List<String> styles = [
    "チョッパー",
    "ボバー",
    "カフェレーサー",
    "スクランブラー",
    "トラッカー",
    "クラシック",
    "ネイキッド",
    "ストリート",
    "オールドスクール",
    "カスタム未定"
  ];

  String? selectedStyle;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 10),

              const Text(
                "⑤ / 6",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "目指すスタイル",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "あなたの理想のスタイルに合わせて\nAIがカスタムを提案します。",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: ListView.builder(
                  itemCount: styles.length,
                  itemBuilder: (context, index) {

                    final style = styles[index];

                    final selected =
                        selectedStyle == style;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),

                      child: Center(
                        child: GestureDetector(

                          onTap: () {
                            setState(() {
                              selectedStyle = style;
                            });
                          },

                          child: SizedBox(
                            width: buttonWidth,

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),

                              height: 56,

                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),

                                borderRadius:
                                    BorderRadius.circular(16),

                                border: Border.all(
                                  color: selected
                                      ? Colors.white
                                      : Colors.white12,
                                ),
                              ),

                              child: Text(
                                style,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.black
                                      : Colors.white,

                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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

                  onPressed: selectedStyle == null
    ? null
    : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExperienceScreen(
                manufacturer: widget.manufacturer,
                bike: widget.bike,
                year: widget.year,
                style: selectedStyle!,
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
                      borderRadius:
                          BorderRadius.circular(16),
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

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}