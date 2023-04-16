{ self }: { nvidia-vgpu = import ./nvidia-vgpu.nix { inherit self; }; }
