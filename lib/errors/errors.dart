/// Describes errors when making API calls to the Ollama server
class OllamaApiError extends Error {
    /// Message describing the api error.
  final Object? message;

  /// Creates an api error with the provided [message].
  OllamaApiError([this.message]);

  @override
  String toString() {
    if (message != null) {
      return "OllamaAPiError failed: ${Error.safeToString(message)}";
    }
    return "Ollama API Error";
  }
}