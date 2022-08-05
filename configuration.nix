# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ /etc/nixos/hardware-configuration.nix];
  
  boot = {
    tmpOnTmpfs = true;
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    blacklistedKernelModules = [ "nouveau" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";


  
  # services.xserver.
  # Configure keymap in X11
  services.xserver = {
    enable = true;
    layout = "us,ru";
    xkbOptions = "caps:escape";
    displayManager = {
      sddm.enable = true;
    };
    #windowManager.awesome = {
    #  enable = true;
    #  luaModules = with pkgs.luaPackages; [
	#luarocks
	#luadbi-mysql
      #];
    #};
    desktopManager.plasma5.enable = true;
  };


  # services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  programs.fish.enable = true;

  users = {
    defaultUserShell = "/run/current-system/sw/bin/fish";
    extraUsers.alepon = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "audio" "plugdev"];
      uid = 1000;
      shell = pkgs.fish;
    };
  };
  environment.systemPackages = with pkgs; [
    wget
    git
    vivaldi
    curl
    gimp
    pavucontrol
    neovim
    unzip
    discord
    kitty
    fish
    exa 
    cargo
    cmake
    rustc
    rustup
    lldb_14
    llvmPackages_14.bintools
    llvmPackages_14.clang
    llvmPackages_14.stdenv
    bat
    du-dust
    exa
    fd
    hyperfine
    ripgrep
    tokei
  ];

   nixpkgs.config = {
    allowUnfree = true; # Allow "unfree" packages.

    firefox.enableAdobeFlash = true;
    chromium.enablePepperFlash = true;
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
    	(nerdfonts.override { fonts = ["JetBrainsMono"];})
    ];
  };
  time.hardwareClockInLocalTime = true;
  system.stateVersion = "22.05";
}

