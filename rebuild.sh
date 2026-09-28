#!/bin/bash
sudo determinate-nixd upgrade
#sudo nix flake update --commit-lock-file
nix flake update
sudo darwin-rebuild switch --flake ~/nix-darwin-config
