library ollama_api_client;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ollama_api_client/ollama_api_client.dart';
import 'package:ollama_api_client/requests/requests.dart';
import 'package:ollama_api_client/responses/ollama_response.dart';

import 'errors/errors.dart';

export './params/params.dart';
export './responses/responses.dart';
export './api_result.dart';

/// Makes HTTP requests to the Ollama API server.
///
/// The default Ollama API server address is http://localhost:11434/
///
/// https://raw.githubusercontent.com/jmorganca/ollama/main/docs/api.md
/// ## Conventions
///
/// ### Model names
///
/// Model names follow a `model:tag` format. Some examples are `orca-mini:3b-q4_1` and `llama2:70b`. The tag is optional and, if not provided, will default to `latest`. The tag is used to identify a specific version.
///
/// ### Durations
///
/// All durations are returned in nanoseconds.
///
/// ### Streaming responses
///
/// Certain endpoints stream responses as JSON objects delineated with the newline (`\n`) character.
///
class OllamaClient {
  static OllamaClient? instance;
  Uri host;
  final Client _client;

  static const ollamaDefaultHost = 'http://localhost:11434/';

  OllamaClient._(this.host, this._client);

  factory OllamaClient({Uri? host, Client? client}) {
    host ??= Uri.parse(ollamaDefaultHost);
    client ??= Client();
    return instance ?? OllamaClient._(host, client);
  }

  Client get client => _client;

  /// ## Generate a completion
  ///
  /// ```shell
  /// POST /api/generate
  /// ```
  ///
  /// Generate a response for a given prompt with a provided model. This is a streaming endpoint, so will be a series of responses. The final response object will include statistics and additional data from the request.
  ///
  /// ### JSON mode
  ///
  /// Enable JSON mode by setting the `format` parameter to `json` and specifying the model should use JSON in the `prompt`. This will structure the response as valid JSON. See the JSON mode [example](#request-json-mode) below.
  ///
  /// ### Examples
  ///
  /// #### Request
  ///
  /// ```shell
  /// curl -X POST http://localhost:11434/api/generate -d '{
  ///   "model": "llama2",
  ///   "prompt": "Why is the sky blue?"
  /// }'
  ///
  /// Request that returns JSON
  /// curl -X POST http://localhost:11434/api/generate -d '{
  ///   "model": "llama2",
  ///   "prompt": "Why is the sky blue? Respond using JSON"
  ///   "format": "json"
  ///   "stream": "false"
  /// }'
  /// ```
  Future<OllamaApiResult<Stream<GenerateResponse>?>> generateStreamed(
      GenerateRequestParams requestParams,
      {Uri? host}) async {
    try {
      final request = GenerateRequest(requestParams, host: host ?? this.host);
      final response = await client.send(request);
      switch (response.statusCode) {
        case 200:
          return OllamaApiResult<Stream<GenerateResponse>?>(
            true,
            data: OllamaResponse.transform<GenerateResponse>(
              streamedResponse: response,
              builder: (dataMap) => GenerateResponse.fromMap(
                dataMap,
                response: response,
              ),
            ),
          );
        default:
          return OllamaApiResult(
            false,
            error: OllamaApiError('Failed to load data'),
          );
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// ## List Local Models
  ///
  /// ```shell
  /// GET /api/tags
  /// ```
  ///
  /// List models that are available locally.
  ///
  /// ### Examples
  ///
  /// #### Request
  ///
  /// ```shell
  /// curl http://localhost:11434/api/tags
  /// ```
  ///
  /// #### Response
  ///
  /// A single JSON object will be returned.
  ///
  /// ```json
  /// {
  ///   "models": [
  ///     {
  ///       "name": "llama2:7b",
  ///       "modified_at": "2023-08-02T17:02:23.713454393-07:00",
  ///       "size": 3791730596
  ///     },
  ///     {
  ///       "name": "llama2:13b",
  ///       "modified_at": "2023-08-08T12:08:38.093596297-07:00",
  ///       "size": 7323310500
  ///     }
  ///   ]
  /// }
  /// ```
  Future<OllamaApiResult<ListResponse?>> tags({Uri? host}) async {
    try {
      final request = TagsRequest(host: host ?? this.host);
      final response = await client.get(request.url);
      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> dataMap =
              jsonDecode(utf8.decoder.convert(response.bodyBytes));
          return OllamaApiResult<ListResponse?>(
            true,
            data: ListResponse.fromJson(
              dataMap,
              response: response,
            ),
          );
        default:
          return OllamaApiResult(
            false,
            error: OllamaApiError('Failed to load data'),
          );
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
