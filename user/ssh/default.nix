{ ... }:
{
  services.ssh-agent.enable = true;
  # Symlink public ssh keys
  home.file = {
    ".ssh/allowed_signers".text = ''
      * ${builtins.readFile ./uni.pub}
      * ${builtins.readFile ./dev.pub}
    '';
    ".ssh/dev.pub".source = ./dev.pub;
    ".ssh/uni.pub".source = ./uni.pub;
  };
}
