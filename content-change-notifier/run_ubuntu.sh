#!/bin/bash

# Quit this script if any command fails
set -e

# If on ubuntu (or debian), install some prerequisites
if [ -f /etc/lsb-release ] && ! dpkg -s python3-venv > /dev/null; then
  # Install python3 virtualenv
  sudo apt-get install -y python3-venv
fi

# Setup virtualenv and install requirements
python3 -m venv env
source env/bin/activate
pip3 install -r requirements.txt > /dev/null

# Run the script
python3 ./content_updates.py
