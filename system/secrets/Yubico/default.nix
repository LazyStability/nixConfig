{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.security.pam.u2f.enable {
  # Passwordless sudo and login
  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    u2f = {
      settings = {
        cue = true;
        origin = "pam://yubi";
        authfile = pkgs.writeText "u2f-mappings" (
          lib.concatStrings [
            "me"
            #:<KeyHandle>-----------------------------------------------------------------------------,<UserKey>--------------------------------------------------------------------------,<CoseType>,<Options>
            ":p5c+EGqUoz7ToB1eGM8myz+nWPNrYNqdDSPdAdbAZfT6DmdEoz2/KNJfHXGjpBkyro8GQXMN677dYQb6Xg8+8Q==,V63FSRBq3Y+Wp7sod8IuPVrNXZqUY0pZPpeEWTGhM5wIXIDVr6VDZb0XAWI5Ql/s43kAX7NGuYiH8tqqQMn94w==,es256,+presence"
            ":mVOhL+pAF9WyngeCy3B5Dz8t839RDSmJfb8gi4bGNJmuqse7vYdXie43aW69/OCbLtJCGy2LcOn3bRBVpbDrFA==,z91rhsrMOQq4xycJcoVIG3oiKf2J2LBkBwhK+1ym4V330YGlnMZRkz2KXulr4TaK+b9DZO0XR8E4465TllZAWg==,es256,+presence"
          ]
        );
      };
    };
  };
  services.udev = {
    packages = [ pkgs.yubikey-personalization ];
    # extraRules = ''
    #   ACTION=="remove",\
    #    ENV{ID_BUS}=="usb",\
    #    ENV{ID_MODEL_ID}=="0407",\
    #    ENV{ID_VENDOR_ID}=="1050",\
    #    ENV{ID_VENDOR}=="Yubico",\
    #    RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    # '';
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # pinentryPackage = pkgs.pinentry-all;
  };
  environment.systemPackages = [
    pkgs.yubioath-flutter
    pkgs.gnupg
    pkgs.yubikey-personalization
  ];
}
