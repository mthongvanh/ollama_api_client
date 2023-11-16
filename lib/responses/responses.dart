import 'ollama_response.dart';

export './generate.dart';
export 'list_response.dart';
export 'model_response.dart';

class TokenResponse extends OllamaResponse {
  final String token;

  TokenResponse(this.token, super._rawResponse);
}

class ShowResponse extends OllamaResponse {
  final String? license;
  final String? modelfile;
  final String? parameters;
  final String? template;
  final String? system;

  ShowResponse(
    this.license,
    this.modelfile,
    this.parameters,
    this.template,
    this.system,
    super._rawResponse,
  );
}

class ProgressResponse extends OllamaResponse {
  final String status;
  final String? digest;
  final int? total;
  final int? completed;

  ProgressResponse(
    this.status,
    this.digest,
    this.total,
    this.completed,
    super._rawResponse,
  );
}

class EmbeddingResponse extends OllamaResponse {
  final List<double>? embedding;

  EmbeddingResponse(
    this.embedding,
    super._rawResponse,
  );
}
