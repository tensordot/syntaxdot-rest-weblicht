{ alpinoTokenizerProtobuf
, syntaxdotModels }:

{
  # Use annotation models from the syntaxdot-models flake.
  annotators = with syntaxdotModels; {
    "de-ud-huge" = de-ud-huge;
    "de-ud-large" = de-ud-large;
    "de-ud-large-albert" = de-ud-large-albert;
    "de-ud-medium" = de-ud-medium;
    "nl-ud-huge" = nl-ud-huge;
    "nl-ud-large" = nl-ud-large;
    "nl-ud-large-albert" = nl-ud-large-albert;
    "nl-ud-medium" = nl-ud-medium;
  };

  # Pipelines, the annotator and tokenizer names should correspond
  # to thise available through the `annotators` and `tokenizers`
  # attribute sets.
  pipelines = {
    "de-ud-huge" = {
      annotator = "de-ud-huge";
      tokenizer = "whitespace_tokenizer";
    };
    "de-ud-large" = {
      annotator = "de-ud-large";
      tokenizer = "whitespace_tokenizer";
    };
    "de-ud-large-albert" = {
      annotator = "de-ud-large-albert";
      tokenizer = "whitespace_tokenizer";
    };
    "de-ud-medium" = {
      annotator = "de-ud-medium";
      tokenizer = "whitespace_tokenizer";
    };
    "nl-ud-huge" = {
      annotator = "nl-ud-huge";
      tokenizer = "whitespace_tokenizer";
    };
    "nl-ud-huge-tokenize" = {
      annotator = "nl-ud-huge";
      tokenizer = "alpino_tokenizer";
    };
    "nl-ud-large" = {
      annotator = "nl-ud-large";
      tokenizer = "whitespace_tokenizer";
    };
    "nl-ud-large-tokenize" = {
      annotator = "nl-ud-large";
      tokenizer = "alpino_tokenizer";
    };
    "nl-ud-large-albert" = {
      annotator = "nl-ud-large-albert";
      tokenizer = "whitespace_tokenizer";
    };
    "nl-ud-large-albert-tokenize" = {
      annotator = "nl-ud-large-albert";
      tokenizer = "alpino_tokenizer";
    };
    "nl-ud-medium" = {
      annotator = "nl-ud-medium";
      tokenizer = "whitespace_tokenizer";
    };
    "nl-ud-medium-tokenize" = {
      annotator = "nl-ud-medium";
      tokenizer = "alpino_tokenizer";
    };
  };

  tokenizers = {
    alpino_tokenizer = {
      alpino_tokenizer = "${alpinoTokenizerProtobuf}";
    };
    whitespace_tokenizer = "whitespace_tokenizer";
  };
}
