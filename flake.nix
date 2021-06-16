{
  description = "SyntaxDot REST server images for WebLicht";

  inputs = rec {
    nixpkgs.follows = "syntaxdot-rest/nixpkgs";
    syntaxdot-models.url = "github:tensordot/syntaxdot-models";
    syntaxdot-rest.url = "github:tensordot/syntaxdot-rest";
    utils.follows = "syntaxdot-rest/utils";
  };

  outputs = { self, nixpkgs, syntaxdot-models, syntaxdot-rest, utils }:
    utils.lib.eachSystem  [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in {
      defaultPackage = self.packages.${system}.server;

      packages =
        let
          # Shorthand for the syntaxdot-rest package.
          syntaxdotRest = syntaxdot-rest.defaultPackage.${system};

          # Arguments for docker image builders.
          dockerImageArgs = {
            name = "danieldk/syntaxdot-rest-server";
            tag = syntaxdotRest.version;
            config.Entrypoint = [  "${self.packages.${system}.server}/bin/syntaxdot-rest" ];
            maxLayers = 100;
          };

          # Function to combine multiple pipelines into a syntaxdot-rest configuration.
          mkPipelineSet = pkgs.callPackage ./pipeline-set.nix {};

          # Alpino tokenizer protobuf.
          alpinoTokenizerProtobuf = pkgs.fetchurl {
            name = "alpino-tokenizer.proto";
            url = "https://github.com/danieldk/alpino-tokenizer/releases/download/0.3.0/alpino-tokenizer-20200315.proto.gz";
            hash = "sha256-mB+BvjKV9jXbqzj2L1uRWGIhyiT7Y5BLVQmJPtxExL4=";
            downloadToTemp = true;
            postFetch = ''
              gunzip -c $downloadedFile > $out
            '';
          };

          # Weblicht pipelines
          weblichtPipelines = import ./weblicht-pipelines.nix {
            inherit alpinoTokenizerProtobuf;
            syntaxdotModels = syntaxdot-models.packages.${system};
          };
        in {
          pipelines = mkPipelineSet weblichtPipelines;

          server = with pkgs; runCommand "syntaxdot-rest-with-pipelines" { nativeBuildInputs = [ makeWrapper ]; } ''
            makeWrapper \
              ${syntaxdotRest}/bin/syntaxdot-rest \
              $out/bin/syntaxdot-rest \
              --add-flags "${self.packages.${system}.pipelines}"
          '';

          dockerImage = pkgs.dockerTools.buildLayeredImage dockerImageArgs;

          streamDockerImage = pkgs.dockerTools.streamLayeredImage dockerImageArgs;
        };
    });
}
