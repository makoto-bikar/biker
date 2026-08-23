import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // =========================
  // 会話を新しく作成
  // =========================

  Future<String> createConversation({
    required String title,
  }) async {
    final doc = await _firestore
        .collection("conversations")
        .add({
      "title": title,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  // =========================
  // 会話にメッセージを保存
  // =========================

  Future<void> saveConversationMessage({
    required String conversationId,
    required String text,
    required bool isUser,
    List<Map<String, dynamic>> products = const [],
  }) async {
    final conversationRef = _firestore
        .collection("conversations")
        .doc(conversationId);

    await conversationRef
        .collection("messages")
        .add({
      "text": text,
      "isUser": isUser,
      "products": products,
      "createdAt": FieldValue.serverTimestamp(),
    });

    await conversationRef.update({
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // =========================
  // 会話一覧を取得
  // =========================

  Future<List<Map<String, dynamic>>>
      getConversations() async {
    final snapshot = await _firestore
        .collection("conversations")
        .orderBy(
          "updatedAt",
          descending: true,
        )
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        "id": doc.id,
        "title": data["title"] ?? "新しい会話",
        "createdAt": data["createdAt"],
        "updatedAt": data["updatedAt"],
      };
    }).toList();
  }

  // =========================
  // 1つの会話を取得
  // =========================

  Future<List<Map<String, dynamic>>>
      getConversationMessages(
    String conversationId,
  ) async {
    final snapshot = await _firestore
        .collection("conversations")
        .doc(conversationId)
        .collection("messages")
        .orderBy("createdAt")
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        "text": data["text"] ?? "",
        "isUser": data["isUser"] ?? false,
        "products": data["products"] ?? [],
        "createdAt": data["createdAt"],
      };
    }).toList();
  }

  // =========================
  // 旧メッセージ保存
  // =========================
  // 今までのコードとの互換性のため残す

  Future<void> saveMessage({
    required String text,
    required bool isUser,
  }) async {
    await _firestore.collection("messages").add({
      "text": text,
      "isUser": isUser,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // =========================
  // 旧メッセージ取得
  // =========================
  // 今までのコードとの互換性のため残す

  Future<List<Map<String, dynamic>>> getMessages() async {
    final snapshot = await _firestore
        .collection("messages")
        .orderBy("createdAt")
        .get();

    return snapshot.docs
        .map((doc) => doc.data())
        .toList();
  }

  // =========================
  // ユーザー情報保存
  // =========================

  Future<void> saveUser({
    required String manufacturer,
    required String bike,
    required String year,
    required String style,
    required String experience,
  }) async {
    await _firestore.collection("users").add({
      "manufacturer": manufacturer,
      "bike": bike,
      "year": year,
      "style": style,
      "experience": experience,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // =========================
  // 最新ユーザー情報取得
  // =========================

  Future<Map<String, dynamic>?> getLatestUser() async {
    final snapshot = await _firestore
        .collection("users")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return snapshot.docs.first.data();
  }

  // =========================
  // 最新ユーザー情報更新
  // =========================

  Future<void> updateLatestUser({
    required String manufacturer,
    required String bike,
    required String year,
    required String style,
  }) async {
    final snapshot = await _firestore
        .collection("users")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final doc = snapshot.docs.first;

    await doc.reference.update({
      "manufacturer": manufacturer,
      "bike": bike,
      "year": year,
      "style": style,
    });
  }
}