#!/bin/bash
nix flake update
sudo darwin-rebuild switch --flake ~/nix-darwin-config
