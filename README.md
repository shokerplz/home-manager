# Home Manager

## Everyday Commands

Inspect the exported outputs:

```bash
nix flake show --all-systems --no-write-lock-file
```

List configured Home Manager profiles:

```bash
nix eval --json '.#homeConfigurations' --apply builtins.attrNames
```

Build a Home Manager activation package without switching:

```bash
nix build '.#homeConfigurations."ikovalev@main-pc".activationPackage'
```

Switch the current user configuration:

```bash
home-manager switch --flake .#ikovalev@main-pc
```

## Adding A New Host

1. Create `modules/hosts/<name>/default.nix`.
2. Export `flake.homeConfigurations."ikovalev@<name>"` with `withSystem` and
   `inputs.home-manager.lib.homeManagerConfiguration`.
3. Pick the correct shared module. Linux desktop hosts should usually import
   `self.homeModules.commonLinuxDesktop`.
4. Set `home.username`, `home.homeDirectory`, and `home.stateVersion` in the
   host module.
5. Add host-local `_packages.nix`, `_programs.nix`, or `noctalia.json` files
   when the machine needs overrides.
6. Build the activation package before switching:
   `nix build '.#homeConfigurations."ikovalev@<name>".activationPackage'`.
7. Switch with `home-manager switch --flake .#ikovalev@<name>`.

## Configuration Rules

Prefer `programs.<package>` over adding the package directly to `home.packages`
when Home Manager has a module for it. The module usually provides activation
hooks, generated config files, shell integration, or service wiring that a plain
package install does not.

Use `home.packages` when there is no useful Home Manager module yet, or when the
package is intentionally just a user-installed tool.

General placement rules:

- put settings that apply to every user configuration in `modules/common/`
- put Linux desktop settings in `modules/common/linux-desktop.nix` or
  `modules/desktops/`
- put platform-specific settings in `modules/platforms/`
- put machine-specific settings in `modules/hosts/<name>/`

## Secrets

Secrets use `sops-nix` through the Home Manager module imported by
`homeModules.commonSops`.

Current setup:

- encrypted data lives in `secrets/homemanager.yaml`
- `secrets/homemanager.nix` declares the Home Manager `sops.secrets` entries
- Home Manager reads the age key from `~/.config/sops/age/keys.txt`

Create a personal age key:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

Private key location:

```text
~/.config/sops/age/keys.txt
```

Edit the Home Manager secret file:

```bash
nix-shell -p sops --run "sops secrets/homemanager.yaml"
```

### Adding A Secret To Nix Code

Keep encrypted data and the Nix wrapper side by side in `secrets/`.

Example from `secrets/homemanager.nix`:

```nix
{...}: let
  homemanagerSecretFile = ./homemanager.yaml;
in {
  sops.secrets.openrouter_key = {
    sopsFile = homemanagerSecretFile;
  };
}
```

Then consume the declared secret from a Home Manager module:

```nix
programs.bash.sessionVariables.SECRET =
  "$(cat ${config.sops.secrets.secret.path})";
```

Useful rule of thumb:

- use `config.sops.secrets.<name>.path` when a program can read a secret file
  directly
- use `sops.templates` when a program needs an env file or rendered config file

## Desktop Notes

The Linux desktop profile is Hyprland-based and includes Noctalia Shell.

Noctalia uses json settings file that can be generated via:

```bash
noctalia-shell ipc call state all
```

- shared Hyprland config: `modules/desktops/hyprland/default.nix`
- shared Noctalia module: `modules/desktops/hyprland/noctalia.nix`
- default Noctalia settings: `modules/desktops/hyprland/noctalia.json`
- host Noctalia settings: `modules/hosts/<name>/noctalia.json`

Host configs set `dotfiles.noctalia.settingsFile` when they need machine-local
Noctalia settings.

The Hyprland module creates placeholder files for `~/.config/hypr/monitors.conf`
and `~/.config/hypr/gaming.conf` so host-local generated or manual overrides can
be sourced without breaking startup.
