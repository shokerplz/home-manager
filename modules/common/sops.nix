{inputs, ...}: {
  flake.homeModules.commonSops = {
    config,
    ...
  }: {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
      ../../secrets/homemanager.nix
    ];

    sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    sops.age.sshKeyPaths = [];

    programs.bash.sessionVariables.OPENROUTER_API_KEY = "$(cat ${config.sops.secrets.openrouter_key.path})";
  };
}
