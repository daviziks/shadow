{ pkgs, ... }:
let
  codexVersion = "0.142.5";
  codexCli = pkgs.stdenvNoCC.mkDerivation {
    pname = "codex";
    version = codexVersion;

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@openai/codex/-/codex-${codexVersion}-linux-x64.tgz";
      hash = "sha512-pxY+d3NgNE57Y/MApD3/TZUAygxJN6I9h3ZeDUwe67mxWjUxsuapxMRFTKSznCalYbRAeZp752+AAXmUbmguEg==";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/codex" "$out/bin"
      cp -R vendor/x86_64-unknown-linux-musl "$out/share/codex/"
      ln -s "$out/share/codex/x86_64-unknown-linux-musl/bin/codex" "$out/bin/codex"
      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = [
    codexCli
    pkgs.bubblewrap
  ];
}
