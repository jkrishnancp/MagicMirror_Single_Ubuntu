#!/bin/bash

# Function to update and install necessary dependencies
install_dependencies() {
  echo "Updating system and installing dependencies..."
  sudo apt-get update
  sudo apt-get install -y git nodejs npm curl
  echo "Dependencies installed!"
}

# Function to check if nodejs is installed, if not install it
check_node() {
  if ! command -v node >/dev/null 2>&1; then
    echo "Node.js is not installed. Installing Node.js..."
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get install -y nodejs
  else
    echo "Node.js is already installed."
  fi
}

# Function to install Magic Mirror
install_magic_mirror() {
  echo "Cloning Magic Mirror repository..."
  if [ ! -d "$HOME/MagicMirror" ]; then
    git clone https://github.com/MichMich/MagicMirror.git ~/MagicMirror
  else
    echo "Magic Mirror directory already exists. Pulling the latest changes..."
    cd ~/MagicMirror && git pull
  fi

  echo "Installing Magic Mirror dependencies..."
  cd ~/MagicMirror
  npm install --only=prod --omit=dev
}

# Function to configure Magic Mirror for network access
configure_network_access() {
  echo "Configuring network access..."
  config_file="$HOME/MagicMirror/config/config.js.sample"
  target_config="$HOME/MagicMirror/config/config.js"

  if [ -f "$config_file" ]; then
    cp "$config_file" "$target_config"
    # Modify the ipWhitelist to allow network access
    sed -i "s/ipWhitelist: \[.*\]/ipWhitelist: \[\]/g" "$target_config"
    echo "Network access configured. Magic Mirror is now accessible from any device in the network."
  else
    echo "Sample config file not found!"
  fi
}

# Function to start Magic Mirror
start_magic_mirror() {
  echo "Starting Magic Mirror..."
  npm run start --prefix ~/MagicMirror
}

# Main function to install and configure Magic Mirror
main() {
  echo "Installing Magic Mirror on your Ubuntu device..."
  
  install_dependencies
  check_node
  install_magic_mirror
  configure_network_access
  start_magic_mirror

  echo "Magic Mirror installation and setup complete. Access it via any device on your network!"
}

# Execute the main function
main
