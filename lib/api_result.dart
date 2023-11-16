import 'package:ollama_api_client/errors/errors.dart';

/// Result from API call that indicates success or failure
///
/// In case of a successful API call, [data] will not be null
/// and [error] will be null. Vice-versa, failed API calls will
/// return a null [data] object and non-null [error] object.
class OllamaApiResult<T> {
  final bool success;
  final T? data;
  final OllamaApiError? error;

  const OllamaApiResult._(this.success, this.data, this.error);
  factory OllamaApiResult(success, {T? data, OllamaApiError? error}) =>
      OllamaApiResult._(success, data, error);
}
