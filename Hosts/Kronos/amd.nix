{
  config,
  pkgs,
  ...
}:
{
  # hardware.graphics.enable = true;
  hardware.graphics = {
    enable = true;
  };
  hardware.amdgpu.overdrive = {
    enable = true;
    ppfeaturemask = "0xffffffff";
  };
  services.lact.enable = true;
  # Load "amamd driver for Xorg and wayland
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Fixes suspend issues
  # boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hardware.amdgpu = {
    initrd.enable = true;
  };
  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
}
