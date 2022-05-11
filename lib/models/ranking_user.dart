class RankingUser {
  String? userName;
  int? gameScore;
  String? userId;
  int? rank;
  int? lifeStyleScore;
  int? netWorth;
  int? savings;
  int? credit;

  RankingUser({this.userName, this.gameScore,this.userId,this.rank,this.savings,this.netWorth,this.credit,this.lifeStyleScore});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'gameScore': gameScore,
      'userId': userId,
      'rank': rank,
      'lifeStyleScore': lifeStyleScore,
      'netWorth': netWorth,
      'savings': savings,
      'credit': credit,
    };
  }
}
