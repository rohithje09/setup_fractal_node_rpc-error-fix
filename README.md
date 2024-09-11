# Fractal Node Setup Script

This repository contains a script to set up and run a Fractal Bitcoin node manually.

## Overview

The `setup_fractal_node.sh` script automates the following tasks:
1. Downloads and extracts the Fractal node release.
2. Configures the Bitcoin node by modifying the `bitcoin.conf` file.
3. Starts the Bitcoin daemon.
4. Creates a wallet using the Fractal CLI.
5. Provides instructions to fund the wallet.

## Prerequisites

- A server or local machine with Linux
- Docker (for stopping the bitcoind container)
- `wget` and `tar` for downloading and extracting files
- `yarn` for managing JavaScript packages

## Getting Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/rohithje09/setup_fractal_node_rpc-error-fix.git
   cd setup_fractal_node_rpc-error-fix
