{
  pkgs,
  ...
}:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "playit-agent";
  version = "0.16.3";
  meta.mainProgram = "playit-cli";

  src = pkgs.fetchFromGitHub {
    owner = "playit-cloud";
    repo = "playit-agent";
    tag = "v${version}";
    sha256 = "sha256-i+v1oyssmeOoMXcyJ8nnS0nTwfKJXXIiIu3KAXBzH1I=";
  };

  doCheck = false;

  cargoLock.lockFile = "${src}/Cargo.lock";
}
