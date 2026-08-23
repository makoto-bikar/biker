import 'package:flutter/material.dart';
import 'year_screen.dart';

class BikeScreen extends StatefulWidget {
  final String manufacturer;

  const BikeScreen({
    super.key,
    required this.manufacturer,
  });

  @override
  State<BikeScreen> createState() => _BikeScreenState();
}

class _BikeScreenState extends State<BikeScreen> {
  // メーカーごとの車種一覧
  static const Map<String, List<String>> manufacturerBikes = {
    "HONDA": [
      "GB350",
      "CB400 SUPER FOUR",
      "CB400 SUPER BOL D'OR",
      "Rebel 250",
      "Rebel 500",
      "CL250",
      "CB250R",
      "CBR250RR",
      "CBR400R",
      "NT1100",
      "CRF250L",
      "Monkey 125",
      "Dax 125",
      "CT125 Hunter Cub",
      "Super Cub 110",
    ],

    "YAMAHA": [
      "SR400",
      "SR500",
      "DragStar 250",
      "DragStar 400",
      "TW200",
      "TW225",
      "XSR700",
      "XSR900",
      "MT-03",
      "MT-07",
      "MT-09",
      "YZF-R25",
      "YZF-R3",
      "YZF-R7",
      "TRACER9 GT",
      "セロー250",
      "WR250R",
      "BOLT",
    ],

    "Kawasaki": [
      "Z900RS",
      "Z900",
      "Z650RS",
      "Z650",
      "Ninja 250",
      "Ninja 400",
      "Ninja 650",
      "Ninja ZX-4R",
      "Ninja ZX-6R",
      "Ninja ZX-10R",
      "W800",
      "MEGURO K3",
      "ELIMINATOR",
      "KLX230",
      "KX250",
    ],

    "SUZUKI": [
      "GSX250R",
      "GSX-8R",
      "GSX-8S",
      "GSX-S1000",
      "GSX-S1000GT",
      "SV650",
      "V-Strom 250",
      "V-Strom 650",
      "V-Strom 800",
      "Hayabusa",
      "Katana",
      "ST250",
      "VanVan200",
      "DR-Z4S",
    ],

    "Harley-Davidson": [
      "Sportster",
      "Sportster 883",
      "Sportster 1200",
      "Iron 883",
      "Forty-Eight",
      "Nightster",
      "Sportster S",
      "FAT BOY",
      "Low Rider",
      "Street Bob",
      "Breakout",
      "Softail Standard",
      "Heritage Classic",
      "FLHCS",
      "Road King",
      "Street Glide",
      "Road Glide",
      "vintage"
    ],

    "Indian": [
      "Scout",
      "Scout Bobber",
      "Scout Sixty",
      "Chief",
      "Chief Bobber",
      "Super Chief",
      "FTR",
      "Chieftain",
      "Roadmaster",
    ],

    "BMW": [
      "R nineT",
      "R 12",
      "R 18",
      "R 1250 GS",
      "R 1300 GS",
      "S 1000 RR",
      "S 1000 R",
      "S 1000 XR",
      "F 900 R",
      "F 900 GS",
      "G 310 R",
      "G 310 GS",
    ],

    "Triumph": [
      "Bonneville T100",
      "Bonneville T120",
      "Street Twin",
      "Speed Twin 900",
      "Speed Twin 1200",
      "Scrambler 900",
      "Scrambler 1200",
      "Street Triple",
      "Speed Triple",
      "Trident 660",
      "Tiger 900",
      "Tiger 1200",
      "Rocket 3",
    ],

    "DUCATI": [
      "Monster",
      "Monster 937",
      "Panigale V2",
      "Panigale V4",
      "Streetfighter V2",
      "Streetfighter V4",
      "Scrambler Icon",
      "Scrambler Nightshift",
      "Multistrada V2",
      "Multistrada V4",
      "Diavel",
      "Hypermotard",
    ],

    "その他": [
      "車種が見つからない",
    ],
  };

  String? selectedBike;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.85;

    // 選択されたメーカーの車種を取得
    final List<String> bikes =
        manufacturerBikes[widget.manufacturer] ?? ["車種が見つからない"];

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
                "③ / 6",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "車種を選択",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "${widget.manufacturer}の車種を選択してください。",
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: ListView.builder(
                  itemCount: bikes.length,

                  itemBuilder: (context, index) {
                    final bike = bikes[index];
                    final selected = selectedBike == bike;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),

                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBike = bike;
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

                                borderRadius:
                                    BorderRadius.circular(16),

                                border: Border.all(
                                  color: selected
                                      ? Colors.white
                                      : Colors.white12,
                                ),
                              ),

                              child: Text(
                                bike,
                                textAlign: TextAlign.center,

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
                  onPressed: selectedBike == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YearScreen(
                                manufacturer:
                                    widget.manufacturer,
                                bike: selectedBike!,
                              ),
                            ),
                          );
                        },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,

                    disabledBackgroundColor:
                        Colors.white10,

                    disabledForegroundColor:
                        Colors.white38,

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
            ],
          ),
        ),
      ),
    );
  }
}