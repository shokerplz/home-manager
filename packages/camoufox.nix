{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  patchelfUnstable,
  alsa-lib,
  dbus-glib,
  gtk3,
  libxtst,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "camoufox";
  version = "152.0.4-beta.28";

  src = fetchzip {
    url = "https://github.com/daijro/camoufox/releases/download/v${finalAttrs.version}/camoufox-${finalAttrs.version}-lin.x86_64.zip";
    hash = "sha256-lWKkapB9Dwg/VL6McP/4eYxc4jmwBXDHXxTnvqbYHsA=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = [
    alsa-lib
    dbus-glib
    gtk3
    libxtst
  ];

  # Camoufox is a Firefox build and uses "relrhack" to process relocations from
  # a fixed offset.
  patchelfFlags = ["--no-clobber-old-sections"];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r . $out/lib/camoufox
    ln -s $out/lib/camoufox/camoufox $out/bin/camoufox

    runHook postInstall
  '';

  meta = {
    description = "Anti-detect Firefox build for Playwright automation";
    homepage = "https://camoufox.com";
    license = lib.licenses.mpl20;
    mainProgram = "camoufox";
    platforms = ["x86_64-linux"];
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
})
