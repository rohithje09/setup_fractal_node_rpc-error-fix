#!/bin/bash

# Constants
RELEASE_URL="https://github.com/fractal-bitcoin/fractald-release/releases/download/v0.2.1/fractald-0.2.1-x86_64-linux-gnu.tar.gz"
RELEASE_TAR="fractald-0.2.1-x86_64-linux-gnu.tar.gz"
EXTRACTED_DIR="fractald-0.2.1-x86_64-linux-gnu"
BITCOIN_CONF_PATH="./data/bitcoin.conf"
BITCOIN_PORT=8333
RPC_PORT=8332

# Error handling
set -e

# Function to print messages
print_message() {
    echo "[INFO] $1"
}

# Function to print error messages and exit
print_error() {
    echo "[ERROR] $1" >&2
    exit 1
}

# Delete existing wallet (optional step, uncomment if needed)
# print_message "Deleting existing wallet..."
# yarn cli wallet delete || print_error "Failed to delete wallet"

# Stop the bitcoind Docker container
print_message "Stopping bitcoind Docker container..."
sudo docker stop tracker-bitcoind-1 || print_error "Failed to stop bitcoind Docker container"

# Download and extract fractald release
print_message "Downloading fractald release..."
wget $RELEASE_URL -O $RELEASE_TAR || print_error "Failed to download fractald release"

print_message "Extracting fractald release..."
tar -zxvf $RELEASE_TAR || print_error "Failed to extract fractald release"

cd $EXTRACTED_DIR || print_error "Failed to change directory to $EXTRACTED_DIR"

# Set up data directory and configure bitcoin.conf
print_message "Setting up data directory..."
mkdir -p data
cp ./bitcoin.conf ./data/ || print_error "Failed to copy bitcoin.conf"

print_message "Configuring bitcoin.conf..."
cat <<EOF > $BITCOIN_CONF_PATH
port=$BITCOIN_PORT
txindex=1
server=1
rest=1
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
rpcport=$RPC_PORT
rpcuser=bitcoin
rpcpassword=opcatAwesome
rpcworkqueue=2048
rpcthreads=32
rpcservertimeout=120
zmqpubhashblock=tcp://0.0.0.0:8330
zmqpubrawtx=tcp://0.0.0.0:8331
maxconnections=50
debug=bench
debug=netmsg
EOF

# Run the Bitcoin daemon
print_message "Running the Bitcoin daemon..."
./bin/bitcoind -datadir=./data/ -maxtipage=504576000 || print_error "Failed to start bitcoind"

# Create and fund the wallet
print_message "Creating a wallet..."
yarn cli wallet create || print_error "Failed to create wallet"

print_message "Setup complete. Enjoy!"

# Optional: Clean up
print_message "Cleaning up..."
cd ..
rm -rf $EXTRACTED_DIR $RELEASE_TAR || print_error "Failed to clean up"

print_message "Done."
