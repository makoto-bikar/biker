import 'package:flutter/material.dart';
import 'style_screen.dart';

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
      "vintage",
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

  String? selectedManufacturer;
  String? selectedBike;
  String? selectedYear;

  List<String> get availableBikes {
    if (selectedManufacturer == null) {
      return [];
    }

    return manufacturerBikes[selectedManufacturer] ??
        ["車種が見つからない"];
  }

  List<String> get years {
    final currentYear = DateTime.now().year;

    return List.generate(
      currentYear - 1900,
      (index) => (currentYear - index).toString(),
    );
  }

  bool get canContinue {
    return selectedManufacturer != null &&
        selectedBike != null &&
        selectedYear != null;
  }

  void _showSelectionSheet({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final selected = selectedValue == option;

                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 150),
                          height: 56,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? Colors.white
                                  : Colors.white12,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionField({
    required String label,
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasValue
                    ? Colors.white30
                    : Colors.white12,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value : placeholder,
                    style: TextStyle(
                      color: hasValue
                          ? Colors.white
                          : Colors.white38,
                      fontSize: 16,
                      fontWeight: hasValue
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white38,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _goToStyleScreen() {
    if (!canContinue) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StyleScreen(
          manufacturer: selectedManufacturer!,
          bike: selectedBike!,
          year: selectedYear!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding =
        screenWidth > 700 ? screenWidth * 0.18 : 24.0;

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "BIKER",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 70),

              const Text(
                "YOUR BIKE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "あなたのバイクを教えてください。",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 42),

              _buildSelectionField(
                label: "メーカー",
                value: selectedManufacturer,
                placeholder: "選択する",
                onTap: () {
                  _showSelectionSheet(
                    title: "メーカーを選択",
                    options: makers,
                    selectedValue: selectedManufacturer,
                    onSelected: (value) {
                      setState(() {
                        selectedManufacturer = value;

                        // メーカーが変わったら
                        // 車種と年式をリセット
                        selectedBike = null;
                        selectedYear = null;
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              _buildSelectionField(
                label: "車種",
                value: selectedBike,
                placeholder: selectedManufacturer == null
                    ? "先にメーカーを選択"
                    : "選択する",
                onTap: selectedManufacturer == null
                    ? () {}
                    : () {
                        _showSelectionSheet(
                          title: "車種を選択",
                          options: availableBikes,
                          selectedValue: selectedBike,
                          onSelected: (value) {
                            setState(() {
                              selectedBike = value;
                              selectedYear = null;
                            });
                          },
                        );
                      },
              ),

              const SizedBox(height: 20),

              _buildSelectionField(
                label: "年式",
                value: selectedYear,
                placeholder: selectedBike == null
                    ? "先に車種を選択"
                    : "選択する",
                onTap: selectedBike == null
                    ? () {}
                    : () {
                        _showSelectionSheet(
                          title: "年式を選択",
                          options: years,
                          selectedValue: selectedYear,
                          onSelected: (value) {
                            setState(() {
                              selectedYear = value;
                            });
                          },
                        );
                      },
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed:
                      canContinue ? _goToStyleScreen : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor:
                        const Color(0xFF181818),
                    disabledForegroundColor:
                        Colors.white24,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "次へ",
                    style: TextStyle(
                      fontSize: 17,
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