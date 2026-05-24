class TextToSQLRequest {
  final String question;

  TextToSQLRequest({
    required this.question,
  });

  Map<String, dynamic> toJson() {
    return {
      "question": question,
    };
  }

  factory TextToSQLRequest.fromJson(Map<String, dynamic> json) {
    return TextToSQLRequest(
      question: json["question"] ?? "",
    );
  }
}