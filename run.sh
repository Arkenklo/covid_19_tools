#!/bin/bash

# Quit this script if any command fails
set -e

# If on ubuntu (or debian), install some prerequisites
if [ -f /etc/lsb-release ] && (! dpkg -s python3-venv libnss3 libgconf-2-4 xvfb > /dev/null || ! which google-chrome) > /dev/null; then
  # Install Google Chrome
  curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo -- sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
  sudo apt-get update
  sudo apt-get install -y google-chrome-stable
  # Install python3 virtualenv
  sudo apt-get install -y python3-venv
  # Install prerequisites for headless chromedriver
  sudo apt-get install -y libnss3 libgconf-2-4 xvfb
fi

# Setup virtualenv and install requirements
python3 -m venv env
source env/bin/activate
pip3 install -r requirements.txt

# Do some Linux-only cheats to get chromedriver to work
cd env/
ln -s chromedriver-Linux64 chromedriver || true # || true is to ignore errors if link exists
cd ..
PATH=$PATH:./env/

# Convert notebooks to python
jupyter nbconvert website_updates.ipynb --to python
jupyter nbconvert nhs_advice.ipynb --to python

# Run the scripts
echo Running ./website_updates.py
python3 ./website_updates.py

echo Running ./nhs_advice.py
python3 ./nhs_advice.py
