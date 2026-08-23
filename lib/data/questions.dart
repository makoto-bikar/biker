class QuestionRepository {
  /// Garage情報からおすすめ質問を作成
  static List<String> getQuestionsForUser({
    required String manufacturer,
    required String bike,
    required String year,
    required String style,
    required String experience,
  }) {
    final questions = <String>[
      "$bikeを${style}スタイルにするなら何から始める？",
      "${year}年式の$bikeにおすすめの${style}カスタムは？",
      "${experience}でもできる$bikeの${style}カスタムは？",
      "$bikeに似合う${style}向けのパーツは？",
      "$bikeを${style}にするために必要な工具は？",
      "$bikeの${style}カスタムで注意することは？",
      "${manufacturer} $bikeのおすすめカスタムを教えて",
      "$bikeのカスタムをするなら予算5万円で何ができる？",
    ];

    questions.shuffle();

    return questions.take(4).toList();
  }

  /// メンテナンス系の共通質問
  static final List<String> maintenanceQuestions = [
    "オイル交換のやり方を教えて",
    "チェーン調整を教えて",
    "バッテリー交換したい",
    "エンジンがかからない",
    "異音がする原因は？",
  ];
}