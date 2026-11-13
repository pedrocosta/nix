#!/bin/bash
sudo determinate-nixd upgrade
#sudo nix flake update --commit-lock-file

brew trust riscv-software-src/riscv

nix flake update
sudo darwin-rebuild switch --flake ~/nix-darwin-config
