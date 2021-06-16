{ lib
, runCommandNoCC
, remarshal
}:

{ annotators
, pipelines
, tokenizers
}:

let
  # Convert a Nix value to YAML by using the built-in JSON support and then
  # converting JSON to YAML using remarshal.
  toYAML = name: value: runCommandNoCC name
    {
      nativeBuildInputs = [ remarshal ];
      value = builtins.toJSON value;
      passAsFile = [ "value" ];
    } ''
    json2yaml "$valuePath" "$out"
  '';

  defaultPipelineSettings = {
    batch_size = 32;
    read_ahead = 200;
  };

  # Map annotator derivations to their configuration files.
  annotators' =
    let
      annotatorConfig = _: drv: {
        syntaxdot_config = "${drv.out}/share/syntaxdot/models/${drv.pname}/syntaxdot.conf";
        max_len = 150;
      };
    in
    lib.mapAttrs annotatorConfig annotators;

  # Add default settings and descriptions to the pipelines.
  pipelines' =
    let
      addAttrs = _: pipeline: pipeline // defaultPipelineSettings // {
        description = annotators.${pipeline.annotator}.meta.description;
      };
    in
    lib.mapAttrs addAttrs pipelines;

  # REST server configuration.
  config = {
    inherit tokenizers;

    annotators = annotators';
    pipelines = pipelines';
  };
in toYAML "syntaxdot-rest.conf" config
