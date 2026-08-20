{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  nodejs,
  camoufox,
}: let
  # Camoufox tracks Playwright's Firefox protocol at <1.61, so the newer
  # playwright-mcp in nixpkgs cannot drive it. 0.0.74 is the last release built
  # against playwright-core 1.60, which holds all of the MCP implementation.
  playwrightVersion = "1.60.0-alpha-1778101408000";

  playwright-core = fetchurl {
    url = "https://registry.npmjs.org/playwright-core/-/playwright-core-${playwrightVersion}.tgz";
    hash = "sha256-lxYf2n1Buunt6o8K7LEkhZ7jC8r1u2GVgvoF7CgAc8E=";
  };

  playwright = fetchurl {
    url = "https://registry.npmjs.org/playwright/-/playwright-${playwrightVersion}.tgz";
    hash = "sha256-WgXyjypHPRqf0hWAzFmN5R/WG/g8ULoVSaweYjPZFxM=";
  };

  # Launched without a fingerprint config, Camoufox advertises itself in the
  # user agent. Replace it with the stock Firefox one for the same release.
  camouConfig = builtins.toJSON {
    "navigator.userAgent" = "Mozilla/5.0 (X11; Linux x86_64; rv:${lib.versions.major camoufox.version}.0) Gecko/20100101 Firefox/${lib.versions.major camoufox.version}.0";
  };
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "camoufox-mcp";
    version = "0.0.74";

    src = fetchurl {
      url = "https://registry.npmjs.org/@playwright/mcp/-/mcp-${finalAttrs.version}.tgz";
      hash = "sha256-+VERw7xfDzYkSFTPghVowrO4MD2l2Z/hE/y45YuX3r4=";
    };

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall

      pkgdir=$out/lib/node_modules/@playwright/mcp
      mkdir -p $pkgdir/node_modules/playwright-core $pkgdir/node_modules/playwright
      cp -r . $pkgdir
      tar xf ${playwright-core} --strip-components=1 -C $pkgdir/node_modules/playwright-core
      tar xf ${playwright} --strip-components=1 -C $pkgdir/node_modules/playwright

      makeWrapper ${lib.getExe nodejs} $out/bin/camoufox-mcp \
        --add-flags $pkgdir/cli.js \
        --set-default PLAYWRIGHT_MCP_BROWSER firefox \
        --set-default PLAYWRIGHT_MCP_EXECUTABLE_PATH ${lib.getExe camoufox} \
        --set-default CAMOU_CONFIG '${camouConfig}'

      runHook postInstall
    '';

    meta = {
      description = "Playwright MCP server driving the Camoufox browser";
      homepage = "https://github.com/microsoft/playwright-mcp";
      license = lib.licenses.asl20;
      mainProgram = "camoufox-mcp";
      inherit (camoufox.meta) platforms;
    };
  })
