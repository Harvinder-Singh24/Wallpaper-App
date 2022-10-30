class WallpaperModel {
  String? photgrapher;
  String? photographer_url;
  int? photographer_id;
  SrcModel? srcModel;

  WallpaperModel({
    this.photgrapher,
    this.photographer_id,
    this.photographer_url,
    this.srcModel,
  });

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
        photgrapher: jsonData["photgrapher"],
        photographer_id: jsonData['photgrapher_id'],
        photographer_url: jsonData['photographer_url'],
        srcModel: SrcModel.fromMap(jsonData['src']));
  }
}

class SrcModel {
  String? small;
  String? original;
  String? portrait;

  SrcModel({
    this.original,
    this.portrait,
    this.small,
  });

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      original: jsonData['original'],
      portrait: jsonData['portrait'],
      small: jsonData['small'],
    );
  }
}
