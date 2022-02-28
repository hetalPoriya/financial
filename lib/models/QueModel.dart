class QueModel {
  int? id;
  String? selectedOption;
  bool? isSelected1;
  bool? isSelected2;
  bool? isSelected3;
  bool? isSelected4;

  QueModel(
      {this.id,
      this.selectedOption,
      this.isSelected1,
      this.isSelected2,
      this.isSelected3,
      this.isSelected4});

  factory QueModel.fromJson(Map<String, dynamic> json) => QueModel(
        id: json["id"],
        isSelected1: json["isSelected1"],
        isSelected2: json["isSelected2"],
        isSelected3: json["isSelected3"],
        isSelected4: json["isSelected4"],
        selectedOption: json["selectedOption"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isSelected1": isSelected1,
        "isSelected2": isSelected2,
        "isSelected3": isSelected3,
        "isSelected4": isSelected4,
        "selectedOption": selectedOption,
      };
}
