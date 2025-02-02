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

# Update system and upgrade
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Updating system and upgrading packages..."
log_message "$COLOR_YELLOW" "============================================"
sudo apt update && sudo apt upgrade -y || error_exit "System update/upgrade failed."

# Install Apache2
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Installing Apache2..."
log_message "$COLOR_YELLOW" "============================================"
sudo apt install apache2 -y || error_exit "Failed to install Apache2."

# Install Git
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Installing Git..."
log_message "$COLOR_YELLOW" "============================================"
sudo apt install git -y || error_exit "Failed to install Git."

# Navigate to the web directory and clone the GoPhish demo repository
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Cloning GoPhishDemo repository to /var/www/html..."
log_message "$COLOR_YELLOW" "============================================"
cd /var/www/html
sudo git clone https://github.com/el1s3k/GoPhishDemo.git || error_exit "Failed to clone GoPhishDemo repository."

# Set the correct permissions for the GoPhishDemo directory
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Setting permissions for GoPhishDemo..."
log_message "$COLOR_YELLOW" "============================================"
sudo chown -R www-data:www-data /var/www/html/GoPhishDemo || error_exit "Failed to set owner for GoPhishDemo directory."
sudo chmod -R 755 /var/www/html/GoPhishDemo || error_exit "Failed to set permissions for GoPhishDemo directory."

# Start and enable Apache2 service
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Starting and enabling Apache2..."
log_message "$COLOR_YELLOW" "============================================"
sudo systemctl start apache2 || error_exit "Failed to start Apache2."
sudo systemctl enable apache2 || error_exit "Failed to enable Apache2."

# Ask for the user input (Localhost IP address)
log_message "$COLOR_GREEN" "Enter the IP address for your localhost (e.g., 111.111.111.111):"
read user_ip

# Create the Apache virtual host configuration file
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Creating Apache virtual host configuration file in /etc/apache2/sites-available..."
log_message "$COLOR_YELLOW" "============================================"
sudo bash -c "cat > /etc/apache2/sites-available/$user_ip.conf <<EOF
<VirtualHost *:80>
    ServerName $user_ip
    DocumentRoot /var/www/html/GoPhishDemo/DemoNET

    <Directory /var/www/html/GoPhishDemo/DemoNET>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF" || error_exit "Failed to create Apache virtual host configuration file."

# Enable the new site and reload Apache
log_message "$COLOR_YELLOW" "============================================"
log_message "$COLOR_YELLOW" "Enabling Apache virtual host configuration file and reloading Apache..."
log_message "$COLOR_YELLOW" "============================================"
sudo a2ensite "$user_ip.conf" || error_exit "Failed to enable Apache virtual host configuration file."
sudo systemctl reload apache2 || error_exit "Failed to reload Apache."

log_message "$COLOR_GREEN" "============================================"
log_message "$COLOR_GREEN" "Setup completed successfully!"
log_message "$COLOR_GREEN" "============================================"
