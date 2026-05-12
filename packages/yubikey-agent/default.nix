#https://github.com/go-piv/piv-go/issues/47#issuecomment-3591741307
# Use the approach here to patch https://github.com/operatorequals/vault-yubikey/tree/main
{ yubikey-agent, ... }:
yubikey-agent.overrideAttrs (oldAttrs: {
  patches = [ ./0001-feat-piv-go-permit-use-of-shared-smartcard-connectio.patch ];
  vendorHash = "sha256-8bMMyRs+o/MdEjEbrFaRu7eql1ihcqBxlNFBrtrrzpQ=";
})
