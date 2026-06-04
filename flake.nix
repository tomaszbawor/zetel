{
  description = "zetel CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          bunCache = pkgs.stdenvNoCC.mkDerivation {
            pname = "zetel-bun-cache";
            version = "0.1.0";

            src = ./.;
            nativeBuildInputs = [ pkgs.bun ];

            dontConfigure = true;
            dontBuild = true;

            installPhase = ''
              runHook preInstall

              export HOME="$TMPDIR"
              mkdir -p "$out"
              bun install --frozen-lockfile --ignore-scripts --cache-dir "$out"

              runHook postInstall
            '';

            outputHashAlgo = "sha256";
            outputHashMode = "recursive";
            outputHash = "sha256-XEILnn+21l+xFLYINDBxpfdrZyuXQAcrkM6p3NMX3IQ=";
          };
        in
        {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "zetel";
            version = "0.1.0";

            src = ./.;
            nativeBuildInputs = [
              pkgs.biome
              pkgs.bun
              pkgs.makeWrapper
              pkgs.nodejs
            ];

            configurePhase = ''
              runHook preConfigure

              export HOME="$TMPDIR"
              cp -R ${bunCache} "$TMPDIR/bun-cache"
              chmod -R u+w "$TMPDIR/bun-cache"
              bun install --frozen-lockfile --ignore-scripts --offline --cache-dir "$TMPDIR/bun-cache"
              patchShebangs node_modules

              runHook postConfigure
            '';

            buildPhase = ''
              runHook preBuild

              biome check .
              node node_modules/typescript/bin/tsc --noEmit
              bun build src/main.ts --outdir dist --target bun

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              install -Dm755 dist/main.js "$out/libexec/zetel/main.js"
              makeWrapper ${pkgs.bun}/bin/bun "$out/bin/zetel" \
                --add-flags "$out/libexec/zetel/main.js"

              runHook postInstall
            '';
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.bun
              pkgs.git
              pkgs.nixfmt
            ];

            shellHook = ''
              echo "zetel dev shell"
              echo "  bun install"
              echo "  bun run check"
              echo "  nix build"
            '';
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
