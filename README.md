A collection of classes to make Ollama API server calls for inference and model management

## Getting started

This api client requires a local or remote machine to have Ollama installed and the API server running. It was developed with Flutter 3.13.2 and Dart 3.1.0 on macOS 14.0.

## Usage

```dart
/// 1. Import the package
import 'package:ollama_api_client/ollama_api_client.dart';

/// 2. Create the Ollama Client
final client = OllamaClient();

/// 3. Create a parameter object that describes the request
var parameters = GenerateRequestParams(
    model: 'codellama:34b',
    prompt: 'What are some great features of the dart programming language?',
);

/// 4. Send the request to an Ollama API server
OllamaApiResult result = await client.generateStreamed(parameters);

/// 5. concatenate the response text
if (result.success) {
    String text = '';
    result.data?.listen((GenerateResponse response) {
        text = "$text${response.response}";
        if (response.done) {
            print(text);
        }
      });
}
```