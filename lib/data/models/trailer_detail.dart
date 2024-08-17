class TrailerDetail {
  String id;
  String key;
  String name;
  String site;
  int size;
  String type;
  bool official;
  String publishedAt;

  TrailerDetail(
    this.id,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
    this.official,
    this.publishedAt
  );
  factory TrailerDetail.fromJson(Map<String, dynamic> json) {
    return TrailerDetail(
      json['id'] as String,
      json['key'] as String,
      json['name'] as String,
      json['site'] as String,
      json['size'] as int,
      json['type'] as String,
      json['official'] as bool,
      json['published_at'] as String,
    );
  }
}