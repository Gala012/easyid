class PhotoHistoryEntity {
  final int? id;
  final String imagePath;
  final String thumbnailPath;
  final double width;
  final double height;
  final String unit;
  final String format;
  final String resolution;
  final int brightness;
  final int skinSmoothing;
  final int skinTone;
  final String backgroundColor;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  PhotoHistoryEntity({
    this.id,
    required this.imagePath,
    required this.thumbnailPath,
    required this.width,
    required this.height,
    required this.unit,
    required this.format,
    required this.resolution,
    required this.brightness,
    required this.skinSmoothing,
    required this.skinTone,
    required this.backgroundColor,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_path': imagePath,
      'thumbnail_path': thumbnailPath,
      'width': width,
      'height': height,
      'unit': unit,
      'format': format,
      'resolution': resolution,
      'brightness': brightness,
      'skin_smoothing': skinSmoothing,
      'skin_tone': skinTone,
      'background_color': backgroundColor,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }
  
  factory PhotoHistoryEntity.fromMap(Map<String, dynamic> map) {
    return PhotoHistoryEntity(
      id: map['id'] as int?,
      imagePath: map['image_path'] as String,
      thumbnailPath: map['thumbnail_path'] as String,
      width: map['width'] as double,
      height: map['height'] as double,
      unit: map['unit'] as String,
      format: map['format'] as String,
      resolution: map['resolution'] as String,
      brightness: map['brightness'] as int,
      skinSmoothing: map['skin_smoothing'] as int,
      skinTone: map['skin_tone'] as int,
      backgroundColor: map['background_color'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
