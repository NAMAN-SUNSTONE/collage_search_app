class LmsQuizSessionData{
  final String sessionUrl;

  LmsQuizSessionData({required this.sessionUrl});

  Map<String, dynamic> toJson() => {
    'url': sessionUrl,
  };

  factory LmsQuizSessionData.fromJson(Map<String, dynamic> json) {
    return LmsQuizSessionData(
      sessionUrl: json['url'],
    );
  }

}