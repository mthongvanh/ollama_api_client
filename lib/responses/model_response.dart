import 'package:http/http.dart';

import 'ollama_response.dart';

/// ## Show Model Information
/// Show details about a model including modelfile, template, parameters, license, and system prompt.
class ModelResponse extends OllamaResponse {
  final String license;
  final String modelfile;
  final String parameters;
  final String template;

  ModelResponse(
    this.license,
    this.modelfile,
    this.parameters,
    this.template,
    super._rawresponse,
  );

  static fromJson(Map<String, dynamic> jsonMap,
      {required BaseResponse response}) {
    return ModelResponse(
      jsonMap['license'],
      jsonMap['modelfile'],
      jsonMap['parameters'],
      jsonMap['template'],
      response,
    );
  }
}
