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

  group('TagModel Tests', () {
    test('TagModel fromJson', () {
      Map<String, dynamic> jsonMap = {
        'name': 'testName',
        'modified_at': '2021-09-23T10:00:00Z',
        'size': 128,
        'digest': 'sha256:abcdefghijklmnopqrstuvwxyz',
      };

      TagModel tag = TagModel.fromJson(jsonMap);

      expect(tag.name, equals('testName'));
      expect(tag.modifiedAt, equals('2021-09-23T10:00:00Z'));
      expect(tag.size, equals(128));
      expect(tag.digest, equals('sha256:abcdefghijklmnopqrstuvwxyz'));
    });

    test('TagModel toJson', () {
      TagModel tag = TagModel(
        name: 'testName',
        modifiedAt: '2021-09-23T10:00:00Z',
        size: 128,
        digest: 'sha256:abcdefghijklmnopqrstuvwxyz',
      );

      Map<String, dynamic> jsonRepresentation = tag.toJson();

      expect(jsonRepresentation['name'], equals('testName'));
      expect(jsonRepresentation['modified_at'], equals('2021-09-23T10:00:00Z'));
      expect(jsonRepresentation['size'], equals(128));
      expect(jsonRepresentation['digest'],
          equals('sha256:abcdefghijklmnopqrstuvwxyz'));
    });
  });

  group('GenerateRequest Test', () {
    test('GenerateRequest Test', () {
      GenerateRequestParams params = GenerateRequestParams(
        model: 'llama2:7b',
        prompt: 'hello',
      );
      Uri host = Uri.parse(
          'http://example.com'); // update example.com with the base url you want to use

      try {
        GenerateRequest request = GenerateRequest(params, host: host);
        expect(request.method, 'POST'); // or whatever method you expect
        expect(request.url.toString(),
            'http://example.com/api/generate'); // or whatever url you expect
      } catch (e) {
        fail('It should not throw an error: $e');
      }
    });
  });

  group('TagsRequest', () {
    test(
        'factory method should return instance of TagsRequest with correct method and url properties',
        () async {
      // arrange
      final host = Uri.parse('http://example.com');

      // act
      final request = TagsRequest(host: host);

      // assert
      expect(request.method, 'GET');
      expect(request.url, Uri.parse('http://example.com/api/tags'));
    });
  });

  group('OllamaApiError', () {
    test('should create an OllamaApiError with correct message', () async {
      const errorMessage = 'Failed to fetch data from server';

      final apiError = OllamaApiError(errorMessage);

      expect(apiError.message, errorMessage);
    });
  });
}
