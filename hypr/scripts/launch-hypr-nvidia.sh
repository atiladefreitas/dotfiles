#!/bin/bash

# Force NVIDIA GPU
export WLR_DRM_DEVICES=/dev/dri/card1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export LIBVA_DRIVER_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __GL_GSYNC_ALLOWED=1
export __GL_VRR_ALLOWED=1

# Launch Hyprland
exec Hyprland
