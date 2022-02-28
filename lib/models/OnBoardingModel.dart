class OnBoardingPageValue {
  String? imageLine1;
  String? imageLine2;
  List<SliderData> sliderData;

  OnBoardingPageValue({this.imageLine1, this.imageLine2, required this.sliderData});

  factory OnBoardingPageValue.fromJson(Map<String, dynamic> json) =>
      OnBoardingPageValue(
        imageLine1: json['imageLine1'],
        imageLine2: json['imageLine2'],
        sliderData: List<SliderData>.from(
            json['sliderData'].map((e) => SliderData.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {
        'imageLine1': imageLine1,
        'imageLine2': imageLine2,
      };
}

class SliderData {
  String? image;
  String? text;
  String? description;

  SliderData({this.image, this.text, this.description});

  factory SliderData.fromJson(Map<String, dynamic> json) =>
      SliderData(
        description: json['description'],
        text: json['text'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() =>
      {
        'description': description,
        'text': text,
        'image': image,
      };
}