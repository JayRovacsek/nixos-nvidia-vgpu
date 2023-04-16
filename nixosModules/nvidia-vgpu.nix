{ self, pkgs, lib, config, ... }:

let
  inherit (pkgs) system coreutils pciutils stdenv substituteAll;
  inherit (self.lib) requireFile;
  inherit (self.packages.${system}) vgpu-unlock nvidia-vgpu-kvm-src;

  cfg = config.hardware.nvidia.vgpu;
in with lib; {
  options = {
    hardware.nvidia.vgpu = {
      enable = mkEnableOption "vGPU support";

      unlock.enable = mkOption {
        default = false;
        type = types.bool;
        description = "Unlock vGPU functionality for consumer grade GPUs";
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable.overrideAttrs
      ({ patches ? [ ], postUnpack ? "", postPatch ? "", preFixup ? "", ... }: {
        name = "nvidia-x11-${vgpuVersion}-${gridVersion}-${config.boot.kernelPackages.kernel.version}";
        version = "${vgpuVersion}";

        src = requireFile {
          name = "NVIDIA-Linux-x86_64-${gridVersion}-grid.run";
          sha256 = "0smvmxalxv7v12m0hvd5nx16jmcc7018s8kac3ycmxam8l0k9mw9";
        };

        patches = patches ++ [ ./nvidia-vgpu-merge.patch ] ++ optional cfg.unlock.enable (substituteAll {
          src = ./nvidia-vgpu-unlock.patch;
          vgpu_unlock = vgpu-unlock.src;
        });

        postUnpack = postUnpack + ''
          # More merging, besides patch above
          ${coreutils}/bin/cp -r ${nvidia-vgpu-kvm-src}/init-scripts .
          ${coreutils}/bin/cp ${nvidia-vgpu-kvm-src}/kernel/common/inc/nv-vgpu-vfio-interface.h kernel/common/inc//nv-vgpu-vfio-interface.h
          ${coreutils}/bin/cp ${nvidia-vgpu-kvm-src}/kernel/nvidia/nv-vgpu-vfio-interface.c kernel/nvidia/nv-vgpu-vfio-interface.c
          echo "NVIDIA_SOURCES += nvidia/nv-vgpu-vfio-interface.c" >> kernel/nvidia/nvidia-sources.Kbuild
          ${coreutils}/bin/cp -r ${nvidia-vgpu-kvm-src}/kernel/nvidia-vgpu-vfio kernel/nvidia-vgpu-vfio

          for i in libnvidia-vgpu.so.${vgpuVersion} libnvidia-vgxcfg.so.${vgpuVersion} nvidia-vgpu-mgr nvidia-vgpud vgpuConfig.xml sriov-manage; do
            ${coreutils}/bin/cp ${nvidia-vgpu-kvm-src}/$i $i
          done

          ${coreutils}/bin/chmod -R u+rw .
        '';

        postPatch = postPatch + ''
          # Move path for vgpuConfig.xml into /etc
          sed -i 's|/usr/share/nvidia/vgpu|/etc/nvidia-vgpu-xxxxx|' nvidia-vgpud

          substituteInPlace sriov-manage \
            --replace lspci ${pciutils}/bin/lspci \
            --replace setpci ${pciutils}/bin/setpci
        '';

        # HACK: Using preFixup instead of postInstall since nvidia-x11 builder.sh doesn't support hooks
        preFixup = preFixup + ''
          for i in libnvidia-vgpu.so.${vgpuVersion} libnvidia-vgxcfg.so.${vgpuVersion}; do
            install -Dm755 "$i" "$out/lib/$i"
          done
          patchelf --set-rpath ${stdenv.cc.cc.lib}/lib $out/lib/libnvidia-vgpu.so.${vgpuVersion}
          install -Dm644 vgpuConfig.xml $out/vgpuConfig.xml

          for i in nvidia-vgpud nvidia-vgpu-mgr; do
            install -Dm755 "$i" "$bin/bin/$i"
            # stdenv.cc.cc.lib is for libstdc++.so needed by nvidia-vgpud
            patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath $out/lib "$bin/bin/$i"
          done
          install -Dm755 sriov-manage $bin/bin/sriov-manage
        '';
      });

    systemd.services.nvidia-vgpud = {
      description = "NVIDIA vGPU Daemon";
      wants = [ "syslog.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${optionalString cfg.unlock.enable "${vgpu_unlock}/bin/vgpu_unlock "}${
            getBin config.hardware.nvidia.package
          }/bin/nvidia-vgpud";
        ExecStopPost = "${coreutils}/bin/rm -rf /var/run/nvidia-vgpud";
        Environment = [ "__RM_NO_VERSION_CHECK=1" ];
      };
    };

    systemd.services.nvidia-vgpu-mgr = {
      description = "NVIDIA vGPU Manager Daemon";
      wants = [ "syslog.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "forking";
        KillMode = "process";
        ExecStart = "${optionalString cfg.unlock.enable "${vgpu_unlock}/bin/vgpu_unlock "}${
            getBin config.hardware.nvidia.package
          }/bin/nvidia-vgpu-mgr";
        ExecStopPost = "${coreutils}/bin/rm -rf /var/run/nvidia-vgpu-mgr";
        Environment = [ "__RM_NO_VERSION_CHECK=1" ];
      };
    };

    environment.etc."nvidia-vgpu-xxxxx/vgpuConfig.xml".source = config.hardware.nvidia.package + /vgpuConfig.xml;

    boot.kernelModules = [ "nvidia-vgpu-vfio" ];

    environment.systemPackages = with pkgs; [ mdevctl ];
    services.udev.packages = with pkgs; [ mdevctl ];
  };
}
