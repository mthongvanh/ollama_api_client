import 'params.dart';

/// Parameters for requesting a response to a prompt
/// 
/// The default request parameters will return a streamed response
/// 
/// ### Parameters
///
/// - `model`: (required) the [model name](#model-names)
/// - `prompt`: the prompt to generate a response for
///
/// Advanced parameters (optional):
///
/// - `format`: the format to return a response in. Currently the only accepted value is `json`
/// - `options`: additional model parameters listed in the documentation for the [Modelfile](./modelfile.md#valid-parameters-and-values) such as `temperature`
/// - `system`: system prompt to (overrides what is defined in the `Modelfile`)
/// - `template`: the full prompt or prompt template (overrides what is defined in the `Modelfile`)
/// - `context`: the context parameter returned from a previous request to `/generate`, this can be used to keep a short conversational memory
/// - `stream`: if `false` the response will be returned as a single response object, rather than a stream of objects
/// - `raw`: if `true` no formatting will be applied to the prompt and no context will be returned. You may choose to use the `raw` parameter if you are specifying a full templated prompt in your request to the API, and are managing history yourself.
///
/// There are several factory methods for the different types of possible requests:
/// 
/// - Non-streamed (batched): [GenerateRequestParams.batched]
/// - JSON Mode: [GenerateRequestParams.json]
/// - RAW Mode: [GenerateRequestParams.raw]
/// 
class GenerateRequestParams {
  /// the model name
  final String model;

  /// the prompt to generate a response for
  final String prompt;

  /// system prompt to (overrides what is defined in the `Modelfile`)
  final String? system;

  /// the full prompt or prompt template (overrides what is defined in the `Modelfile`)
  final String? template;

  /// the context parameter returned from a previous request to `/generate`, this can be used to keep a short conversational memory
  final List<int>? context;

  /// if `false` the response will be returned as a single response object, rather than a stream of objects
  final bool? stream;

  /// if `true` no formatting will be applied to the prompt and no context will be returned. You may choose to use the `raw` parameter if you are specifying a full templated prompt in your request to the API, and are managing history yourself.
  final bool? raw;

  /// the format to return a response in. Currently the only accepted value is `json`
  final String? format;

  /// additional model parameters listed in the documentation for the [Modelfile](./modelfile.md#valid-parameters-and-values) such as `temperature`
  final OptionsParams? options;

  GenerateRequestParams._(this.model, this.prompt, this.system, this.template,
      this.context, this.stream, this.raw, this.format, this.options);

  factory GenerateRequestParams(
          {required model,
          required prompt,
          system,
          template,
          context,
          stream,
          raw,
          format,
          options}) =>
      GenerateRequestParams._(
        model,
        prompt,
        system,
        template,
        context,
        stream,
        raw,
        format,
        options,
      );

  toMap() {
    var map = {
      "model": model,
      "prompt": prompt,
      "format": format,
      "options": options,
      "system": system,
      "template": template,
      "context": context,
      "stream": stream,
      "raw": raw,
    };
    map.removeWhere((key, value) {
      return value == null;
    });
    return map;
  }

  /// #### Request (Non-streamed)
  /// Generate a response for a given prompt with a provided model.
  ///
  /// Request to generate a single response object, rather than a stream of objects
  factory GenerateRequestParams.batched(
          {required model,
          required prompt,
          system,
          template,
          context,
          stream = false,
          raw,
          format,
          options}) =>
      GenerateRequestParams._(
        model,
        prompt,
        system,
        template,
        context,
        stream,
        raw,
        format,
        options,
      );

  /// #### Request (JSON mode)
  /// Generate a response for a given prompt with a provided model.
  ///
  /// The value of the `response` will be a string containing JSON
  ///
  /// Example:
  /// ```dart
  /// GenerateRequestParams.json(
  ///   model: "llama2",
  ///   prompt: "What color is the sky at different times of the day? Respond using JSON"
  /// };
  /// ```
  /// #### Response
  /// ```json
  /// {
  ///   "model": "llama2",
  ///   "created_at": "2023-11-09T21:07:55.186497Z",
  ///   "response": "{\n\"morning\": {\n\"color\": \"blue\"\n},\n\"noon\": {\n\"color\": \"blue-gray\"\n},\n\"afternoon\": {\n\"color\": \"warm gray\"\n},\n\"evening\": {\n\"color\": \"orange\"\n}\n}\n",
  ///   "done": true,
  ///   "total_duration": 4661289125,
  ///   "load_duration": 1714434500,
  ///   "prompt_eval_count": 36,
  ///   "prompt_eval_duration": 264132000,
  ///   "eval_count": 75,
  ///   "eval_duration": 2112149000
  /// }
  /// ```
  factory GenerateRequestParams.json(
      {required model,
      required String prompt,
      system,
      template,
      context,
      stream = false,
      raw,
      format = "json",
      options}) {
    assert(prompt.toLowerCase().contains('json'),
        'The prompt must specify a JSON response');
    return GenerateRequestParams._(
      model,
      prompt,
      system,
      template,
      context,
      stream,
      raw,
      format,
      options,
    );
  }

  /// #### Request (Raw mode)
  ///
  /// In some cases you may wish to bypass the templating system and provide a full prompt. In this case, you can use the `raw` parameter to disable formatting and context.
  ///
  /// The value of the `response` will be a string containing JSON
  ///
  /// Example:
  /// ```dart
  /// GenerateRequestParams.raw(
  ///   "model": "mistral",
  ///   "prompt": "[INST] why is the sky blue? [/INST]",
  /// };
  /// ```
  /// #### Response
  /// 
  /// ```json
  /// {
  ///   "model": "mistral",
  ///   "created_at": "2023-11-03T15:36:02.583064Z",
  ///   "response": " The sky appears blue because of a phenomenon called Rayleigh scattering.",
  ///   "done": true,
  ///   "total_duration": 14648695333,
  ///   "load_duration": 3302671417,
  ///   "prompt_eval_count": 14,
  ///   "prompt_eval_duration": 286243000,
  ///   "eval_count": 129,
  ///   "eval_duration": 10931424000
  /// }
  /// ```
  factory GenerateRequestParams.raw(
      {required model,
      required String prompt,
      system,
      template,
      context,
      stream = false,
      raw = true,
      format,
      options}) {
    return GenerateRequestParams._(
      model,
      prompt,
      system,
      template,
      context,
      stream,
      raw,
      format,
      options,
    );
  }
}
