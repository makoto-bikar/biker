import 'package:flutter/material.dart';
import 'bike_screen.dart';
import 'year_screen.dart';

class ManufacturerScreen extends StatefulWidget {
  const ManufacturerScreen({super.key});

  @override
  State<ManufacturerScreen> createState() => _ManufacturerScreenState();
}

class _ManufacturerScreenState extends State<ManufacturerScreen> {
  final List<String> makers = [
    "HONDA",
    "YAMAHA",
    "Kawasaki",
    "SUZUKI",
    "Harley-Davidson",
    "Indian",
    "BMW",
    "Triumph",
    "DUCATI",
    "その他",
  ];

  String? selectedManufacturer;

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
                "② / 6",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "メーカーを選択",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "あなたのバイクに合わせて\nおすすめを表示します。",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: ListView.builder(
                  itemCount: makers.length,
                  itemBuilder: (context, index) {
                    final maker = makers[index];
                    final selected = selectedManufacturer == maker;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedManufacturer = maker;
                            });
                          },
                          child: SizedBox(
                            width: buttonWidth,
                            child: Container(
                              height: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected
                                      ? Colors.white
                                      : Colors.white12,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                maker,
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
                  onPressed: selectedManufacturer == null
    ? null
    : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>  BikeScreen(  
              manufacturer: selectedManufacturer!,
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
            ],
          ),
        ),
      ),
    );
  }
}