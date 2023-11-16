import 'package:http/http.dart';
import 'package:ollama_api_client/entities/tag_model.dart';

import 'ollama_response.dart';

/// ## List Local Models
/// List of models that are available locally.
class ListResponse extends OllamaResponse {
  final List<TagModel> models;
  ListResponse(
    this.models,
    super._rawResponse,
  );

  static fromJson(Map<String, dynamic> jsonMap,
      {required BaseResponse response}) {
    var models = jsonMap['models'];

    List<TagModel>? localModels;
    if (models is List<dynamic>) {
      localModels =
          models.map((e) => TagModel.fromJson(e) as TagModel).toList();
    }

    return ListResponse(
      localModels ?? <TagModel>[],
      response,
    );
  }
}
