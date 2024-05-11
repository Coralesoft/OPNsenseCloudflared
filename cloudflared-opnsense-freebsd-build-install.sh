#!/bin/sh
# Cloudflared build and install for OPNsense & FreeBSD
# Script will:
#    - Create the build environment
#    - Pull the latest cloudflared source from GitHub
#    - Build the cloudflared binary
#    - Install cloudflared binary for use
#    - Remove the build and source environments
#
# To update / upgrade cloudflared binary just rerun the Script
#
# Last revised 11/05/2024
# version 2024.5.2
#-----------------------------------------------------------------------
# Version     Date          Notes:
# 2024.5.1    10.05.2024    Inital Release
# 2024.5.2    11.05.2024    Script updates
#
# Copyright (C) 2024 C. Brown (dev@coralesoft.nz)
# Released under the MIT License

# Install required tools
pkg install -y nano wget git jq || { echo "Failed to install packages"; exit 1; }

# Variables
GO_VERSION="1.22.3"
GO_TAR_FILE="go$GO_VERSION.freebsd-amd64.tar.gz"
GO_DOWNLOAD_URL="https://go.dev/dl/$GO_TAR_FILE"
INSTALL_DIR="/usr/local"
SRC_DIR="$HOME/src"
GOPATH="$HOME/goprojects"
GOROOT="$INSTALL_DIR/go"
CLOUDFLARED_REPO="https://github.com/cloudflare/cloudflared.git"
CLOUDFLARED_DIR="$SRC_DIR/cloudflared"
GOOS_TARGET="freebsd"
GOARCH_TARGET="amd64"
SBIN_DIR="/usr/local/sbin"

# Get the latest version of Cloudflared
echo "Fetching the latest Cloudflared version..."
LATEST=$(curl -sL https://api.github.com/repos/cloudflare/cloudflared/releases/latest | jq -r ".tag_name")
if [ -z "$LATEST" ]; then
    echo "Error fetching the latest Cloudflared version."
    exit 1
fi
echo "Latest Cloudflared version is: $LATEST"

# Calculate current build time
BUILD_TIME=$(date -u +"%Y-%m-%d-%H%M UTC")

# Create source directory
mkdir -p "$SRC_DIR"
cd "$SRC_DIR" || exit 1

# Download Go binary
if ! wget "$GO_DOWNLOAD_URL"; then
    echo "Error downloading Go $GO_VERSION. Please check the download URL."
    exit 1
fi

# Extract the Go tarball
tar -xf "$GO_TAR_FILE"

# Move Go to the installation directory
sudo mv go "$INSTALL_DIR"

# Set environment variables for the script's execution
export GOROOT=$GOROOT
export GOPATH=$GOPATH
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Clone the cloudflared repository
if ! git clone "$CLOUDFLARED_REPO" "$CLOUDFLARED_DIR"; then
    echo "Error cloning cloudflared repository. Please check the repository URL."
    exit 1
fi

# Modify main.go with the latest version and calculated build time
cd "$CLOUDFLARED_DIR/cmd/cloudflared" || exit 1
if [ ! -f main.go ]; then
    echo "main.go not found."
    exit 1
fi

awk '/var \(/{flag=1} flag; /}/{flag=0}' main.go | sed -i '' \
    -e 's/^[[:blank:]]*Version[[:blank:]]*=[[:blank:]]*"[^"]*"/    Version = "'"$LATEST"'"/' \
    -e 's/^[[:blank:]]*BuildTime[[:blank:]]*=[[:blank:]]*"[^"]*"/    BuildTime = "'"$BUILD_TIME"'"/' main.go

# Prepare to build cloudflared
echo "Preparing to build cloudflared with GOOS=$GOOS_TARGET and GOARCH=$GOARCH_TARGET..."
echo "Starting the build process in 5 seconds..."
sleep 5

# Build cloudflared with GOOS and GOARCH specified
GOOS=$GOOS_TARGET GOARCH=$GOARCH_TARGET go build -a "$CLOUDFLARED_DIR/cmd/cloudflared"

# Copy the cloudflared binary to /usr/local/sbin
if [ -f "./cloudflared" ]; then
    sudo mv ./cloudflared "$SBIN_DIR/"
    echo "**************************************"
    echo "***    Build was successful        ***"
    echo "**************************************"
    echo "cloudflared binary moved to $SBIN_DIR."
else
    echo "Error: cloudflared binary not found."
    exit 1
fi

# Clean up: remove tar file and other unnecessary directories
echo "Cleaning up installation files and directories..."
rm -rf "$GO_TAR_FILE" "$GOROOT" "$GOPATH" "$SRC_DIR"
echo "Cleanup completed successfully."
