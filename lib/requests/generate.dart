import 'dart:convert';

import 'package:http/http.dart';

import '../params/params.dart';

/// ## Generate a completion
/// Generate a response for a given prompt with a provided model. 
/// 
/// This is a streaming endpoint, so will be a series of 
/// responses. The final response object will include statistics 
/// and additional data from the request.
///
/// If [GenerateRequestParams.stream] is set to `false`, the response will be a 
/// single JSON object.
///
/// Streaming Example:
/// ```dart
///   final request = GenerateRequest(
///     GenerateRequestParams(model: 'llama2:7b', prompt: 'what is a LLM?'),
///   );
///   final response = await client.send(request);
///   switch (response.statusCode) {
///     case 200:
///       return OllamaApiResult<Stream<GenerateResponse>?>(true,
///           data: _handleStreamedResponse(response));
///     default:
///       return OllamaApiResult(false,
///           error: OllamaApiError('Failed to load data'));
///   }
/// ```
/// 
class GenerateRequest extends Request {
  static const endpoint = 'api/generate';

  GenerateRequest._(super.method, super.url);
  factory GenerateRequest(GenerateRequestParams parameters,
      {required Uri host, String? method}) {
    try {
      Uri url = host.resolve(endpoint);
      final req = GenerateRequest._(method ?? 'POST', url);
      req.followRedirects = true;
      var bodyString = jsonEncode(parameters.toMap());
      req.body = bodyString;
      return req;
    } catch (e) {
      rethrow;
    }
  }
}
