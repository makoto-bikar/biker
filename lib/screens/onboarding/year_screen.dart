import 'package:flutter/material.dart';
import 'style_screen.dart';

class YearScreen extends StatefulWidget {
  final String manufacturer;
  final String bike;

  const YearScreen({
    super.key,
    required this.manufacturer,
    required this.bike,
  });

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  String? selectedYear;

  final List<String> years = List.generate(
    DateTime.now().year - 1900,
    (index) => (DateTime.now().year - index).toString(),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding =
        screenWidth > 700 ? screenWidth * 0.18 : 24.0;

    final cardWidth =
        screenWidth > 700 ? 500.0 : double.infinity;

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
                "④ / 6",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "年式を選択",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "バイクの年式を選択してください。",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: Center(
                  child: SizedBox(
                    width: cardWidth,

                    child: ListView.builder(
                      itemCount: years.length,

                      itemBuilder: (context, index) {

                        final year = years[index];

                        final selected =
                            selectedYear == year;

                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12),

                          child: GestureDetector(

                            onTap: () {
                              setState(() {
                                selectedYear = year;
                              });
                            },

                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 180),

                              height: 58,

                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xff1A1A1A),

                                borderRadius:
                                    BorderRadius.circular(16),

                                border: Border.all(
                                  color: selected
                                      ? Colors.white
                                      : Colors.white12,
                                ),
                              ),

                              alignment: Alignment.center,

                              child: Text(
                                "$year 年",

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
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(

                  onPressed: selectedYear == null
    ? null
    : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>  StyleScreen(
                manufacturer: widget.manufacturer,
                bike: widget.bike,
                year: selectedYear!,
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