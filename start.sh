#!/usr/bin/env bash
# init.sh — Initialization script for Chronos Orchestrator on macOS
# This script prepares the .env file and checks prerequisites.

set -euo pipefail
IFS=$'\n\t'

# Function to print messages
info() { echo "[INFO] $*"; }
error() { echo "[ERROR] $*" >&2; exit 1; }

# Check if a command exists
check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        error "Required command '$1' not found. Please install it before proceeding."
    fi
}

info "Checking prerequisites..."
check_command brew         # Ensure Homebrew is available
check_command docker       # Docker CLI
check_command docker-compose

# Check for OpenSSL; on macOS it's usually available
if ! command -v openssl >/dev/null 2>&1; then
    info "OpenSSL not found; attempting to install via Homebrew..."
    if brew install openssl; then
        info "OpenSSL installed successfully."
        # Add OpenSSL to PATH if needed
        export PATH="$(brew --prefix openssl)/bin:$PATH"
    else
        error "Failed to install OpenSSL. Please install it manually."
    fi
else
    info "OpenSSL is already installed."
fi

# Prepare .env
if [[ -f .env ]]; then
    info ".env already exists — skipping template copy."
else
    if [[ -f .env.template ]]; then
        info "Copying .env.template to .env"
        cp .env.template .env
        info ".env created from template."
    else
        info "No .env.template found; creating empty .env"
        touch .env
    fi
fi

# Generate a Fernet key for Airflow if not present
if grep -q '^AIRFLOW__CORE__FERNET_KEY=' .env; then
    info "FERNET_KEY already set in .env"
else
    info "Generating AIRFLOW__CORE__FERNET_KEY via OpenSSL..."
    FERNET_KEY=$(openssl rand -base64 32)
    echo "AIRFLOW__CORE__FERNET_KEY=$FERNET_KEY" >> .env
    info "FERNET_KEY appended to .env"
fi

info "Initialization complete. Environment is ready."
