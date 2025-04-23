let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQUQQWdmgdktQTRgBq0phM5fh5+QCBBtaeGmUouWwkv Klysmus@online.de";
  users = [ user1 ];

  systems = [ ];
in
{
  "dungeondraft-key.age".publicKeys = [ user1 ];
  "userpassword.age".publicKeys = [ user1 ];
  "Games.age".publicKeys = [ user1 ];
  "ArchKey.age".publicKeys = [ user1 ];
}
