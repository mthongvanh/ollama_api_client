import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

typedef OllamaResponseBuilder<T extends OllamaResponse> = T Function(
    Map<String, dynamic>);

/// Base Ollama API response extended by endpoint responses, such as [GenerateResponse]
class OllamaResponse implements BaseResponse {
  final BaseResponse _rawResponse;

  OllamaResponse(this._rawResponse);

  @override
  int? get contentLength => _rawResponse.contentLength;

  @override
  Map<String, String> get headers => _rawResponse.headers;

  @override
  bool get isRedirect => _rawResponse.isRedirect;

  @override
  bool get persistentConnection => _rawResponse.persistentConnection;

  @override
  String? get reasonPhrase => _rawResponse.reasonPhrase;

  @override
  BaseRequest? get request => _rawResponse.request;

  @override
  int get statusCode => _rawResponse.statusCode;

  static Stream<T> transform<T extends OllamaResponse>(
      {required StreamedResponse streamedResponse,
      required OllamaResponseBuilder<T> builder}) async* {
    await for (var data in streamedResponse.stream) {
      try {
        Map<String, dynamic> dataMap = jsonDecode(utf8.decoder.convert(data));
        final T r = builder(dataMap);
        yield r;
      } catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }
  }
}
