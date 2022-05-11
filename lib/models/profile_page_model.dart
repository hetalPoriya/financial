class LevelsModel {
  int? id;
  String? level;
  String? goal;
  String? description;
  String? levelProgress;
  String? popQuizProgress;

  LevelsModel(
      {this.id,
        this.level,
        this.goal,
        this.description,
        this.levelProgress,
        this.popQuizProgress,});

  factory LevelsModel.fromJson(Map<String, dynamic> json) => LevelsModel(
    id: json["id"],
    level: json["level"],
    goal: json["goal"],
    description: json["description"],
    levelProgress: json["levelProgress"],
    popQuizProgress: json["popQuizProgress"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "level": level,
    "goal": goal,
    "description": description,
    "levelProgress": levelProgress,
    "popQuizProgress": popQuizProgress,
  };
}
