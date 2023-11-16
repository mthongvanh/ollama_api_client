import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:ollama_api_client/ollama_api_client.dart';

class MockClient extends BaseClient {
  late Stream<List<int>> _stream;
  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    _stream = Stream.value('hello'.codeUnits);
    return StreamedResponse(_stream, 200);
  }
}

void main() {
  test('stub test', () async {
    final client = OllamaClient(client: MockClient());
    OllamaApiResult result = await client.generateStreamed(
        GenerateRequestParams(
            model: 'codellama:13b', prompt: 'tell me something'));
    expect(result, isNotNull, reason: 'shouldnt be null');
  });
}
