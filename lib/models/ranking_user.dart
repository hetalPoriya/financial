class RankingUser {
  String? userName;
  int? gameScore;

  RankingUser({this.userName, this.gameScore});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'gameScore': gameScore,
    };
  }
}
