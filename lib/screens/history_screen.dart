import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'conversation_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirestoreService firestoreService = FirestoreService();

  List<Map<String, dynamic>> conversations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadHistory();
  }

  // =========================
  // 会話一覧を取得
  // =========================

  Future<void> loadHistory() async {
    final data =
        await firestoreService.getConversations();

    if (!mounted) return;

    setState(() {
      conversations = data;
      isLoading = false;
    });
  }

  // =========================
  // 日付表示
  // =========================

  String formatDate(dynamic timestamp) {
    if (timestamp == null) {
      return "";
    }

    if (timestamp is! DateTime) {
      try {
        final date = timestamp.toDate();

        return "${date.month}月${date.day}日";
      } catch (_) {
        return "";
      }
    }

    return "${timestamp.month}月${timestamp.day}日";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

        title: const Text(
          "履歴",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )

          : conversations.isEmpty
              ? const Center(
                  child: Text(
                    "まだ会話履歴がありません",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                )

              : ListView.builder(
                  padding: const EdgeInsets.all(20),

                  itemCount: conversations.length,

                  itemBuilder: (context, index) {
                    final conversation =
                        conversations[index];

                    final title =
                        conversation["title"]
                                ?.toString() ??
                            "新しい会話";

                    final date = formatDate(
                      conversation["updatedAt"],
                    );

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius:
                            BorderRadius.circular(16),
                      ),

                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),

                        leading: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white70,
                        ),

                        title: Text(
                          title,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        subtitle: Padding(
                          padding:
                              const EdgeInsets.only(
                            top: 6,
                          ),

                          child: Text(
                            date,

                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.white54,
                        ),

                        onTap: () {
  final conversationId =
      conversation["id"]?.toString();

  final title =
      conversation["title"]?.toString() ??
          "新しい会話";

  if (conversationId == null) {
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ConversationScreen(
        conversationId: conversationId,
        title: title,
      ),
    ),
  );
},
                      ),
                    );
                  },
                ),
    );
  }
}