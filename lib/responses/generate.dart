import 'package:http/http.dart';

import 'ollama_response.dart';

/// AI response generated in reply to a user prompt
///
/// #### Response
/// 
/// If stream is set to false, the response will be a single JSON object. 
/// 
/// - `total_duration`: time spent generating the response
/// - `load_duration`: time spent in nanoseconds loading the model
/// - `sample_count`: number of samples generated
/// - `sample_duration`: time spent generating samples
/// - `prompt_eval_count`: number of tokens in the prompt
/// - `prompt_eval_duration`: time spent in nanoseconds evaluating the prompt
/// - `eval_count`: number of tokens the response
/// - `eval_duration`: time in nanoseconds spent generating the response
/// - `context`: an encoding of the conversation used in this response, this can be sent in the next request to keep a conversational memory
/// - `response`: empty if the response was streamed, if not streamed, this will contain the full response
///
/// To calculate how fast the response is generated in tokens per second (token/s), divide `eval_count` / `eval_duration`.
class GenerateResponse extends OllamaResponse {
  final String model;
  final String createdAt;
  final String response;

  final bool done;

  final List<int>? context;

  final int? totalDuration;
  final int? loadDuration;
  final int? promptEvalCount;
  final int? promptEvalDuration;
  final int? evalCount;
  final int? evalDuration;

  GenerateResponse(
    this.model,
    this.createdAt,
    this.response,
    this.done,
    this.context,
    this.totalDuration,
    this.loadDuration,
    this.promptEvalCount,
    this.promptEvalDuration,
    this.evalCount,
    this.evalDuration,
    super._rawResponse,
  );

  static fromMap(Map<String, dynamic> jsonMap,
      {required BaseResponse response}) {
    return GenerateResponse(
      jsonMap['model'],
      jsonMap['created_at'],
      jsonMap['response'],
      jsonMap['done'],
      jsonMap['context'] is List<int> ? jsonMap['context'] : null,
      jsonMap['totalDuration'],
      jsonMap['loadDuration'],
      jsonMap['promptEvalCount'],
      jsonMap['promptEvalDuration'],
      jsonMap['evalCount'],
      jsonMap['evalDuration'],
      response,
    );
  }
}
