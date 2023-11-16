import 'package:http/http.dart';

/// ## List Local Models
/// List models that are available locally.
///
/// A single JSON object will be returned.
///
/// ### Examples
/// ```dart
///      final request = TagsRequest();
///      final response = await client.get(request.url);
///      switch (response.statusCode) {
///        case 200:
///          Map<String, dynamic> dataMap =
///              jsonDecode(utf8.decoder.convert(response.bodyBytes));
///          return OllamaApiResult<ListResponse?>(
///            true,
///            data: ListResponse.fromJson(
///              dataMap,
///              response: response,
///            ),
///          );
///        default:
///          return OllamaApiResult(
///            false,
///            error: OllamaApiError('Failed to load data'),
///          );
///      }
/// ```
class TagsRequest extends Request {
  static const endpoint = 'api/tags';

  TagsRequest._(super.method, super.url);
  factory TagsRequest({required Uri host}) {
    try {
      Uri url = host.resolve(endpoint);
      final req = TagsRequest._('GET', url);
      req.followRedirects = true;
      return req;
    } catch (e) {
      rethrow;
    }
  }
}
