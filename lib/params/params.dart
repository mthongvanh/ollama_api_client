export './generate_request_params.dart';

class OptionsParams {
  // Predict options used at runtime
  final int? numKeep;
  final int? seed;
  final int? numPredict;
  final int? topK;
  final int? repeatLastN;
  final int? mirostat;
  final double? topP;
  final double? tfsZ;
  final double? typicalP;
  final double? temperature;
  final double? repeatPenalty;
  final double? presencePenalty;
  final double? frequencyPenalty;
  final double? mirostatTau;
  final double? mirostatEta;
  final bool? penalizeNewline;
  final List<String>? stop;

  // Runner options which must be set when the model is loaded into memory
  final bool? useNUMA;
  final int? numCtx;
  final int? numBatch;
  final int? numGQA;
  final int? numGPU;
  final int? mainGPU;
  final bool? lowVRAM;
  final bool? f16KV;
  final bool? logitsAll;
  final bool? vocabOnly;
  final bool? useMMap;
  final bool? useMLock;
  final bool? embeddingOnly;
  final double? ropeFrequencyBase;
  final double? ropeFrequencyScale;
  final int? numThread;

  OptionsParams(
      this.numKeep,
      this.seed,
      this.numPredict,
      this.topK,
      this.repeatLastN,
      this.mirostat,
      this.topP,
      this.tfsZ,
      this.typicalP,
      this.temperature,
      this.repeatPenalty,
      this.presencePenalty,
      this.frequencyPenalty,
      this.mirostatTau,
      this.mirostatEta,
      this.penalizeNewline,
      this.stop,
      this.useNUMA,
      this.numCtx,
      this.numBatch,
      this.numGQA,
      this.numGPU,
      this.mainGPU,
      this.lowVRAM,
      this.f16KV,
      this.logitsAll,
      this.vocabOnly,
      this.useMMap,
      this.useMLock,
      this.embeddingOnly,
      this.ropeFrequencyBase,
      this.ropeFrequencyScale,
      this.numThread);

  factory OptionsParams.defaultOptions({
    // options set on request to runner
    numPredict = -1,
    numKeep = 0,
    temperature = 0.8,
    topK = 40,
    topP = 0.9,
    tfsZ = 1.0,
    typicalP = 1.0,
    repeatLastN = 64,
    repeatPenalty = 1.1,
    presencePenalty = 0.0,
    frequencyPenalty = 0.0,
    mirostat = 0,
    mirostatTau = 5.0,
    mirostatEta = 0.1,
    penalizeNewline = true,
    seed = -1,
    stop,
    // options set when the model is loaded
    numCtx = 2048,
    ropeFrequencyBase = 10000.0,
    ropeFrequencyScale = 1.0,
    numBatch = 512,
    logitsAll,
    vocabOnly,
    mainGPU,
    numGPU = -1, // -1 here indicates that NumGPU should be set dynamically
    numGQA = 1,
    numThread = 0, // let the runtime decide
    lowVRAM = false,
    f16KV = true,
    useMLock = false,
    useMMap = true,
    useNUMA = false,
    embeddingOnly = true,
  }) =>
      OptionsParams(
        numKeep,
        seed,
        numPredict,
        topK,
        repeatLastN,
        mirostat,
        topP,
        tfsZ,
        typicalP,
        temperature,
        repeatPenalty,
        presencePenalty,
        frequencyPenalty,
        mirostatTau,
        mirostatEta,
        penalizeNewline,
        stop,
        useNUMA,
        numCtx,
        numBatch,
        numGQA,
        numGPU,
        mainGPU,
        lowVRAM,
        f16KV,
        logitsAll,
        vocabOnly,
        useMMap,
        useMLock,
        embeddingOnly,
        ropeFrequencyBase,
        ropeFrequencyScale,
        numThread,
      );
}

class EmbeddingRequestParams {
  final String model;
  final String prompt;

  final OptionsParams? options;

  EmbeddingRequestParams(this.model, this.prompt, this.options);
}

class CreateRequestParams {
  final String name;
  final String path;
  final bool? stream;

  CreateRequestParams(this.name, this.path, this.stream);
}

class DeleteRequestParams {
  final String name;

  DeleteRequestParams(this.name);
}

class ShowRequestParams {
  final String name;

  ShowRequestParams(this.name);
}

class CopyRequestParams {
  final String source;
  final String destination;

  CopyRequestParams(this.source, this.destination);
}

class PullRequestParams {
  final String name;
  final String username;
  final String password;
  final bool? insecure;
  final bool? stream;

  PullRequestParams(
      this.name, this.username, this.password, this.insecure, this.stream);
}

class PushRequestParams {
  final String name;
  final String username;
  final String password;
  final bool? insecure;
  final bool? stream;

  PushRequestParams(
      this.name, this.username, this.password, this.insecure, this.stream);
}
