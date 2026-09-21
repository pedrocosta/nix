#!/bin/bash
sudo nix flake update --commit-lock-file
sudo darwin-rebuild switch --flake ~/nix-darwin-config
