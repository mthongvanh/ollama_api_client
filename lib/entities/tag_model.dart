/// Represents a local model available to Ollama
///
/// Returned in a list on [ListResponse.models]
class TagModel {
  final String name;
  final String modifiedAt;
  final int size;
  final String digest;

  TagModel._(
    this.name,
    this.modifiedAt,
    this.size,
    this.digest,
  );
  factory TagModel({
    required String name,
    required modifiedAt,
    required int size,
    required String digest,
  }) =>
      TagModel._(name, modifiedAt, size, digest);

  static fromJson(Map<String, dynamic> jsonMap) {
    // jsonMap.map(
    //   (key, value) => assert(value != null, 'values should not be null'),
    // );
    return TagModel(
      name: jsonMap['name'],
      modifiedAt: jsonMap['modified_at'],
      size: jsonMap['size'],
      digest: jsonMap['digest'],
    );
  }

  toJson() {
    Map<String, dynamic> jsonRepresentation = {
      'name': name,
      'modified_at': modifiedAt,
      'size': size,
      'digest': digest,
    };
    return jsonRepresentation.removeWhere((key, value) => value == null);
  }
}
