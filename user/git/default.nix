{ config, pkgs, lib, pkgs-unstable, inputs, userSettings, ... }:
{  # configure git
  programs.git = {
    enable = true;
    userName = "LazyStability";
    userEmail = "Klysmus@online.de";
    lfs.enable = true;
    aliases = {
      l = "!git log";
      lo = "!git log --oneline";
      lg = "!git log --pretty=format:\"%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) [%an]\" --abbrev-commit -30";
      s = "!git status";
      co = "!git checkout";
      cob = "!git checkout -b";
      undo = "!git reset HEAD~1 --mixed";
      save = "!git add -A && git commit -m 'chore: commit save point";
      cm = "!git add -A && git commit";
      cma = "!git add -A && git commit --amend";
      cmae = "!git add -A && git commit --amend --no-edit";
      br = ''!git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate'';
      del = "!git branch -d";
    };
    extraConfig = {
      # git signing
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingKey = "~/.ssh/github_kickstart.pub";

      # sane defaults
      init.defaultBranch = "main";
      safe.directory = [ 
        "/etc/nixos"
        "/etc/nixos/user/editor/nvim"
      ];
    };
  };
}
