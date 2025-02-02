#!/bin/bash

# Enable error trapping: Exit the script if any command fails
set -e

# Colors for visual appeal
COLOR_RESET="\e[0m"
COLOR_YELLOW="\e[33m"
COLOR_GREEN="\e[32m"
COLOR_RED="\e[31m"
COLOR_BLUE="\e[34m"
COLOR_CYAN="\e[36m"

# Function to handle errors
error_exit() {
    echo -e "${COLOR_RED}[ERROR] $1${COLOR_RESET}"
    exit 1
}

# Function to display a progress message with optional success
log_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${COLOR_RESET}"
}

# Update and upgrade the system
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Updating and upgrading system..."
log_message "$COLOR_YELLOW" "============================================"
sudo apt update && sudo apt upgrade -y || error_exit "System update/upgrade failed."

# Install jq
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Installing jq..."
log_message "$COLOR_YELLOW" "============================================"
sudo apt install jq -y || error_exit "Failed to install jq."

# Install unzip
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Installing unzip..."
log_message "$COLOR_YELLOW" "============================================"
sudo apt install unzip -y || error_exit "Failed to install unzip."

# Create directories and download GoPhish
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Creating GoPhish directory ~/gophish..."
log_message "$COLOR_YELLOW" "============================================"
mkdir -p ~/gophish || error_exit "Failed to create GoPhish directory."
cd ~/gophish

# Enter repo URL
log_message "$COLOR_GREEN" "Enter the download link for GoPhish (e.g., https://github.com/el1s3k/GoPhishDemo.git):"
read dlink
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Downloading GoPhish to ~/gophish..."
log_message "$COLOR_YELLOW" "============================================"
wget "$dlink" || error_exit "Failed to download GoPhish."

# Unzip GoPhish
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Unzipping GoPhish in ~/gophish..."
log_message "$COLOR_YELLOW" "============================================"
file_path=$(find ~/gophish -type f -iname "*gophish*zip") || error_exit "Failed to find GoPhish zip file."
unzip "$file_path" || error_exit "Failed to unzip GoPhish."

# Edit config.json
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Editing admin server in config.json file..."
log_message "$COLOR_YELLOW" "============================================"

# Define json file path
json_file="config.json"

# Modify the 'admin_server' listen_url to "0.0.0.0:3333"
jq '.admin_server.listen_url = "0.0.0.0:3333"' "$json_file" > tmp.json && mv tmp.json "$json_file" || error_exit "Failed to modify config.json."

# Verify the change by printing the modified JSON
log_message "$COLOR_GREEN" "Updated 'admin_server.listen_url' to '0.0.0.0:3333' in '$json_file'"

# Change permissions of GoPhish file
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Changing permissions of GoPhish file to be executable..."
log_message "$COLOR_YELLOW" "============================================"
chmod +x gophish || error_exit "Failed to change permissions of GoPhish file."

# Create directories and download MailHog
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Creating MailHog directory ~/mailhog..."
log_message "$COLOR_YELLOW" "============================================"
mkdir -p ~/mailhog || error_exit "Failed to create MailHog directory."
cd ~/mailhog

# Enter repo URL
log_message "$COLOR_GREEN" "Enter the download link for MailHog (e.g., https://github.com/mailhog/MailHog.git):"
read dlink
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Downloading MailHog to ~/mailhog..."
log_message "$COLOR_YELLOW" "============================================"
wget "$dlink" || error_exit "Failed to download MailHog."

# Change permissions of MailHog_linux_amd64 file
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Changing permissions of MailHog file to be executable..."
log_message "$COLOR_YELLOW" "============================================"
file_path=$(find ~/mailhog -type f -iname "*MailHog*") || error_exit "Failed to find MailHog file."
chmod +x "$file_path" || error_exit "Failed to change permissions of MailHog file."

cd ~

log_message "$COLOR_GREEN" "============================================"
log_message "$COLOR_GREEN" "Script completed successfully!"
log_message "$COLOR_GREEN" "============================================"
