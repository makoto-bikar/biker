import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_screen.dart';
import '../../services/firestore_service.dart';

class LoadingScreen extends StatefulWidget {
  final String manufacturer;
  final String bike;
  final String year;
  final String style;
  final String experience;

  const LoadingScreen({
    super.key,
    required this.manufacturer,
    required this.bike,
    required this.year,
    required this.style,
    required this.experience,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<String> steps = [
    "メーカーを分析しています...",
    "車種を分析しています...",
    "年式を分析しています...",
    "スタイルを分析しています...",
    "カスタム経験を分析しています...",
    "おすすめパーツを検索しています...",
    "あなた専用AIを生成しています...",
  ];

  int currentStep = 0;
  double progress = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    _initializeUser();

    timer = Timer.periodic(
      const Duration(milliseconds: 700),
      (timer) {
        if (currentStep < steps.length - 1) {
          setState(() {
            currentStep++;
            progress = (currentStep + 1) / steps.length;
          });
        } else {
          timer.cancel();

          Future.delayed(
            const Duration(milliseconds: 700),
            () async {
              // オンボーディング完了を保存
              final prefs = await SharedPreferences.getInstance();

              await prefs.setBool(
                'onboarding_completed',
                true,
              );

              if (!mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          );
        }
      },
    );

    progress = 1 / steps.length;
  }

  Future<void> _initializeUser() async {
    await FirestoreService().saveUser(
      manufacturer: widget.manufacturer,
      bike: widget.bike,
      year: widget.year,
      style: widget.style,
      experience: widget.experience,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.08,
          ),
          child: Column(
            children: [
              const Spacer(),

              const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 80,
              ),

              const SizedBox(height: 28),

              const Text(
                "BIKER AI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "あなた専用のAIを生成しています",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 50),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  minHeight: 12,
                  value: progress,
                  backgroundColor: Colors.white12,
                  valueColor:
                      const AlwaysStoppedAnimation(Colors.white),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  steps[currentStep],
                  key: ValueKey(currentStep),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final bool done = index < currentStep;
                    final bool active = index == currentStep;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            done
                                ? Icons.check_circle
                                : active
                                    ? Icons.autorenew
                                    : Icons.radio_button_unchecked,
                            color: done
                                ? Colors.greenAccent
                                : active
                                    ? Colors.white
                                    : Colors.white24,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              steps[index],
                              style: TextStyle(
                                color: done
                                    ? Colors.greenAccent
                                    : active
                                        ? Colors.white
                                        : Colors.white38,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "あと少しです...",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 15,
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