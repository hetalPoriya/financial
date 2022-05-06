class LevelFiveList{
  int? queId;
  int? month;
  int? emiAmount;

  LevelFiveList({this.queId,this.emiAmount, this.month, });

  Map toMap(){
    return{
      'queId' : queId,
      'emiAmount': emiAmount,
      'month' : month,
    };
  }
}