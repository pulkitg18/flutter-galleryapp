import 'dart:convert';

List<ArtsModel> artsModelFromJson(String str) => List<ArtsModel>.from(
    json.decode(str)["data"].map((x) => ArtsModel.fromJson(x)));

class ArtsModel {
  ArtsModel(
      {required this.title,
      required this.imageId,
      required this.artistDisplay});

  String title;
  String imageId;
  String artistDisplay;

  factory ArtsModel.fromJson(Map<String, dynamic> json) => ArtsModel(
        title: json["title"],
        artistDisplay: json["artist_display"],
        imageId: json["image_id"] == null
            ? "https://www.artic.edu/iiif/2/1adf2696-8489-499b-cad2-821d7fde4b33/full/843,/0/default.jpg"
            : "https://www.artic.edu/iiif/2/${json["image_id"]}/full/843,/0/default.jpg",
      );
}
