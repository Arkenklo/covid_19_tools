#!/bin/bash

# Quit this script if any command fails
set -e

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
#python3 ./website_updates.py
python3 ./nhs_advice.py
