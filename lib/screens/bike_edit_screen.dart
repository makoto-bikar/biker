import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class BikeEditScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const BikeEditScreen({
    super.key,
    required this.user,
  });

  @override
  State<BikeEditScreen> createState() => _BikeEditScreenState();
}

class _BikeEditScreenState extends State<BikeEditScreen> {
  final FirestoreService firestoreService = FirestoreService();

  late TextEditingController manufacturerController;
  late TextEditingController bikeController;
  late TextEditingController yearController;
  late TextEditingController styleController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    manufacturerController = TextEditingController(
      text: widget.user["manufacturer"] ?? "",
    );

    bikeController = TextEditingController(
      text: widget.user["bike"] ?? "",
    );

    yearController = TextEditingController(
      text: widget.user["year"] ?? "",
    );

    styleController = TextEditingController(
      text: widget.user["style"] ?? "",
    );
  }

  @override
  void dispose() {
    manufacturerController.dispose();
    bikeController.dispose();
    yearController.dispose();
    styleController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await firestoreService.updateLatestUser(
        manufacturer: manufacturerController.text.trim(),
        bike: bikeController.text.trim(),
        year: yearController.text.trim(),
        style: styleController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("保存に失敗しました: $e"),
        ),
      );

      setState(() {
        isSaving = false;
      });
    }
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
          "EDIT BIKE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "バイク情報を編集",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "登録しているバイク情報を変更できます。",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 36),

              _EditField(
                label: "メーカー",
                controller: manufacturerController,
              ),

              const SizedBox(height: 20),

              _EditField(
                label: "車種",
                controller: bikeController,
              ),

              const SizedBox(height: 20),

              _EditField(
                label: "年式",
                controller: yearController,
              ),

              const SizedBox(height: 20),

              _EditField(
                label: "スタイル",
                controller: styleController,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  onPressed: isSaving ? null : saveChanges,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white24,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "保存する",
                          style: TextStyle(
                            fontSize: 17,
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

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _EditField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF171717),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.white12,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.white12,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.white54,
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}