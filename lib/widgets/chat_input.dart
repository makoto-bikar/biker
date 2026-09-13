import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          4,
          18,
          22,
        ),

        child: Container(
          height: 46,

          decoration: BoxDecoration(
            // =====================================================
            // 入力欄
            // 質問カードと同じ色味
            // =====================================================

            color: Colors.white.withOpacity(0.10),

            borderRadius:
                BorderRadius.circular(23),

            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1,
            ),
          ),

          child: Row(
            children: [

              // =====================================================
              // 質問入力欄
              // =====================================================

              Expanded(
                child: TextField(
                  controller: controller,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),

                  cursorColor: Colors.white,

                  textInputAction:
                      TextInputAction.send,

                  onSubmitted: (_) {
                    if (controller.text
                        .trim()
                        .isNotEmpty) {
                      onSend();
                    }
                  },

                  decoration:
                      const InputDecoration(
                    hintText:
                        "AIに質問してみよう...",

                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),

                    border:
                        InputBorder.none,

                    enabledBorder:
                        InputBorder.none,

                    focusedBorder:
                        InputBorder.none,

                    contentPadding:
                        EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                ),
              ),

              // =====================================================
              // 送信ボタン
              // =====================================================

              Padding(
                padding:
                    const EdgeInsets.only(
                  right: 6,
                ),

                child: GestureDetector(
                  behavior:
                      HitTestBehavior.opaque,

                  onTap: () {
                    if (controller.text
                        .trim()
                        .isNotEmpty) {
                      onSend();
                    }
                  },

                  child: Container(
                    width: 34,
                    height: 34,

                    decoration:
                        const BoxDecoration(
                      // =================================================
                      // モノトーン・高級感
                      // =================================================

                      color:
                          Color(0xFFD8D8D8),

                      shape:
                          BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.arrow_upward,

                      color:
                          Colors.black,

                      size: 17,
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