

#!/bin/sh
pkg install nano wget git
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
GOARCH_TARGET="amd64"  # Update this as needed
SBIN_DIR="/usr/local/sbin"

# Create source directory
mkdir -p "$SRC_DIR"
cd "$SRC_DIR" || exit

# Download Go binary
if ! wget "$GO_DOWNLOAD_URL"; then
    echo "Error downloading Go $GO_VERSION. Please check the download URL."
    exit 1
fi

# Extract the Go tarball
tar -xvf "$GO_TAR_FILE"

# Move Go to the installation directory
sudo mv go "$INSTALL_DIR"

# Set environment variables for the script's execution
export GOROOT=$GOROOT
export GOPATH=$GOPATH
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Check Go version and environment variables
go version
go env

# Clone the cloudflared repository
if ! git clone "$CLOUDFLARED_REPO" "$CLOUDFLARED_DIR"; then
    echo "Error cloning cloudflared repository. Please check the repository URL."
    exit 1
fi

# Prepare to build cloudflared
cd "$CLOUDFLARED_DIR" || exit
echo "Preparing to build cloudflared with GOOS=$GOOS_TARGET and GOARCH=$GOARCH_TARGET..."
echo "Starting the build process in 5 seconds..."
sleep 5

# Build cloudflared with GOOS and GOARCH specified
GOOS=$GOOS_TARGET GOARCH=$GOARCH_TARGET go build -v -a /root/src/cloudflared/cmd/cloudflared

# Copy the cloudflared binary to /usr/local/sbin
if [ -f "./cloudflared" ]; then
    sudo mv ./cloudflared "$SBIN_DIR/"
	echo "**************************************"
	echo "***    Build was successfull       ***"
	echo "**************************************"
    echo "cloudflared binary moved to $SBIN_DIR."
else
    echo "Error: cloudflared binary not found."
    exit 1
fi

# Clean up: remove tar file, GOPATH, GOROOT, and the source directory
echo "Cleaning up installation files and directories..."
rm -rf "$GO_TAR_FILE" "$GOROOT" "$GOPATH" "$SRC_DIR"
echo "Cleanup completed successfully."
