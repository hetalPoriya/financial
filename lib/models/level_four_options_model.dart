class LevelFourOptions {
  int? id;
  int isSelectedOption = 0;
  bool? isSelectedButton;
  String? step;
  String? text;
  String? options1;
  String? options2;
  String? options3;
  String? options4;
  String? options5;
  List<OptionsValue>? optionsValue;

  LevelFourOptions(
      {this.id,
        required this.isSelectedOption,
        this.isSelectedButton,
        this.optionsValue,
        this.text,
        this.step,
        this.options1,
        this.options2,
        this.options3,
        this.options4,
        this.options5});

  factory LevelFourOptions.fromJson(Map<String, dynamic> json) =>
      LevelFourOptions(
        id: json['id'],
        isSelectedOption: json['isSelectedOption'],
        isSelectedButton: json['isSelectedButton'],
        step: json['step'],
        text: json['text'],
        options1: json['options1'],
        options2: json['options2'],
        options3: json['options3'],
        options4: json['options4'],
        options5: json['options5'],
        optionsValue: List<OptionsValue>.from(
            json['optionsValue'].map((x) => OptionsValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'isSelectedOption': isSelectedOption,
    'isSelectedButton': isSelectedButton,
    'step': step,
    'text': text,
    'options1': options1,
    'options2': options2,
    'options3': options3,
    'options4': options4,
    'options5': options5,
    'optionsValue': List<OptionsValue>.from(optionsValue!.map((x) => x.toJson())),
  };
}
class OptionsValue {
  String? description;
  String? image;
  int? rent;
  String? bottomText;
  //int? emi;

  OptionsValue({this.description, this.image, this.rent,this.bottomText});

  factory OptionsValue.fromJson(Map<String, dynamic> json) => OptionsValue(
    image: json['image'],
    //emi: json['emi'],
    description: json['description'],
    rent: json['rent'],
    bottomText: json['bottomText'],
  );

  Map<String, dynamic> toJson() => {
    'image': image,
   // 'emi': emi,
    'description': description,
    'rent': rent,
    'bottomText': bottomText,
  };
}