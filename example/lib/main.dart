import 'package:flutter/material.dart';
import 'package:ollama_api_client/ollama_api_client.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  /// waiting for the API response
  final _busy = ValueNotifier<bool>(false);

  /// response text from the API call
  final _notifier = ValueNotifier<String>('');

  /// Generate a streamed or batched response
  bool _stream = true;

  /// API has finished prompt generation
  bool _done = true;

  @override
  void initState() {
    super.initState();
  }

  /// [OllamaClient] that makes API calls to a local server by default
  final client = OllamaClient();
  Stream<GenerateResponse>? generatedResponse;

  promptAI({
    bool stream = true,
    String? prompt,
    String? model,
  }) async {
    if (!_done) return;

    _notifier.value = '';
    _done = false;
    _stream = stream;
    _busy.value = true;

    try {
      OllamaApiResult result;
      GenerateRequestParams params;

      model ??= 'codellama:34b';
      prompt ??=
          "What are some great features of the dart programming language?";

      if (stream) {
        params = GenerateRequestParams(
          model: model,
          prompt: prompt,
        );
      } else {
        params = GenerateRequestParams.batched(
          model: model,
          prompt: prompt,
        );
      }

      result = await client.generateStreamed(params);

      if (result.success) {
        result.data?.listen((GenerateResponse response) {
          _notifier.value = "${_notifier.value}${response.response}";
          if (response.done) {
            _done = true;
          }
        });
      } else {
        _notifier.value = 'an error occurred: ${result.error.toString()}';
        _done = true;
      }
    } catch (e) {
      _notifier.value = e.toString();
      _done = true;
    }
    _busy.value = false;
  }

  getTagList() async {
    if (!_done) return;
    _done = false;
    _busy.value = true;
    try {
      OllamaApiResult<ListResponse?> result = await client.tags();
      if (result.success) {
        String text = 'Local Models:\n\n';
        result.data?.models.forEach((element) {
          text += "\n${element.name}";
        });
        _notifier.value = text;
      } else {
        _notifier.value = result.error.toString();
      }
      _done = true;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      _notifier.value = e.toString();
      _done = true;
    }
    _busy.value = false;
  }

  void updateState({busy = false, done = true, text = ''}) {
    _busy.value = busy;
    _done = done;
    _notifier.value = text;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: ValueListenableBuilder(
                valueListenable: _busy,
                builder: (outerContext, busy, _) {
                  if (busy) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.orangeAccent,
                        ),
                        if (!_stream)
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('The bot is thinking'),
                          ),
                      ],
                    );
                  }
                  return ValueListenableBuilder(
                      valueListenable: _notifier,
                      builder: (context, text, _) {
                        return Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  text.trim(),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: _done
                                      ? () => promptAI(stream: !_stream)
                                      : null,
                                  child: const Text('Generate'),
                                ),
                                ElevatedButton(
                                  onPressed: _done ? () => getTagList() : null,
                                  child: const Text('Local Model List'),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                }),
          ),
        ),
      ),
    );
  }
}
