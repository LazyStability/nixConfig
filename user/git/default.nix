{
  ...
}:
{
  # configure git
  programs.git = {
    enable = true;
    userName = "LazyStability";
    userEmail = "LazilyStable@proton.me";
    lfs.enable = true;
    aliases = {
      l = "!git log";
      lo = "!git log --oneline";
      lg = "!git log --pretty=format:\"%C(magenta)%h%Creset %G? -%C(red)%d%Creset %s %C(dim green)(%cr) [%an]\" --abbrev-commit -30";
      s = "!git status";
      co = "!git checkout";
      cob = "!git checkout -b";
      undo = "!git reset HEAD~1 --mixed";
      save = "!git add -A && git commit -m 'chore: commit save point'";
      cm = "!git commit";
      cma = "!git commit --amend";
      cmae = "!git commit --amend --no-edit";
      acm = "!git add -A && git commit";
      acma = "!git add -A && git commit --amend";
      acmae = "!git add -A && git commit --amend --no-edit";
      br = ''!git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate'';
      del = "!git branch -d";
      recommit = "!git commit -e --file=$(git rev-parse --git-dir)/COMMIT_EDITMSG";
    };
    extraConfig = {
      # git signing
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      gpg.ssh.defaultKeyCommand = "ssh-add -L | grep -i 'Klysmus'";

      # sane defaults
      init.defaultBranch = "main";
      safe.directory = [
        "/etc/nixos"
        "/etc/nixos/user/editor/nvim"
        "/persist/etc/nixos"
      ];
    };
  };
}
